Imports System.IO
Imports Drg.Util.DataAccess
Imports System.Configuration
Imports System.Text
Imports System.Data.SqlClient

Public Class SettlementAcceptanceForm

    Dim rptConnectionString As String

    Public Sub New()
        rptConnectionString = System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString
    End Sub

    Public Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String
        Dim tempDir As String

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " & ClientID.ToString(), New SqlConnection(rptConnectionString))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        rootDir = "\\" & DatabaseHelper.Peel_string(reader, "StorageServer") & "\" & DatabaseHelper.Peel_string(reader, "StorageRoot") & "\" & DatabaseHelper.Peel_string(reader, "AccountNumber") & "\"
                    Else
                        Throw New Exception("Invalid client. Please contact support.")
                    End If
                End Using

                If Not Directory.Exists(rootDir) Then
                    Directory.CreateDirectory(rootDir)
                End If

                cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder "

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = rootDir & DatabaseHelper.Peel_string(reader, "Name")

                        If Not Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using

                Dim sbSql As New StringBuilder
                sbSql.Append("SELECT CurrentCreditorInstanceID, AccountID, [Name], Original ")
                sbSql.Append("FROM (SELECT a.CurrentCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original ")
                sbSql.Append("FROM  tblAccount a INNER JOIN ")
                sbSql.Append("tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN ")
                sbSql.Append("tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN ")
                sbSql.Append("tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN ")
                sbSql.Append("tblCreditor cr2 on c2.CreditorID = cr2.CreditorID ")
                sbSql.AppendFormat("WHERE (a.ClientID = {0}) ", ClientID.ToString())
                sbSql.Append("UNION ")
                sbSql.Append("SELECT a.OriginalCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original ")
                sbSql.Append("FROM  tblAccount a INNER JOIN ")
                sbSql.Append("tblCreditorInstance c1 on a.OriginalCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN ")
                sbSql.Append("tblCreditorInstance c2 on a.OriginalCreditorInstanceID = c2.CreditorInstanceID INNER JOIN ")
                sbSql.Append("tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN ")
                sbSql.Append("tblCreditor cr2 on c2.CreditorID = cr2.CreditorID ")
                sbSql.AppendFormat("WHERE (a.ClientID = {0}) ", ClientID.ToString())
                sbSql.Append(") as AllCreditors ORDER BY [Name] ASC ")

                cmd.CommandText = sbSql.ToString

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString() 'Regex.Replace("", "^[a-zA-Z0-9]+$", "", RegexOptions.IgnoreCase)
                        tempDir = rootDir & "CreditorDocs\" & tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")

                        If Not System.IO.Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using
            End Using
        End Using

        Return rootDir
    End Function

    Public Function GetUniqueDocumentName2(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = rootDir + subFolder + GetAccountNumber(conn, ClientID) + "_" + strDocTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function

    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        If conn.State = ConnectionState.Closed Then conn.Open()

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

    Private Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function


End Class