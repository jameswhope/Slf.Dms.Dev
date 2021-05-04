Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports Microsoft.Azure
Imports Microsoft.WindowsAzure
'Imports Microsoft.WindowsAzure.Blob

Partial Class clients_client_docs_default
    Inherits PermissionPage

    #Region "Fields"

    Private ClientID As Integer
    Private DocumentRoot As String
    Private UserID As Integer

    #End Region 'Fields

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(trAdminControls, c, "Clients-Client-Documents-Admin Controls")
    End Sub

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        '*******************************************************************
        'BUG ID: 560
        'Fixed By: Bereket S. Data
        'Validate Id before proceeding with subsequent operation.
        '*******************************************************************
        If (IsNumeric(Request.QueryString("id")) = True) Then
            ClientID = Integer.Parse(Request.QueryString("id"))
            DocumentRoot = "http://" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "/" +
            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "/" +
            DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString())  '+ "/doctestfolder"

            tdNoDir.Visible = False

            If Not IsPostBack Then
                ViewState("sortDir") = "Asc"
                LoadPrimaryPerson()
                'BuildDocumentTree()
                BuildDocumentGrid()
            End If
        End If
    End Sub

    Protected Sub gvDocuments_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvDocuments.PageIndexChanging
        gvDocuments.PageIndex = e.NewPageIndex
        BuildDocumentGrid()
    End Sub

    Protected Sub gvDocuments_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocuments.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvDocuments, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvDocuments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocuments.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow

                GridViewHelper.styleGridviewRows(e)

                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = TryCast(e.Row.FindControl("lnkDocument"), LinkButton)
                If Not IsNothing(lnk) Then
                    lnk.OnClientClick = String.Format("OpenDocument('{0}');", rowview("fileurl").ToString)
                End If

        End Select
    End Sub

    Protected Sub gvDocuments_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvDocuments.Sorting
        BuildDocumentGrid(e.SortExpression, ViewState("sortDir"))

        Select Case ViewState("sortDir").ToString.ToUpper
            Case "Asc".ToUpper
                ViewState("sortDir") = "DESC"
            Case Else
                ViewState("sortDir") = "ASC"
        End Select
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        Dim currentRowsFilePath As String
        Try
            'Enumerate the GridViewRows
            For index As Integer = 0 To gvDocuments.Rows.Count - 1
                'Programmatically access the CheckBox from the TemplateField
                Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvDocuments.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

                'If it's checked, delete it...
                If cb.Checked Then
                    currentRowsFilePath = gvDocuments.DataKeys(index).Value
                    If File.Exists(currentRowsFilePath) Then
                        File.Delete(currentRowsFilePath)
                    End If
                    SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(Path.GetFileName(currentRowsFilePath), UserID)
                End If
            Next
        Catch ex As Exception
            Throw
        End Try

        BuildDocumentGrid()

        'For Each str As String In hdnCurrentDoc.Value.Split("|")
        '    If File.Exists(str) Then
        '        File.Delete(str)
        '        SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(Path.GetFileName(str), UserID)
        '    End If
        'Next
        'BuildDocumentTree()
    End Sub

    Private Shared Function Find_Document_9019(ByVal f As FileInfo) As Boolean
        If f.FullName.Contains("_9019") Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Shared Function Find_Document_9064(ByVal f As FileInfo) As Boolean
        If f.FullName.Contains("_9064") Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub BuildDocumentGrid(Optional ByVal sortField As String = Nothing, Optional ByVal sortOrder As String = "ASC")
        Dim dt As New DataTable
        Dim bc As New DataColumn("docID")
        Dim colList As New List(Of DataColumn)
        colList.Add(New DataColumn("docID"))
        colList.Add(New DataColumn("DocumentName"))
        colList.Add(New DataColumn("Received", System.Type.GetType("System.DateTime")))
        colList.Add(New DataColumn("Created", System.Type.GetType("System.DateTime")))
        colList.Add(New DataColumn("CreatedBy"))
        colList.Add(New DataColumn("FileUrl"))
        dt.Columns.AddRange(colList.ToArray)

        'If Directory.Exists(DocumentRoot) Then
        '***************************************
        'Dim netCall As System.Net.HttpWebRequest = System.Net.HttpWebRequest.Create(DocumentRoot)
        'Dim resp As System.Net.HttpWebResponse = Nothing

        'Try
        '    resp = netCall.GetResponse()
        '    If resp.StatusCode = System.Net.HttpStatusCode.OK Then MsgBox("Found file")
        'Catch
        '    If resp.StatusCode = System.Net.HttpStatusCode.NotFound Then MsgBox("File not found")
        'End Try

        '*************************************************
        'Dim dirInfo As New DirectoryInfo(DocumentRoot)
        'Dim fileList As FileInfo() = dirInfo.GetFiles()
        Dim tempDoc As DocScan
        Dim docID As String
        Dim newName As String
        Dim listFile As New List(Of FileInfo)

        trvFiles.Nodes.Clear()

        Dim listofDocuments As New List(Of String)
        listofDocuments = AzureStorageHelper.GetClientsFiles(DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()), "ClientDocs")
        Dim diction As Dictionary(Of String, String) = New Dictionary(Of String, String)() 'cholt 4/13/2020
        Dim queryString = "select distinct TypeId, DisplayName from tblDocumentType where DocFolder = 'ClientDocs'"
        Dim dt2 As New DataTable
        dt2 = SqlHelper.GetDataTable(queryString, CommandType.Text)
        For Each row In dt2.Rows
            diction.Add(row(0), row(1))
        Next


        For Each f As String In listofDocuments
            If f IsNot Nothing Then
                'listFile.Add(f)
                If Not f.Contains("__") Then
                    Dim strlst As String() = f.Split(New Char() {"/"c})
                    Dim filename As String = strlst(6).ToString()
                    tempDoc = LoadDoc(filename, docID)
                    tempDoc.Received = tempDoc.Received.Replace("&nbsp;", "")

                    Dim strDocType As String() = filename.Split(New Char() {"_"c})
                    For index = 1 To strDocType.Length - 1
                        'cholt 4/13/2020

                        If diction.ContainsKey(strDocType(index).ToString) Then
                            tempDoc.DocumentName = diction.Item(strDocType(index).ToString)
                        End If

                    Next
                    newName = f
                    Dim dr As DataRow = dt.NewRow
                    dr("docID") = docID
                    dr("DocumentName") = tempDoc.DocumentName
                    dr("Received") = IIf(String.IsNullOrEmpty(tempDoc.Received), DBNull.Value, tempDoc.Received)
                    dr("Created") = IIf(String.IsNullOrEmpty(tempDoc.Created), DBNull.Value, tempDoc.Created)
                    dr("CreatedBy") = tempDoc.CreatedBy

                    dr("FileUrl") = newName
                    dt.Rows.Add(dr)
                End If

            End If
        Next

        '11.24.08.ug
        'make doc 9064 the first in list always
        'find then remove from array and reinitalize without doc 9064
        '*******************************************************************************
        'Dim Document_9064 As FileInfo = Array.Find(fileList, AddressOf Find_Document_9064)
        'Dim Document_9019 As FileInfo = Array.Find(fileList, AddressOf Find_Document_9019)
        'If Document_9064 IsNot Nothing Then
        '    Dim fIdx As Integer = Array.IndexOf(fileList, Document_9064)
        '    tempDoc = LoadDoc(Document_9064.Name, docID)
        '    newName = LocalHelper.GetVirtualDocFullPath(Document_9064.FullName)
        '    Dim dr As DataRow = dt.NewRow
        '    dr("docID") = docID
        '    dr("DocumentName") = tempDoc.DocumentName
        '    dr("Received") = tempDoc.Received
        '    dr("Created") = tempDoc.Created
        '    dr("CreatedBy") = tempDoc.CreatedBy
        '    dr("FileUrl") = newName
        '    dt.Rows.Add(dr)
        '    Array.Clear(fileList, fIdx, 1)
        'End If
        'If Document_9019 IsNot Nothing Then
        '    Dim fIdx As Integer = Array.IndexOf(fileList, Document_9019)
        '    tempDoc = LoadDoc(Document_9019.Name, docID)
        '    newName = LocalHelper.GetVirtualDocFullPath(Document_9019.FullName)
        '    Dim dr As DataRow = dt.NewRow
        '    dr("docID") = docID
        '    dr("DocumentName") = tempDoc.DocumentName
        '    dr("Received") = tempDoc.Received
        '    dr("Created") = tempDoc.Created
        '    dr("CreatedBy") = tempDoc.CreatedBy
        '    dr("FileUrl") = newName
        '    dt.Rows.Add(dr)
        '    Array.Clear(fileList, fIdx, 1)
        'End If
        'For Each f As FileInfo In fileList
        '    If f IsNot Nothing Then
        '        listFile.Add(f)

        '    End If
        'Next
        '*******************************************************************************



        'For Each subFile As FileInfo In listFile

        '    If Not subFile.Name.Contains("__") Then
        '        tempDoc = LoadDoc(subFile.Name, docID)
        '        tempDoc.Received = tempDoc.Received.Replace("&nbsp;", "")
        '        newName = LocalHelper.GetVirtualDocFullPath(subFile.FullName)
        '        Dim dr As DataRow = dt.NewRow
        '        dr("docID") = docID
        '        dr("DocumentName") = tempDoc.DocumentName
        '        dr("Received") = IIf(String.IsNullOrEmpty(tempDoc.Received), DBNull.Value, tempDoc.Received)
        '        dr("Created") = IIf(String.IsNullOrEmpty(tempDoc.Created), DBNull.Value, tempDoc.Created)
        '        dr("CreatedBy") = tempDoc.CreatedBy

        '        dr("FileUrl") = newName
        '        dt.Rows.Add(dr)
        '    End If
        'Next
        'End If

        If Not IsNothing(sortField) Then
            dt.DefaultView.Sort = String.Format("{0} {1}", sortField, sortOrder)
        Else
            dt.DefaultView.Sort = "Created DESC"
        End If

        ViewState("gvdocs") = dt
        gvDocuments.DataSource = ViewState("gvdocs")
        gvDocuments.DataBind()
    End Sub

    Private Sub BuildDocumentTree()
        Dim dt As New DataTable

        'trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"">
        '<tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;"">
        '<input id=""chk" +
        Dim bc As New DataColumn("docID")
        Dim colList As New List(Of DataColumn)
        colList.Add(New DataColumn("docID"))
        colList.Add(New DataColumn("DocumentName"))
        colList.Add(New DataColumn("Received"))
        colList.Add(New DataColumn("Created"))
        colList.Add(New DataColumn("CreatedBy"))
        dt.Columns.AddRange(colList.ToArray)

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
                newName = LocalHelper.GetVirtualDocFullPath(Document_9064.FullName)
                Dim dr As DataRow = dt.NewRow
                dr("docID") = docID
                dr("DocumentName") = tempDoc.DocumentName
                dr("Received") = tempDoc.Received
                dr("Created") = tempDoc.Created
                dr("CreatedBy") = tempDoc.CreatedBy
                dt.Rows.Add(dr)

                trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;""><input id=""chk" + docID + """ type=""checkbox"" onpropertychange=""javascript:SelectDocument(this, '" + Document_9064.FullName.Replace("\", "\\") + "')"" runat=""server"" /></td><td style=""width:280px;"" align=""left"" onclick=""javascript:OpenDocument('" + newName + "');""><img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>"))
                Array.Clear(fileList, fIdx, 1)
            End If
            If Document_9019 IsNot Nothing Then
                Dim fIdx As Integer = Array.IndexOf(fileList, Document_9019)
                tempDoc = LoadDoc(Document_9019.Name, docID)
                newName = LocalHelper.GetVirtualDocFullPath(Document_9019.FullName)
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
                    Dim dr As DataRow = dt.NewRow
                    dr("docID") = docID
                    dr("DocumentName") = tempDoc.DocumentName
                    dr("Received") = tempDoc.Received
                    dr("Created") = tempDoc.Created
                    dr("CreatedBy") = tempDoc.CreatedBy
                    dt.Rows.Add(dr)
                    newName = LocalHelper.GetVirtualDocFullPath(subFile.FullName)
                    trvFiles.Nodes.Add(New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:25px;""><input id=""chk" + docID + """ type=""checkbox"" onpropertychange=""javascript:SelectDocument(this, '" + subFile.FullName.Replace("\", "\\") + "')"" runat=""server"" /></td><td style=""width:280px;"" align=""left"" onclick=""javascript:OpenDocument('" + newName + "');""><img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>"))
                End If
            Next
        End If
        gvDocuments.DataSource = dt
        gvDocuments.DataBind()
    End Sub

    Private Function LoadDoc(ByVal documentName As String, Optional ByRef outDocID As String = "") As DocScan
        Dim final As DocScan
        Dim docID As String
        Dim docTypeID As String
        'Dim idx1 As Integer = documentName.IndexOf("_", 0) + 1
        'Dim idx2 As Integer = documentName.IndexOf("_", idx1)

        If documentName = "Thumbs.db" Then
            Exit Function
        End If
        docTypeID = documentName '.Substring(idx1, idx2 - idx1)

        'idx1 = documentName.IndexOf("_", idx2) + 1
        'idx2 = documentName.IndexOf("_", idx1)

        docID = documentName '.Substring(idx1, idx2 - idx1)
        outDocID = docID

        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, 'NA') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, 'NA') as CreatedBy FROM tblDocScan as ds left join tblUser as u on u.UserID = ds.CreatedBy left join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' inner join tblusergroup as ug on ug.usergroupid = u.usergroupid WHERE ds.DocID = '" + docID + "'"

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
                    cmd.CommandText = "SELECT dt.DisplayName, '01-01-1900' as Received, isnull(dr.RelatedDate, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, 'NA') as CreatedBy FROM tblDocRelation as dr left join tblUser as u on u.UserID = dr.RelatedBy inner join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' inner join tblusergroup as ug on ug.usergroupid = u.usergroupid WHERE dr.DocID = '" + docID + "'"

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

    Private Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        gvDocuments.PageIndex = ddl.SelectedIndex
        BuildDocumentGrid()
    End Sub

    #End Region 'Methods

    #Region "Nested Types"

    Public Structure DocScan

        #Region "Fields"

        Public Created As String
        Public CreatedBy As String
        Public DocumentName As String
        Public Received As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal _DocumentName As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.DocumentName = _DocumentName
            Me.Received = _Received
            Me.Created = _Created
            Me.CreatedBy = _CreatedBy
        End Sub

        #End Region 'Constructors

    End Structure

    #End Region 'Nested Types

End Class