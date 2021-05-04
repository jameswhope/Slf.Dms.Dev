<%@ WebHandler Language="VB" Class="clients_client_reports_pdfexport" %>

Imports ClWelcomeLetter
Imports CWelcomeCallLetter
Imports ClientInfoSheet
Imports CreditorWLetter
Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess

Imports System
Imports System.Configuration
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls

Public Class clients_client_reports_pdfexport : Implements IHttpHandler : Implements IReadOnlySessionState

    Public Structure CreditorInfo
        Public CreditorID As Integer
        Public Name As String
        
        Public Sub New(ByVal id As Integer, ByVal credname As String)
            Me.CreditorID = id
            Me.Name = credname
        End Sub
    End Structure

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim ClientID = CInt(context.Session("clients_client_reports_clientid"))
        Dim UserID = CInt(context.Session("clients_client_reports_userid"))
        Dim strReports() As String = CStr(context.Session("clients_client_reports_reports")).Split(",")
        Dim asWPkg As Boolean = CStr(context.Session("clients_client_reports_reports")).Contains("WelcomePackage")
        
        Dim report As ActiveReport3
        Dim welcomePkg As New SectionReport
        Dim pdf As New PdfExport()
        
        Dim filePath As String
        Dim rootDir = CreateDirForClient(ClientID)
        Dim creditors As Dictionary(Of Integer, CreditorInfo) = GetCreditorAccounts(ClientID)
        Dim creditorID As Integer
        Dim idxCreds As Integer
        Dim tempName As String
        
        Try
            For Each strReport As String In strReports
                report = Nothing
                
                idxCreds = strReport.IndexOf("_")
                
                If idxCreds < 0 Then
                    idxCreds = strReport.Length
                End If
                
                Select Case strReport.Substring(0, idxCreds)
                    Case "WelcomeLetter"
                        report = New ClWelcomeLetter.ClientWLetter(ClientID, "ClientLetter")
                        
                        If asWPkg Then
                            report.Run(True)
                            welcomePkg.Document.Pages.Insert(welcomePkg.Document.Pages.Count, report.Document.Pages.Item(0))
                            Continue For
                        End If
                    Case "InformationSheet"
                        report = New ClientInfoSheet.ClientInfoSheet(ClientID, "InformationSheet")
                        
                        If asWPkg Then
                            report.Run(True)
                            welcomePkg.Document.Pages.Insert(welcomePkg.Document.Pages.Count, report.Document.Pages.Item(0))
                            Continue For
                        End If
                    Case "WelcomeCallLetter"
                        report = New CWelcomeCallLetter.CWelcomeCallLetter(ClientID, "ClientCallLetter")
                    Case "CreditorLetterCopies"
                        For Each credID As Integer In creditors.Keys
                            report = New CreditorWLetter.CreditorWLetter(ClientID, "CreditorLetter", credID, True)
                            
                            report.Run(True)
                            
                            If Not asWPkg Then
                                tempName = creditors(credID).Name
                                tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                                filePath = GetUniqueDocumentName(rootDir, ClientID, "CreditorLetterCopies", "CreditorDocs\" + creditors(credID).CreditorID.ToString() + "_" + tempName + "\")
                                
                                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                                    pdf.Export(report.Document, fStream)
                                End Using
                            Else
                                welcomePkg.Document.Pages.Insert(welcomePkg.Document.Pages.Count, report.Document.Pages.Item(0))
                            End If
                        Next
                        
                        Continue For
                    Case "CreditorLetters"
                        creditorID = CInt(strReport.Substring(idxCreds + 1))
                        report = New CreditorWLetter.CreditorWLetter(ClientID, "CreditorLetter", creditorID)
                        
                        report.Run(True)
                        
                        tempName = creditors(creditorID).Name
                        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                        filePath = GetUniqueDocumentName(rootDir, ClientID, "CreditorLetters", "CreditorDocs\" + creditors(creditorID).CreditorID.ToString() + "_" + tempName + "\")
                        
                        Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                            pdf.Export(report.Document, fStream)
                        End Using
                        
                        Continue For
                End Select
                
                If Not report Is Nothing Then
                    report.Run(True)
                    
                    filePath = GetUniqueDocumentName(rootDir, ClientID, strReport)
                    
                    Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                        pdf.Export(report.Document, fStream)
                    End Using
                End If
            Next
            
            If asWPkg Then
                filePath = GetUniqueDocumentName(rootDir, ClientID, "WelcomePackage")
                
                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                    pdf.Export(welcomePkg.Document, fStream)
                End Using
            End If
        Catch eRunReport As GrapeCity.ActiveReports.ReportException
            context.Response.Clear()
            context.Response.Write("<h1>Error running report:</h1><br />")
            context.Response.Write(eRunReport.ToString())
            Return
        End Try
        
        SetPrinted(strReports, ClientID, UserID)
        
        context.Response.Redirect("report.aspx?clientid=" + ClientID.ToString() + "&reports=" + CStr(context.Session("clients_client_reports_reports")) + "&user=-1")
    End Sub
    
    Private Function GetUniqueDocumentName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal docType As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String
        Using conn As SqlConnection = ConnectionFactory.Create()
            conn.Open()
            ret = rootDir + subFolder + GetAccountNumber(conn, ClientID) + "_" + GetDocTypeID(conn, docType) + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using
        
        Return ret
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
    
    Private Function GetDocTypeID(ByVal conn As SqlConnection, ByVal docType As String) As String
        Dim docTypeID As String = ""
        
        Using cmd As New SqlCommand("SELECT count(*) FROM tblDocumentType WHERE TypeName = '" + docType + "'", conn)
                If cmd.ExecuteScalar() > 0 Then
                    cmd.CommandText = "SELECT TypeID FROM tblDocumentType WHERE TypeName = '" + docType + "'"
                    docTypeID = cmd.ExecuteScalar().ToString()
                End If
        End Using
        
        Return docTypeID
    End Function
    
    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String
        
        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
                accountno = cmd.ExecuteScalar().ToString()
        End Using
        
        Return accountno
    End Function
    
    Private Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String
        Dim tempDir As String
        
        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    reader.Read()
                    rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                End Using
                
                If Not Directory.Exists(rootDir)
                    Directory.CreateDirectory(rootDir)
                End If
                
                cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder "
                
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = rootDir + DatabaseHelper.Peel_string(reader, "Name")
                            
                        If Not Directory.Exists(tempDir)
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using
                    
                cmd.CommandText = "SELECT a.AccountID, cr1.[Name], cr2.[Name] as Original " _
                    + "FROM  tblAccount a INNER JOIN " _
                    + "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN " _
                    + "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN " _
                    + "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN " _
                    + "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID " _
                    + "WHERE a.ClientID = " + ClientID.ToString() + " ORDER BY cr1.[Name] ASC"
                    
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString() 'Regex.Replace("", "^[a-zA-Z0-9]+$", "", RegexOptions.IgnoreCase)
                        tempDir = rootDir + "CreditorDocs\" + tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")

                        If Not System.IO.Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using
            End Using
        End Using
        
        Return rootDir
    End Function
    
    Private Sub SetPrinted(ByVal letters() As String, ByVal ClientID As Integer, ByVal UserID As Integer)
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                For Each letter As String In letters
                    Try
                        cmd.CommandText = "UPDATE tblClient SET Sent" + letter + " = getdate(), SentBy" + letter + " = " + UserID.ToString() + " WHERE ClientID = " + ClientID.ToString()
                        cmd.ExecuteNonQuery()
                    Catch ex As SqlException
                        Continue For
                    End Try
                Next
            End Using
        End Using
    End Sub
    
    Private Function GetCreditorAccounts(ByVal ClientID As String) As Dictionary(Of Integer, CreditorInfo)
        Dim creditors As New Dictionary(Of Integer, CreditorInfo)
        Dim strSQL As String = "SELECT a.CurrentCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original " _
            + "FROM  tblAccount a INNER JOIN " _
            + "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN " _
            + "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN " _
            + "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN " _
            + "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID " _
            + "WHERE a.ClientID = " + ClientID.ToString() + " ORDER BY cr1.[Name] ASC"
        
        Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        creditors.Add(CInt(DatabaseHelper.Peel_int(reader, "CurrentCreditorInstanceID")), New CreditorInfo(DatabaseHelper.Peel_int(reader, "AccountID"), DatabaseHelper.Peel_string(reader, "Name").ToString()))
                    End While
                End Using
            End Using
        End Using
        
        Return creditors
    End Function
    
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class