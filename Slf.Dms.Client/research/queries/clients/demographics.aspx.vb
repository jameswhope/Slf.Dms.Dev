Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_queries_clients_demographics
    Inherits PermissionPage


#Region "Variables"
    Private Const PageSize As Integer = 20
    Private UserID As Integer
    Private reset As Boolean = False
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        
        LoadLanguages()
        LoadStates()
        LoadClientStatuses()

        If Not Page.IsPostBack Then
            LoadCompanys()
        End If

        If Not String.IsNullOrEmpty(Session(Me.GetType.Name & "_c")) Then
            Dim csid As String = Server.UrlDecode(Session(Me.GetType.Name & "_c"))
            csClientStatusID.SelectedStr = csid
            chkFemale.Checked = True
            chkMale.Checked = True
            Session.Remove(Me.GetType.Name & "_c")
            Save()
            reset = True
        Else
            If Not IsPostBack Then
                LoadValues(GetControls(), Me)
            End If
            Requery(False)
        End If
    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Requery(reset)
    End Sub
    Protected Sub lnkShowFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowFilter.Click

        If lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('tdFilter', 'lnkShowFilter')")

        End If

        Refresh()

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()

        'requery, forcing new lookup
        Requery(True)

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()

        'replace check marks
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkMale.ID, "value", True)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkFemale.ID, "value", True)

        'reset grid list, to force it to requery
        grdResults.Reset(True)

        'reload page
        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optClientStatusChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optClientStatusChoice.ID, "value", _
                optClientStatusChoice.SelectedValue)
        End If
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csClientStatusID.ID, "store", csClientStatusID.SelectedStr)

        If optLanguageChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optLanguageChoice.ID, "value", _
                optLanguageChoice.SelectedValue)
        End If
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csLanguageID.ID, "store", csLanguageID.SelectedStr)

        If optStateChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optStateChoice.ID, "value", _
                optStateChoice.SelectedValue)
        End If
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csStateID.ID, "store", csStateID.SelectedStr)

        If txtHireDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate1.ID, "value", _
                txtHireDate1.Text)
        End If

        If txtHireDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate2.ID, "value", _
                txtHireDate2.Text)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkMale.ID, "value", _
            chkMale.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkFemale.ID, "value", _
            chkFemale.Checked)

    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        End If

    End Sub

#End Region
#Region "Util"
    Private Sub LoadStates()
        csStateID.Items.Clear()
        csStateID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblState"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim StateId As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csStateID.AddItem(New ListItem(Name, StateId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csStateID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csStateID.ID + "'")
        End If
    End Sub
    Private Sub LoadLanguages()
        csLanguageID.Items.Clear()
        csLanguageID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblLanguage"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim LanguageID As Integer = DatabaseHelper.Peel_int(rd, "LanguageID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                        csLanguageID.AddItem(New ListItem(Name, LanguageID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csLanguageID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csLanguageID.ID + "'")
        End If
    End Sub
    Private Sub LoadClientStatuses()
        csClientStatusID.Items.Clear()
        csClientStatusID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblClientStatus"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim ClientStatusID As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                        csClientStatusID.AddItem(New ListItem(Name, ClientStatusID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csClientStatusID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csClientStatusID.ID + "'")
        End If
    End Sub
    Private Sub LoadCompanys()
        ddlCompany.Items.Clear()
        ddlCompany.Items.Add(New ListItem(" -- Select --", "-1"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = String.Format("select c.companyid, c.shortconame from tblcompany c join tblusercompanyaccess a on a.companyid = c.companyid and a.userid = {0} order by c.companyid", UserID)
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        ddlCompany.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "shortconame"), DatabaseHelper.Peel_int(rd, "companyid")))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optLanguageChoice.ID, optLanguageChoice)
        c.Add(optStateChoice.ID, optStateChoice)
        c.Add(txtHireDate1.ID, txtHireDate1)
        c.Add(txtHireDate2.ID, txtHireDate2)
        c.Add(chkMale.ID, chkMale)
        c.Add(chkFemale.ID, chkFemale)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)

        Return c

    End Function
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Queries-Clients-Demographics")
    End Sub
