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

Partial Class research_queries_clients_agency
    Inherits PermissionPage


#Region "Variables"
    Private Const PageSize As Integer = 20
    Private UserID As Integer
    Private qs As QueryStringCollection

    Public agencyId As Integer
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            'load agency stuff
            Dim agencyIdString As String = DataHelper.FieldLookup("tblAgency", "AgencyId", "UserId=" & DataHelper.Nz_int(Page.User.Identity.Name))
            If Not String.IsNullOrEmpty(agencyIdString) Then

                agencyId = Integer.Parse(agencyIdString)

                If Not IsPostBack Then
                    
                    If Not String.IsNullOrEmpty(Session(Me.GetType.Name & "_s")) Then
                        txtSearchClients.Text = Server.UrlDecode(Session(Me.GetType.Name & "_s"))
                        Session.Remove(Me.GetType.Name & "_s")
                        chkRecievedLSANo.Checked = True
                        chkRecievedLSAYes.Checked = True
                        Save()
                        Requery(True)
                    ElseIf Not String.IsNullOrEmpty(Session(Me.GetType.Name & "_c")) Then
                        Dim csid As String = Server.UrlDecode(Session(Me.GetType.Name & "_c"))
                        csClientStatusID.SelectedStr = csid
                        Session.Remove(Me.GetType.Name & "_c")
                        chkRecievedLSANo.Checked = True
                        chkRecievedLSAYes.Checked = True
                        Save()
                        Requery(True)
                    Else
                        LoadValues(GetControls(), Me)
                        Requery(False)
                    End If
                Else
                    Requery(False)
                End If
            End If
        End If
    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadClientsStatuses()
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
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkRecievedLSANo.ID, "value", True)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkRecievedLSAYes.ID, "value", True)

        'reset grid list, to force it to requery
        grdResults.Reset(True)

        'reload page
        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optStatusChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optStatusChoice.ID, "value", _
                optStatusChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csClientStatusID.ID, "store", csClientStatusID.SelectedStr)

        If txtEnrolledDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtEnrolledDate1.ID, "value", _
                txtEnrolledDate1.Text)
        End If

        If txtEnrolledDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtEnrolledDate2.ID, "value", _
                txtEnrolledDate2.Text)
        End If

        If txtSearchClients.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtSearchClients.ID, "value", _
                txtSearchClients.Text)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkRecievedLSANo.ID, "value", _
            chkRecievedLSANo.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkRecievedLSAYes.ID, "value", _
            chkRecievedLSAYes.Checked)

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
    Private Sub LoadClientsStatuses()
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
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)


        c.Add(optStatusChoice.ID, optStatusChoice)
        c.Add(txtEnrolledDate1.ID, txtEnrolledDate1)
        c.Add(txtEnrolledDate2.ID, txtEnrolledDate2)
        c.Add(txtSearchClients.ID, txtSearchClients)
        c.Add(chkRecievedLSAYes.ID, chkRecievedLSAYes)
        c.Add(chkRecievedLSANo.ID, chkRecievedLSANo)
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

        AddControl(pnlBody, c, "Research-Queries-Clients-Agency")

    End Sub
