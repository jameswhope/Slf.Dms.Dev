Imports System.Data
Imports System.IO

Imports Drg.Util.DataAccess

Partial Class UserControl_DocumentsControl
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Private _UserID As Integer
    Private docList As New Hashtable 'keeps track of grid doc groups

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum enumDocumentType
        Client = 0
        Creditor = 1
        Note = 3
    End Enum

    #End Region 'Enumerations

    #Region "Events"

    Public Event Document_Error(ByVal errorSource As String, ByVal errorMessage As String)

    #End Region 'Events

    #Region "Properties"

    Public Property CreditorAccountID() As Integer
        Get
            Return ViewState("CreditorAccountID").ToString
        End Get
        Set(ByVal value As Integer)
            ViewState("CreditorAccountID") = value
        End Set
    End Property

    Public Property DataClientID() As Integer
        Get
            Return ViewState("dataclientid").ToString
        End Get
        Set(ByVal value As Integer)
            ViewState("dataclientid") = value
        End Set
    End Property

    Public ReadOnly Property DocumentCount() As Integer
        Get
            Return gvDocs.Rows.Count
        End Get
    End Property

    Public Property DocumentType() As enumDocumentType
        Get
            Return ViewState("DocumentType")
        End Get
        Set(ByVal value As enumDocumentType)
            ViewState("DocumentType") = value
        End Set
    End Property

    Public Property NoteID() As Integer
        Get
            Return ViewState("NoteID").ToString
        End Get
        Set(ByVal value As Integer)
            ViewState("NoteID") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Sub BuildDocumentTree()
        Try
            Select Case DocumentType
                Case enumDocumentType.Client
                    dsDocs.SelectCommand = "stp_documents_getClientDocumentsInfo"
                    dsDocs.SelectParameters.Clear()
                    Dim qp As New WebControls.Parameter("clientid", DbType.Int32, DataClientID.ToString)
                    dsDocs.SelectParameters.Add(qp)

                Case enumDocumentType.Creditor
                    dsDocs.SelectCommand = "stp_documents_getClientCreditorDocumentsInfo"
                    dsDocs.SelectParameters.Clear()
                    Dim qp As New WebControls.Parameter("clientid", DbType.Int32, DataClientID.ToString)
                    dsDocs.SelectParameters.Add(qp)
                    qp = New WebControls.Parameter("credAcctID", DbType.Int32, CreditorAccountID.ToString)
                    dsDocs.SelectParameters.Add(qp)

                Case enumDocumentType.Note
                    dsDocs.SelectCommand = "stp_documents_getClientNoteDocumentsInfo"
                    dsDocs.SelectParameters.Clear()
                    Dim qp As New WebControls.Parameter("noteid", DbType.Int32, NoteID.ToString)
                    dsDocs.SelectParameters.Add(qp)

            End Select

            dsDocs.DataBind()
            gvDocs.DataBind()
        Catch ex As Exception
            RaiseEvent Document_Error("BuildDocumentTree", ex.Message.ToString)
        End Try
    End Sub

    Public Sub DeleteDocs()
        Dim currentRowsFilePath As String
        Try
            'Enumerate the GridViewRows
            For index As Integer = 0 To gvDocs.Rows.Count - 1
                'Programmatically access the CheckBox from the TemplateField
                Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvDocs.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

                'If it's checked, delete it...
                If cb.Checked Then
                    currentRowsFilePath = gvDocs.DataKeys(index).Value
                    If File.Exists(currentRowsFilePath) Then
                        File.Delete(currentRowsFilePath)
                    End If
                    SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(Path.GetFileName(currentRowsFilePath), _UserID)
                End If
            Next
        Catch ex As Exception
            RaiseEvent Document_Error("DeleteDocs", ex.Message.ToString)
        End Try
       
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

    Protected Sub UserControl_DocumentsControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        
    End Sub

    Protected Sub gvDocs_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocs.RowCreated
        If e.Row.RowType = DataControlRowType.Pager Then
            SetPagerButtonStates(gvDocs, e.Row, Me.Page)
        End If
    End Sub

    Protected Sub gvDocs_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocs.RowDataBound
        Try
            Select Case e.Row.RowType
                Case DataControlRowType.DataRow
                    'get row data
                    Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                    Dim rptName As String = rowView("displayName").ToString
                    Dim rptNameStripped As String = rptName.Replace(" ", "").Replace("-", "").Replace("'", "").Replace(".", "")
                    Dim childCount As Integer = rowView("rowNum").ToString

                    'show treeview image for expansion
                    If docList.Contains(rptName) = True Then
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", rptNameStripped, e.Row.RowIndex))
                        Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                        imgTree.Visible = False
                        e.Row.Style("display") = "none"
                    Else
                        docList.Add(rptName, Nothing)
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", rptNameStripped))
                        Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                        If childCount > 1 Then
                            imgTree.Attributes.Add("onclick", "toggleDocument('" & rptNameStripped & "','" & gvDocs.ClientID & "');")
                        Else
                            imgTree.Visible = False
                        End If
                    End If

                    'get pdf path
                    Dim newName As String = ""
                    Dim pdfPath As String = rowView("pdfPAth").ToString
                    newName = LocalHelper.GetVirtualDocFullPath(pdfPath)
                    'add row events
                    e.Row.Style("cursor") = "hand"
                    If File.Exists(pdfPath.Replace("\", "\\")) = False Then
                        Dim jsText As String = String.Format("alert('{0} cannot be found on the network.');", rptName)
                        e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FA8072")
                        e.Row.Attributes.Add("ondblclick", jsText)
                        e.Row.ToolTip = "Document not found."
                    Else
                        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#F0F5FB'; this.style.filter = 'alpha(opacity=75)';")
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                        e.Row.Attributes.Add("ondblclick", "javascript:OpenDocument('" + newName + "');")
                        e.Row.ToolTip = "Double click to view document."
                    End If
            End Select
        Catch ex As Exception
            RaiseEvent Document_Error("gvDocs_RowDataBound", ex.Message.ToString)
        End Try

    End Sub

    Private Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        gvDocs.PageIndex = ddl.SelectedIndex
        gvDocs.DataBind()
    End Sub

    #End Region 'Methods

End Class