#End Region
#Region "Query"
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        DatabaseHelper.AddParameter(cmd, "where", GetCriteria())
    End Sub
    Private Sub Requery(ByVal Reset As Boolean)
        Dim grd As QueryGrid = grdResults

        'Setup misc settings
        grd.IconSrcURL = "~/images/16x16_person.png"
        grd.PageSize = PageSize
        grd.SortOptions.Allow = True
        grd.SortOptions.DefaultSortField = "tblPerson.LastName"

        'Setup Click settings
        grd.ClickOptions.Clickable = True
        grd.ClickOptions.ClickableURL = "~/clients/client/?id=$x$"
        grd.ClickOptions.KeyField = "ClientID"

        grd.NoWrap = True

        'Setup the DataCommand
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetDemographics")
        AddStdParams(cmd)
        cmd.CommandTimeout = 180
        grd.DataCommand = cmd

        Session("rptcmd_query_clients_agency") = cmd

        'Setup the Fields
        grd.Fields.Clear()

        grd.Fields.Add(New QueryGrid.GridField("Acct No.", QueryGrid.eFieldType.Text, Nothing, "AccountNumber", SqlDbType.VarChar, True, "tblClient.AccountNumber"))
        grd.Fields.Add(New QueryGrid.GridField("First Name", QueryGrid.eFieldType.Text, Nothing, "FirstName", SqlDbType.VarChar, True, "tblPerson.FirstName"))
      grd.Fields.Add(New QueryGrid.GridField("Last Name", QueryGrid.eFieldType.Text, Nothing, "LastName", SqlDbType.VarChar, True, "tblPerson.LastName"))
      grd.Fields.Add(New QueryGrid.GridField("Gender", QueryGrid.eFieldType.Text, Nothing, "Gender", SqlDbType.VarChar, True, "tblPerson.Gender"))
      grd.Fields.Add(New QueryGrid.GridField("Co-Applicant", QueryGrid.eFieldType.Text, Nothing, "CoApp", SqlDbType.VarChar, True, "CoApp"))
        grd.Fields.Add(New QueryGrid.GridField("Street", QueryGrid.eFieldType.Text, Nothing, "Street", SqlDbType.VarChar, True, "tblPerson.Street"))
        grd.Fields.Add(New QueryGrid.GridField("City", QueryGrid.eFieldType.Text, Nothing, "City", SqlDbType.VarChar, True, "tblPerson.City"))
        grd.Fields.Add(New QueryGrid.GridField("State", QueryGrid.eFieldType.Text, Nothing, "State", SqlDbType.VarChar, True, "tblState.Name"))
        grd.Fields.Add(New QueryGrid.GridField("Zip", QueryGrid.eFieldType.Text, "#####-####", "ZipCode", SqlDbType.VarChar, True, "tblPerson.ZipCode"))
        grd.Fields.Add(New QueryGrid.GridField("Language", QueryGrid.eFieldType.Text, Nothing, "Language", SqlDbType.VarChar, True, "tblLanguage.Name"))
        grd.Fields.Add(New QueryGrid.GridField("Created", QueryGrid.eFieldType.DateTime, "MM/dd/yyyy", "Created", SqlDbType.DateTime, True, "tblClient.Created"))
        grd.Fields.Add(New QueryGrid.GridField("Status", QueryGrid.eFieldType.Text, Nothing, "Status", SqlDbType.VarChar, True, "tblClientStatus.Name"))
        grd.Fields.Add(New QueryGrid.GridField("Email", QueryGrid.eFieldType.Text, Nothing, "EmailAddress", SqlDbType.VarChar, True, "tblPerson.EmailAddress"))
        grd.Fields.Add(New QueryGrid.GridField("Company", QueryGrid.eFieldType.Text, Nothing, "Company", SqlDbType.VarChar, True, "Company"))
        grd.Fields.Add(New QueryGrid.GridField("Home Phone", QueryGrid.eFieldType.Text, Nothing, "HomePhone", SqlDbType.VarChar, True, "HomePhone"))
        grd.Fields.Add(New QueryGrid.GridField("Work Phone", QueryGrid.eFieldType.Text, Nothing, "WorkPhone", SqlDbType.VarChar, True, "WorkPhone"))
        grd.Fields.Add(New QueryGrid.GridField("Cell Phone", QueryGrid.eFieldType.Text, Nothing, "CellPhone", SqlDbType.VarChar, True, "CellPhone"))

        If (Reset) Then grd.Reset(True)

        Session("xls_" & Me.GetType.Name) = grd.GetXlsHtml()

    End Sub
    Private Function GetCriteria() As String
        Dim strWhere As String = String.Empty

        If chkMale.Checked And chkFemale.Checked Then
            'return all, even nulls
        ElseIf chkMale.Checked Then
            strWhere = AddCriteria(strWhere, "tblPerson.Gender = 'M'")
        ElseIf chkFemale.Checked Then
            strWhere = AddCriteria(strWhere, "tblPerson.Gender = 'F'")
        End If

        If csClientStatusID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csClientStatusID.GenerateCriteria("tblClient.CurrentClientStatusID"), optClientStatusChoice.SelectedValue = 0)
        End If

        If csLanguageID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csLanguageID.GenerateCriteria("tblLanguage.LanguageID"), optLanguageChoice.SelectedValue = 0)
        End If

        If csStateID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csStateID.GenerateCriteria("tblState.StateId"), optStateChoice.SelectedValue = 0)
        End If

        If Not (txtHireDate1.Text.Length = 0 And txtHireDate2.Text.Length = 0) Then
            strWhere = AddDateCriteria(strWhere, txtHireDate1, txtHireDate2, "tblClient.Created")
        End If

        If ddlCompany.SelectedIndex > 0 Then
            strWhere = AddCriteria(strWhere, String.Format("tblClient.CompanyID={0}", ddlCompany.SelectedItem.Value))
        ElseIf ddlCompany.Items.Count = 2 Then
            strWhere = AddCriteria(strWhere, String.Format("tblClient.CompanyID={0}", ddlCompany.Items(1).Value))
        End If

        If strWhere.Length > 0 Then
            strWhere = " AND " & strWhere
        End If

        Return strWhere

    End Function
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
#End Region


    
End Class