Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports System.IO

Partial Class clients_client_docs_default
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private ClientID As Integer
    Private DocumentRoot As String
#End Region

#Region "Structures"
    Public Structure DocScan
        Public DocumentName As String
        Public Received As String
        Public Created As String
        Public CreatedBy As String

        Public Sub New(ByVal _DocumentName As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.DocumentName = _DocumentName
            Me.Received = _Received
            Me.Created = _Created
            Me.CreatedBy = _CreatedBy
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        '*******************************************************************
        'BUG ID: 560
        'Fixed By: Bereket S. Data
        'Validate Id before proceeding with subsequent operation.
        '*******************************************************************
        If (IsNumeric(Request.QueryString("id")) = True) Then
            ClientID = Integer.Parse(Request.QueryString("id"))
            DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + _
            DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()) + "\ClientDocs"

            tdNoDir.Visible = False

            If Not IsPostBack Then
                LoadPrimaryPerson()
                BuildDocumentTree()
            End If
        End If
    End Sub

    Private Function LoadDoc(ByVal documentName As String, Optional ByRef outDocID As String = "") As DocScan
        Dim final As DocScan
        Dim docID As String
        Dim docTypeID As String
        Dim idx1 As Integer = documentName.IndexOf("_", 0) + 1
        Dim idx2 As Integer = documentName.IndexOf("_", idx1)

        docTypeID = documentName.Substring(idx1, idx2 - idx1)

        idx1 = documentName.IndexOf("_", idx2) + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)
        outDocID = docID

        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, 'NA') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocScan as ds left join tblUser as u on u.UserID = ds.CreatedBy left join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' WHERE ds.DocID = '" + docID + "'"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        final = New DocScan(DataHelper.Nz(reader("DisplayName"), "NA"), IIf(Date.Parse(reader("Received")).Year = 1900, "&nbsp;", Date.Parse(reader("Received")).ToString("d")), IIf(Date.Parse(reader("Created")).Year = 1900, "&nbsp;", Date.Parse(reader("Created")).ToString("d")), DataHelper.Nz(reader("CreatedBy"), "NA"))
                    Else
                        final = New DocScan(documentName, "", "", "")
                    End If
                End Using

                If final.Created.Length = 0 Then
                    cmd.CommandText = "SELECT dt.DisplayName, '01-01-1900' as Received, isnull(dr.RelatedDate, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocRelation as dr left join tblUser as u on u.UserID = dr.RelatedBy inner join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' WHERE dr.DocID = '" + docID + "'"

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            final = New DocScan(reader("DisplayName"), IIf(Date.Parse(reader("Received")).Year = 1900, "&nbsp;", Date.Parse(reader("Received")).ToString("d")), IIf(Date.Parse(reader("Created")).Year = 1900, "&nbsp;", Date.Parse(reader("Created")).ToString("d")), reader("CreatedBy"))
                        End If
                    End Using
                End If
            End Using
        End Using

        Return final
    End Function

    Private Sub BuildDocumentTree()
        If Directory.Exists(DocumentRoot) Then
            Dim dirInfo As New DirectoryInfo(DocumentRoot)
            Dim fileList As FileInfo() = dirInfo.GetFiles()
            Dim tempDoc As DocScan
            Dim docID As String
            Dim newName As String
            Dim listFile As New List(Of FileInfo)

            trvFiles.Nodes.Clear()

            '11.24.08.ug
            'make doc 9064 the first in list always
            'find then remove from array and reinitalize without doc 9064
            '*******************************************************************************
            Dim Document_9064 As FileInfo = Array.Find(fileList, AddressOf Find_Document_9064)
            Dim Document_9019 As FileInfo = Array.Find(fileList, AddressOf Find_Document_9019)
            If Document_9064 IsNot Nothing Then
                Dim fIdx As Integer = Array.IndexOf(fileList, Document_9064)
                tempDoc = LoadDoc(Document_9064.Name, docID)
                If Request.Url.AbsoluteUri.ToLower().Contains(".com") Then
                    newName = "http://service.dmsisupport.com" & Document_9064.FullName.Substring(Document_9064.FullName.IndexOf("\", 2)).Replace("\", "/")
                Else
                    newName = "file:///" & Document_9064.FullName.Replace("\", "\\")
                End If
                trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;""><input id=""chk" + docID + """ type=""checkbox"" onpropertychange=""javascript:SelectDocument(this, '" + Document_9064.FullName.Replace("\", "\\") + "')"" runat=""server"" /></td><td style=""width:280px;"" align=""left"" onclick=""javascript:OpenDocument('" + newName + "');""><img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>"))
                Array.Clear(fileList, fIdx, 1)
            End If
            If Document_9019 IsNot Nothing Then
                Dim fIdx As Integer = Array.IndexOf(fileList, Document_9019)
                tempDoc = LoadDoc(Document_9019.Name, docID)
                If Request.Url.AbsoluteUri.ToLower().Contains(".com") Then
                    newName = "http://service.dmsisupport.com" & Document_9019.FullName.Substring(Document_9019.FullName.IndexOf("\", 2)).Replace("\", "/")
                Else
                    newName = "file:///" & Document_9019.FullName.Replace("\", "\\")
                End If
                trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;""><input id=""chk" + docID + """ type=""checkbox"" onpropertychange=""javascript:SelectDocument(this, '" + Document_9019.FullName.Replace("\", "\\") + "')"" runat=""server"" /></td><td style=""width:280px;"" align=""left"" onclick=""javascript:OpenDocument('" + newName + "');""><img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>"))
                Array.Clear(fileList, fIdx, 1)
            End If
            For Each f As FileInfo In fileList
                If f IsNot Nothing Then
                    listFile.Add(f)
                End If
            Next
            '*******************************************************************************

            For Each subFile As FileInfo In listFile

                If Not subFile.Name.Contains("__") Then
                    tempDoc = LoadDoc(subFile.Name, docID)

                    If Request.Url.AbsoluteUri.ToLower().Contains(".com") Then
                        newName = "http://service.dmsisupport.com" & subFile.FullName.Substring(subFile.FullName.IndexOf("\", 2)).Replace("\", "/")
                    Else
                        newName = "file:///" & subFile.FullName.Replace("\", "\\")
                    End If

                    trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;""><input id=""chk" + docID + """ type=""checkbox"" onpropertychange=""javascript:SelectDocument(this, '" + subFile.FullName.Replace("\", "\\") + "')"" runat=""server"" /></td><td style=""width:280px;"" align=""left"" onclick=""javascript:OpenDocument('" + newName + "');""><img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>"))
                End If
            Next
        End If
    End Sub
    Private Shared Function Find_Document_9064(ByVal f As FileInfo) As Boolean
        If f.FullName.Contains("_9064") Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Shared Function Find_Document_9019(ByVal f As FileInfo) As Boolean
        If f.FullName.Contains("_9019") Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Sub LoadPrimaryPerson()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim SSN As String = DatabaseHelper.Peel_string(rd, "SSN")

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")

                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)
                Dim AccountNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID)

                lnkName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                If SSN.Length > 0 Then
                    lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(SSN, "___-__-____", "_", StringHelper.Filter.NumericOnly) & "<br>"
                End If

                If AccountNumber.Length > 0 Then
                    lblAccountNumber.Text = AccountNumber & "<br>"
                End If

            Else
                lnkName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID)
            lnkStatus_ro.Text = lnkStatus.Text

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        For Each str As String In hdnCurrentDoc.Value.Split("|")
            If File.Exists(str) Then
                File.Delete(str)
                SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(Path.GetFileName(str), UserID)
            End If
        Next

        BuildDocumentTree()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(trAdminControls, c, "Clients-Client-Documents-Admin Controls")
    End Sub
End Class
