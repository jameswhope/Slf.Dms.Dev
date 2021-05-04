Option Explicit On
'Option Strict On

Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data
Imports LexxiomLetterTemplates

Partial Class admin_settings_attorneys
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private objAttorney As Lexxiom.BusinessServices.Attorney
    Private tblRelationTypes As DataTable
#End Region

#Region "Structures"
    Public Structure Attorney
        Public AttorneyID As Integer
        Public FullName As String
        Public Relation As String
        'Public IsStatePrimary As String
        'Public StatePrimary As String
        Public AttyUserID As Integer
        Public Associated As String

        Public Sub New(ByVal intAttorneyID As Integer, ByVal fullname As String, ByVal rel As String, ByVal user As Integer, ByVal sAssociated As String) ', ByVal sStatePrimary As String, ByVal sIsStatePrimary As String
            Me.AttorneyID = intAttorneyID
            Me.FullName = fullname
            Me.Relation = rel
            'Me.StatePrimary = sStatePrimary
            'Me.IsStatePrimary = sIsStatePrimary
            Me.AttyUserID = user
            Me.Associated = sAssociated
        End Sub
    End Structure
#End Region

    Protected Property RelationTypes() As DataTable
        Get
            Return tblRelationTypes
        End Get
        Set(ByVal value As DataTable)
            tblRelationTypes = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim li As ListItem

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNothing(objAttorney) Then
            objAttorney = New Lexxiom.BusinessServices.Attorney
        End If

        If Not IsPostBack Then
            LoadCompanies()

            If IsNumeric(Request.QueryString("id")) Then
                'User came from settlement attorney screen
                li = ddlCompanyMain.Items.FindByValue(Request.QueryString("id"))
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If

            LoadAttorneys(CType(ddlCompanyMain.SelectedItem.Value, Integer))
        End If

        AddTasks()
        ApplySecurity()
    End Sub

    Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Changes</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Create_Sample();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_search.png") & """ align=""absmiddle""/>View Sample Letter</a>")
		CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""../settings""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel</a>")
    End Sub

    Private Sub ApplySecurity()
        Dim intUserRole As Integer = Drg.Util.DataHelpers.UserHelper.GetUserRole(UserID)

        Select Case intUserRole
            Case 6, 11 'Admin, Sys Admin
                'do nothing
            Case Else
                'apply security features here.
        End Select
    End Sub

    Protected Sub ddlCompanyMain_OnSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompanyMain.SelectedIndexChanged
        LoadAttorneys(CType(ddlCompanyMain.SelectedItem.Value, Integer))
        trInfoBox.Visible = False
    End Sub

    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click
        LoadAttorneys(CType(ddlCompanyMain.SelectedItem.Value, Integer), txtSearch.Text.Trim)
        trInfoBox.Visible = False
    End Sub

    Private Sub LoadAttorneys(ByVal intCompanyID As Integer, Optional ByVal strSearchCriteria As String = "")
        Dim attorneys As New List(Of Attorney)
        Dim tblAttorneys As DataTable = objAttorney.GetAttorneyListing(intCompanyID, strSearchCriteria)
        Dim row As DataRow

        For Each row In tblAttorneys.Rows
            attorneys.Add(New Attorney(CInt(row("AttorneyID")), row("FullName").ToString, row("Relation").ToString, CInt(row("UserID")), row("Associated").ToString)) ', row("StatePrimary").ToString, row("IsStatePrimary").ToString
        Next

        tblRelationTypes = objAttorney.GetAttorneyRelationTypes(True)

        rptAttorneys.DataSource = attorneys
        rptAttorneys.DataBind()
    End Sub

    Private Sub LoadCompanies()
        Dim objCompany As New Lexxiom.BusinessServices.Company

        ddlCompanyMain.DataSource = objCompany.CompanyList
        ddlCompanyMain.DataTextField = "ShortCoName"
        ddlCompanyMain.DataValueField = "CompanyID"
        ddlCompanyMain.DataBind()

        objCompany = Nothing
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub rptAttorneys_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptAttorneys.ItemDataBound
        Dim ddl As DropDownList
        Dim rel As HiddenField
        Dim li As ListItem

        'Selecting the attorney's current relation to this company
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            ddl = e.Item.FindControl("ddlRelation")
            rel = e.Item.FindControl("hdnRelation")

            If Not IsNothing(ddl) Then
                li = ddl.Items.FindByText(rel.Value)
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim hdnAttorneyID As HiddenField
        Dim ddlRelation As DropDownList
        'Dim chkAssociated As CheckBox
        Dim intCompanyID As Integer
        Dim intAttorneyID As Integer
        Dim item As RepeaterItem

        intCompanyID = CType(ddlCompanyMain.SelectedItem.Value, Integer)

        For Each item In rptAttorneys.Items
            hdnAttorneyID = item.FindControl("hdnAttorneyID")
            ddlRelation = item.FindControl("ddlRelation")
            'chkAssociated = item.FindControl("chkAssociated")

            intAttorneyID = CType(hdnAttorneyID.Value, Integer)

            If ddlRelation.SelectedIndex > 0 Then 'If chkAssociated.Checked Then
                objAttorney.AddUpdateAttorneyRelation(intAttorneyID, intCompanyID, ddlRelation.SelectedItem.Text, UserID)
            Else
                objAttorney.RemoveAttorneyRelation(intAttorneyID, intCompanyID) 'if exists
            End If
        Next

        trInfoBox.Visible = True
        lblInfoBox.Text = "Attorneys saved for " & ddlCompanyMain.SelectedItem.Text
    End Sub

    Protected Sub lnkCheckAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCheckAll.Click
        Dim item As RepeaterItem
        Dim check As Boolean
        Dim chkAssociated As CheckBox

        If imgCheckAll.Alt = "Check All" Then
            check = True
            imgCheckAll.Alt = "Uncheck All"
            imgCheckAll.Src = "~/images/11x11_uncheckall.png"
        Else
            imgCheckAll.Alt = "Check All"
            imgCheckAll.Src = "~/images/11x11_checkall.png"
        End If

        For Each item In rptAttorneys.Items
            chkAssociated = item.FindControl("chkAssociated")
            chkAssociated.Checked = check
        Next
    End Sub

    Protected Sub lnkReload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReload.Click
        Dim intCompanyID As Integer = CType(hdnCompanyID.Value, Integer)
        Dim li As ListItem

        txtSearch.Text = ""
        LoadAttorneys(intCompanyID)
        ddlCompanyMain.ClearSelection()
        li = ddlCompanyMain.Items.FindByValue(intCompanyID.ToString)
        If Not li Is Nothing Then
            li.Selected = True
        End If
    End Sub
	Protected Sub lnkCreateSample_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCreateSample.Click

		Dim intCompanyID = CType(ddlCompanyMain.SelectedItem.Value, Integer)


		Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
        Dim args() As String = String.Format("BlankLetter,{0}", intCompanyID).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

        rDoc = rpt.ViewTemplate("BlankLetter", -1, args, False, UserID)
        Dim memStream As New System.IO.MemoryStream()
        Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
        pdf.Export(rDoc, memStream)

		memStream.Seek(0, IO.SeekOrigin.Begin)


		Session("ViewPDF") = memStream.ToArray

		Dim _sb As New System.Text.StringBuilder()
		_sb.Append("window.open('ViewPDF.aspx','',")
		_sb.Append("'toolbar=0,menubar=0,resizable=yes');")
		ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

	End Sub
End Class
