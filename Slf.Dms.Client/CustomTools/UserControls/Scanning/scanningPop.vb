Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Threading
Imports iTextSharp.text.pdf

Partial Class CustomTools_UserControls_ScanningPop
    Inherits System.Web.UI.Page

#Region "Variables"
    Public UserID As Integer
    Public ClientID As Integer
    Public RelationType As String
    Public RelationID As Integer
    Private IsTemp As Boolean
    Private AddRelationID As Integer
    Private AddRelationType As String
    Private ContextSensitive As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        ClientID = Integer.Parse(Request.QueryString("id"))
        RelationType = Request.QueryString("type").ToString()
        RelationID = Integer.Parse(Request.QueryString("rel"))

        If Request.QueryString("temp") Is Nothing Then
            IsTemp = False
        Else
            IsTemp = True
        End If

        If Not Request.QueryString("addrel") Is Nothing Then
            AddRelationType = Request.QueryString("addrel")
        Else
            AddRelationType = ""
        End If

        If Not Request.QueryString("addrelid") Is Nothing Then
            AddRelationID = Integer.Parse(Request.QueryString("addrelid"))
        Else
            AddRelationID = 0
        End If

        If Not Request.QueryString("context") Is Nothing Then
            ContextSensitive = Request.QueryString("context")
        Else
            ContextSensitive = ""
        End If

        SetRollups()

        If Not IsPostBack Then
            FillDocumentTypes()
            txtDate.Text = Format(Now, "MM/dd/yyyy")
        End If
    End Sub

    Private Sub FillDocumentTypes()
        Dim cmdStr As String = "stp_lettertemplates_listScanDocuments"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDocType.Items.Add(New ListItem(TruncateString(reader("DisplayName").ToString(), 100), reader("TypeID").ToString()))
                    End While
                End Using
            End Using
        End Using

        ddlDocType.Items.Add(New ListItem("-- SELECT --", "SELECT"))
        ddlDocType.SelectedValue = "SELECT"
    End Sub

    Private Function TruncateString(ByVal str As String, ByVal length As Integer) As String
        If str.Length > length Then
            str = str.Substring(0, length - 3) + "..."
        End If

        Return str
    End Function

    Protected Sub lnkSave_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim tempFile As String = "\\Nas02\ScanTemp\" + RelationType + "_" + RelationID.ToString() + "_" + UserID.ToString() + ".pdf"
        Dim rootDir As String = CreateDirForClient()
        Dim subFolder As String = DataHelper.FieldLookup("tblDocumentType", "DocFolder", "TypeID = '" + ddlDocType.SelectedValue + "'") + "\"
        Dim credFolder As String = ""

        If File.Exists(tempFile) Then
            Dim dt As Date
            Dim filename As String = GetUniqueDocumentName(ddlDocType.SelectedValue)

            If Not DateTime.TryParse(txtDate.Text, dt) Then
                lblNote.Text = "An error occurred processing the received date!"
                lblNote.Visible = True

                Return
            End If

            If subFolder = "CreditorDocs\" And Not IsTemp Then
                If DataHelper.FieldCount("tblAccount", "AccountID", "ClientID = " + ClientID.ToString() + " and AccountID = " + RelationID.ToString()) > 0 Then
                    credFolder = DataHelper.Nz(SharedFunctions.DocumentAttachment.GetCreditorDir(RelationID), "")
                ElseIf DataHelper.FieldCount("tblAccount", "AccountID", "ClientID = " + ClientID.ToString() + " and AccountID = " + AddRelationID.ToString()) > 0 Then
                    credFolder = DataHelper.Nz(SharedFunctions.DocumentAttachment.GetCreditorDir(AddRelationID), "")
                Else
                    credFolder = ""
                End If
            End If

            Try
                File.Move(tempFile, rootDir + subFolder + credFolder + filename)
            Catch ex As IOException
                lblNote.Text = "Move " & tempFile & " to " & rootDir & subFolder & filename
                lblNote.Visible = True
                Exit Sub
            End Try

            If IsTemp Then
                SharedFunctions.DocumentAttachment.AttachDocumentToTemp(RelationType, RelationID, filename, UserID)

                If AddRelationID > 0 Then
                    SharedFunctions.DocumentAttachment.AttachDocument(AddRelationType, AddRelationID, filename, UserID)
                End If
            Else
                SharedFunctions.DocumentAttachment.AttachDocument(RelationType, RelationID, filename, UserID, credFolder)

                If AddRelationID > 0 Then
                    SharedFunctions.DocumentAttachment.AttachDocument(AddRelationType, AddRelationID, filename, UserID, credFolder)
                End If
            End If

            SharedFunctions.DocumentAttachment.CreateScan(filename, UserID, dt, "")

            lblNote.Text = "Document saved!"
            lblNote.Visible = True
        Else
            lblNote.Text = "No scan found!"
            lblNote.Visible = True
        End If
    End Sub

    Private Function CreateDirForClient() As String
        Dim rootDir As String
        Dim tempDir As String
        Dim x As Integer

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    reader.Read()
                    rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                End Using

                If Not Directory.Exists(rootDir) Then
                    Directory.CreateDirectory(rootDir)
                    If Not Directory.Exists(rootDir) Then
                        For x = 1 To 30
                            Thread.Sleep(100)
                            If Not Directory.Exists(rootDir) Then
                                Directory.CreateDirectory(rootDir)
                            Else
                                Exit For
                            End If
                        Next
                    End If
                End If

                cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder"

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = rootDir + DatabaseHelper.Peel_string(reader, "Name")
                        If Not Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                            If Not Directory.Exists(tempDir) Then
                                For x = 1 To 30
                                    Thread.Sleep(100)
                                    If Not Directory.Exists(tempDir) Then
                                        Directory.CreateDirectory(tempDir)
                                    Else
                                        Exit For
                                    End If
                                Next
                            End If
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
                        tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString()
                        tempDir = rootDir + "CreditorDocs\" + tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Replace("?", "_")

                        If Not System.IO.Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                            If Not Directory.Exists(tempDir) Then
                                For x = 1 To 30
                                    Thread.Sleep(100)
                                    If Not Directory.Exists(tempDir) Then
                                        Directory.CreateDirectory(tempDir)
                                    Else
                                        Exit For
                                    End If
                                Next
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        Return rootDir
    End Function

    Private Function GetUniqueDocumentName(ByVal docTypeID As String) As String
        Dim ret As String

        Using conn As SqlConnection = ConnectionFactory.Create()
            conn.Open()
            ret = GetAccountNumber(conn, ClientID) + "_" + docTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
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

    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

    Private Sub SetRollups()

    End Sub
End Class