#End Region
#Region "Query"
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        DatabaseHelper.AddParameter(cmd, "agencyId", agencyId)
        DatabaseHelper.AddParameter(cmd, "strWhere", GetCriteria())
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
        grd.ClickOptions.KeyField = "ClientId"
        grd.NoWrap = True

        'Setup the DataCommand
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetClientInfo")
        AddStdParams(cmd)
        cmd.CommandTimeout = 180
        grd.DataCommand = cmd

        Session("rptcmd_query_clients_agency") = cmd

        'Setup the Fields
        grd.Fields.Clear()
        grd.Fields.Add(New QueryGrid.GridField("Account No.", QueryGrid.eFieldType.Text, Nothing, "AccountNumber", SqlDbType.VarChar, True, "tblClient.AccountNumber"))
        grd.Fields.Add(New QueryGrid.GridField("Lead No.", QueryGrid.eFieldType.Text, Nothing, "LeadNumber", SqlDbType.VarChar, True, "tblAgencyExtraFields01.LeadNumber"))
        grd.Fields.Add(New QueryGrid.GridField("LSA", QueryGrid.eFieldType.Boolean, Nothing, "ReceivedLSA", SqlDbType.Bit, True, "tblClient.ReceivedLSA"))
        grd.Fields.Add(New QueryGrid.GridField("Status", QueryGrid.eFieldType.Text, Nothing, "ClientStatusName", SqlDbType.VarChar, True, "tblCurrentStatus.ClientStatusId"))
        grd.Fields.Add(New QueryGrid.GridField("Date Sent", QueryGrid.eFieldType.DateTime, Nothing, "DateSent", SqlDbType.DateTime, True, "tblAgencyExtraFields01.DateSent"))
        grd.Fields.Add(New QueryGrid.GridField("Date Received", QueryGrid.eFieldType.DateTime, Nothing, "DateReceived", SqlDbType.DateTime, True, "tblAgencyExtraFields01.DateReceived"))
        grd.Fields.Add(New QueryGrid.GridField("First Name", QueryGrid.eFieldType.Text, Nothing, "FirstName", SqlDbType.VarChar, True, "tblPerson.FirstName"))
        grd.Fields.Add(New QueryGrid.GridField("Last Name", QueryGrid.eFieldType.Text, Nothing, "LastName", SqlDbType.VarChar, True, "tblPerson.LastName"))
        grd.Fields.Add(New QueryGrid.GridField("SSN", QueryGrid.eFieldType.Text, Nothing, "SSN", SqlDbType.VarChar, True, "tblPerson.SSN"))
        grd.Fields.Add(New QueryGrid.GridField("Payment Type", QueryGrid.eFieldType.Text, Nothing, "DepositMethod", SqlDbType.VarChar, True, "tblClient.DepositMethod"))
        grd.Fields.Add(New QueryGrid.GridField("Payment Amount", QueryGrid.eFieldType.Currency, Nothing, "DepositAmount", SqlDbType.Money, True, "tblClient.DepositAmount"))
        grd.Fields.Add(New QueryGrid.GridField("Debt Total", QueryGrid.eFieldType.Currency, Nothing, "DebtTotal", SqlDbType.Money, True, "tblAgencyExtraFields01.DebtTotal"))
        grd.Fields.Add(New QueryGrid.GridField("Seideman Pull Date", QueryGrid.eFieldType.DateTime, Nothing, "SeidemanPullDate", SqlDbType.DateTime, True, "tblAgencyExtraFields01.SeidemanPullDate"))
        grd.Fields.Add(New QueryGrid.GridField("Missing Info.", QueryGrid.eFieldType.Text, Nothing, "MissingInfo", SqlDbType.VarChar, True, "tblAgencyExtraFields01.MissingInfo"))
        grd.Fields.Add(New QueryGrid.GridField("Comments", QueryGrid.eFieldType.Text, Nothing, "Comments", SqlDbType.VarChar, True, "Comments"))

        If (Reset) Then grd.Reset(True)

        Session("xls_" & Me.GetType.Name) = grd.GetXlsHtml()

    End Sub
    Private Function GetCriteria() As String
        Dim strWhere As String = String.Empty

        If txtSearchClients.Text.Length > 0 Then
            Dim parts() As String = txtSearchClients.Text.Split(" ")
            For Each s As String In parts
                strWhere = AddCriteria(strWhere, "(tblClient.AccountNumber LIKE '%" _
                    & s.Replace("'", "''") & "%' OR tblPerson.LastName LIKE '%" _
                    & s.Replace("'", "''") & "%' OR tblPerson.FirstName LIKE '%" _
                    & s.Replace("'", "''") & "%' OR tblPerson.SSN LIKE '%" _
                    & s.Replace("'", "''") & "%' OR tblAgencyExtraFields01.LeadNumber LIKE '%" _
                    & s.Replace("'", "''") & "%')")
            Next
        End If

        If chkRecievedLSAYes.Checked And Not chkRecievedLSANo.Checked Then
            strWhere = AddCriteria(strWhere, "tblClient.ReceivedLSA = 1")
        ElseIf chkRecievedLSANo.Checked And Not chkRecievedLSAYes.Checked Then
            strWhere = AddCriteria(strWhere, "tblClient.ReceivedLSA = 0 OR tblClient.ReceivedLSA is null")
        End If

        If csClientStatusID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csClientStatusID.GenerateCriteria("tblClient.CurrentClientStatusID"), optStatusChoice.SelectedValue = 0)
        End If

        If Not (txtEnrolledDate1.Text.Length = 0 And txtEnrolledDate2.Text.Length = 0) Then
            strWhere = AddDateCriteria(strWhere, txtEnrolledDate1, txtEnrolledDate2, "tblClient.Created")
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