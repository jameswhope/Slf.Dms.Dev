Imports Drg.Util.DataAccess

Imports SharedFunctions
Imports System.Data

Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO

Partial Class util_pop_Uploadmatterdocument
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private ClientID As Integer
    Private DocumentRoot As String
    Private AccountNumber As String
    Private MatterNumber As String
    Private RelationType As String
    Private RelationID As Integer
    Private CreditorInstanceId As Integer
    Private IsTemp As Boolean
    Public AddRelationID As Integer
    Public AddRelationType As String
    Private ContextSensitive As String
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
        ClientID = Integer.Parse(Request.QueryString("id"))
        RelationType = Request.QueryString("type").ToString()
        RelationID = Integer.Parse(Request.QueryString("rel"))
        CreditorInstanceId = Integer.Parse(Request.QueryString("ciid"))
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString())
        MatterNumber = DataHelper.FieldLookup("tblMatter", "MatterNumber", "MatterID = " + RelationID.ToString())
        'MatterTypeId = Request.QueryString("typeid")
        'strMatterTypeCode = DataHelper.FieldLookup("tblmattertype", "MatterTypeCode", "MatterTypeId = " + MatterTypeId.ToString())

        '********Code fr OS'
        'If ConfigurationManager.AppSettings("FolderPath").ToString() = "local" Then

        '    ' ****Local box ****
        '    DocumentRoot = Server.MapPath("~/") + DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber + "\" '+ strMatterTypeCode + "\" + RelationID + "\"
        'Else

        '    '*** Production /QA***
        '    DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
        '       DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber '+ "\" + strMatterTypeCode + "\" + RelationID
        'End If
        '********End Code fr OS'

        '*** Production /QA***
        DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
           DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber



        If Request.QueryString("temp") Is Nothing Then
            IsTemp = False
        Else
            IsTemp = True
        End If

        If Not Request.QueryString("addrelid") Is Nothing Then
            AddRelationID = Integer.Parse(Request.QueryString("addrelid"))
            AddRelationType = Request.QueryString("addrel")
        Else
            AddRelationID = 0
        End If

        If Not Request.QueryString("context") Is Nothing Then
            ContextSensitive = Request.QueryString("context")
        Else
            ContextSensitive = ""
        End If

        If Not IsPostBack Then
            FillDocumentTypes()

        End If
    End Sub

    Private Sub FillDocumentTypes()

        ' List only DocumentType related to matter
        'Dim cmdStr As String = "SELECT DisplayName+'-'+TypeId as DisplayName, TypeID FROM tblDocumentType WHERE DocumentTypeID in (SELECT DocumentTypeID FROM " + _
        '"tblScanRelation WHERE RelationType in ('" + IIf(ContextSensitive.Length > 0, ContextSensitive, RelationType) + "')) ORDER BY DisplayName"

        'Dim cmdStr As String = "SELECT TypeDisplayName, TypeID FROM tblDocumentType  ORDER BY DisplayName"
        Dim cmdStr As String = "SELECT DisplayName+'-'+TypeId as DisplayName, TypeID FROM tblDocumentType where typeId LIKE '%M%' order by DisplayName"

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

    Protected Sub lnkDocUploaded_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDocUploaded.Click
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            Dim filename As String = txtFileUpload.Value
            Dim strDocType As String = ddlDocType.SelectedValue
            Dim subFolder As String = String.Empty
            Dim idx As Integer = MatterNumber.LastIndexOf("-")
            Dim StrDocumentName As String = String.Empty
            Dim strAccount As String = String.Empty
            Dim strDocID As String = String.Empty
            Dim strFileExtn As String = String.Empty
            Dim strCreditorname As String = String.Empty
            Dim strCreditorFolder As String = String.Empty
            Dim currentdatetime As DateTime = DateTime.Now

            If idx > -1 Then
                strAccount = MatterNumber.Substring(idx + 1)
            End If
            strDocID = ReportsHelper.GetNewDocID '"A" + currentdatetime.ToString("yyMMddHHmm")

            subFolder = DataHelper.FieldLookup("tblDocumentType", "DocFolder", "TypeID = '" + strDocType.ToString() + "'")

            StrDocumentName = AccountNumber + "_" + strDocType + "_" + strDocID + "_" + DateTime.Now.ToString("yyMMdd") 'Year(Now()).ToString() + Month(Now()).ToString() + Day(Now()).ToString()
            strFileExtn = filename.Substring(filename.LastIndexOf(".") + 1)

            StrDocumentName = StrDocumentName + "." + strFileExtn

            If CreditorInstanceId > 0 Then
                cmd.Connection.Open()
                cmd.CommandText = "select R.Name from tblcreditorinstance C, tblCreditor R where C.CreditorID=R.CreditorID and C.CreditorInstanceID = " & CreditorInstanceId.ToString()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
                If rd.Read() Then
                    strCreditorname = DatabaseHelper.Peel_string(rd, "Name")
                End If
                rd.Close()

                strCreditorFolder = CreditorInstanceId.ToString() & "_" & strCreditorname
            End If

            If CreditorInstanceId > 0 Then
            	If Not Directory.Exists(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder) Then

                	Directory.CreateDirectory(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder)

            	End If

            		txtFileUpload.PostedFile.SaveAs(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder + "\" + StrDocumentName)
 		Else

   		If Not Directory.Exists(DocumentRoot + "\" + subFolder) Then
                        Directory.CreateDirectory(DocumentRoot + "\" + subFolder)
                    End If

                    txtFileUpload.PostedFile.SaveAs(DocumentRoot + "\" + subFolder + "\" + StrDocumentName)
                End If


            '*** Code for the storage Location ***

            'If ConfigurationManager.AppSettings("FolderPath").ToString() = "local" Then
            '    '**** Local Box  Location ****
            '    If Not Directory.Exists(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/{3}", AccountNumber, subFolder, strMatterTypeCode, RelationID)) Then
            '        Directory.CreateDirectory(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/{3}/", AccountNumber, subFolder, strMatterTypeCode, RelationID))
            '    End If

            '    txtFileUpload.PostedFile.SaveAs(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/{3}/", AccountNumber, subFolder, strMatterTypeCode, RelationID) & StrDocumentName)

            '    '*** End Local box location *****
            'Else
            '    ' Check if Directory sub folder with creditor instance Id exists
            '    If Not Directory.Exists(DocumentRoot + "\" + subFolder + "\" + strMatterTypeCode + "\" + RelationID + "\") Then
            '        Directory.CreateDirectory(DocumentRoot + "\" + subFolder + "\" + strMatterTypeCode + "\" + RelationID + "\")
            '    End If
            '    txtFileUpload.PostedFile.SaveAs(DocumentRoot + "\" + subFolder + "\" + strMatterTypeCode + "\" + RelationID + "\" + StrDocumentName)

            '    'If Not Directory.Exists(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder) Then
            '    '    Directory.CreateDirectory(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder)
            '    'End If
            '    'txtFileUpload.PostedFile.SaveAs(DocumentRoot + "\" + subFolder + "\" + strCreditorFolder + "\" + StrDocumentName)
            'End If
            '**** End Code for storage Location 

            Try
                Dim docSubFolder As String = ""
                If CreditorInstanceId > 0 Then
                    docSubFolder = CreditorInstanceId.ToString() & "_" & strCreditorname & "\"
                Else
                    docSubFolder = "\"
                End If

                'If Not cmd.Connection.State = ConnectionState.Open Then cmd.Connection.Open()
                'cmd.CommandText = "insert into tbldocscan(docid, created,receiveddate,createdby)  values(@DocID, @currentdatetime, @currentdatetime, @UserID)"
                'DatabaseHelper.AddParameter(cmd, "docid", strDocID)
                'DatabaseHelper.AddParameter(cmd, "currentdatetime", currentdatetime)
                'DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                'cmd.ExecuteNonQuery()

                'cmd.Parameters.Clear()
                'cmd.CommandText = "insert into tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder, RelatedDate, RelatedBy, DeletedFlag, DeletedDate, DeletedBy)  values (@ClientID, @RelationID, @RelationType, @DocTypeID, @RelDocID, @DateString, @SubFolder, @currentdatetime, @RelatedBy, 0, @currentdatetime, -1)"
                'DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                'DatabaseHelper.AddParameter(cmd, "RelationID", RelationID)
                'DatabaseHelper.AddParameter(cmd, "RelationType", "matter")
                'DatabaseHelper.AddParameter(cmd, "DocTypeID", strDocType)
                'DatabaseHelper.AddParameter(cmd, "RelDocID", strDocID)
                'DatabaseHelper.AddParameter(cmd, "DateString", currentdatetime.ToString("yyMMdd"))

                'DatabaseHelper.AddParameter(cmd, "SubFolder", docSubFolder)

                'DatabaseHelper.AddParameter(cmd, "currentdatetime", currentdatetime)
                'DatabaseHelper.AddParameter(cmd, "RelatedBy", UserID)
                'cmd.ExecuteNonQuery()

                DocumentAttachment.AttachDocument("matter", RelationID, strDocType, strDocID, currentdatetime.ToString("yyMMdd"), ClientID, docSubFolder)
                DocumentAttachment.CreateScan(strDocID, UserID, currentdatetime)
                'save doc descr
                '6.8.11.ug
                Dim docDesc As String = txtDescr.Text
                If Not String.IsNullOrEmpty(docDesc) Then
                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter("DocID", Path.GetFileNameWithoutExtension(filename).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2)))
                    params.Add(New SqlParameter("Description", docDesc))
                    params.Add(New SqlParameter("UserID", UserID))
                    SqlHelper.ExecuteNonQuery("stp_scanning_insertScanDescription", CommandType.StoredProcedure, params.ToArray)
                End If


                ' this method is obsolete pls change to ClientScript.RegisterClientScriptBlock
                ClientScript.RegisterClientScriptBlock(Me.GetType, "onload", "<script> window.onload = function() { CloseUpload(); } </script>")

                'lblMsg.Text = "Matter Document uploaded successfully"
            Catch ex As Exception
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class