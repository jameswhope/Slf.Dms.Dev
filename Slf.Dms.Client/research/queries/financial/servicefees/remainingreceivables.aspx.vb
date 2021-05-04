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

Partial Class research_queries_financial_servicefees_remainingreceivables
    Inherits PermissionPage

#Region "Variables"

    Private Const PageSize As Integer = 20

    Private CommRecId As Integer
    Private CommRecTypeId As Integer
    Private AllCommScenIds As String

    Private UserID As Integer
    Private qs As QueryStringCollection

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Integer.TryParse(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID), CommRecId)
        Integer.TryParse(DataHelper.FieldLookup("tblCommRec", "CommRecTypeId", "CommRecId=" & CommRecId), CommRecTypeId)
        LoadAgencies()

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            LoadEntryTypes()

            If Not IsPostBack Then

                LoadValues(GetControls, Me)

            End If

            Requery()

        End If

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optFeeTypeChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optFeeTypeChoice.ID, "value", _
                optFeeTypeChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csEntryTypeID.ID, "store", csEntryTypeID.SelectedStr)

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If

        If txtHireDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate1.ID, "value", _
                txtHireDate1.Text)
        End If

        If txtHireDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate2.ID, "value", _
                txtHireDate2.Text)
        End If

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
        grdResults.Reset(True)
        Refresh()
    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()
        grdResults.Reset(True)
        Refresh()

    End Sub
#End Region
#Region "Util"
    Private Sub LoadEntryTypes()
        csEntryTypeID.Items.Clear()
        csEntryTypeID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblEntryType WHERE Fee=1"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csEntryTypeID.AddItem(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csEntryTypeID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csEntryTypeID.ID + "'")
        End If
    End Sub
    Private Sub LoadAgencies()

        Dim lstAllCommScenIds As New List(Of String)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT tblAgency.Name, tblCommScen.CommScenId FROM tblUser INNER JOIN tblCommStruct ON tblCommStruct.CommRecId=tblUser.CommRecId INNER JOIN tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId WHERE tblUser.UserId=@UserId"
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim iCommScenId As Integer = DatabaseHelper.Peel_int(rd, "CommScenId")
                        Dim AgencyName As String = DatabaseHelper.Peel_string(rd, "Name")
                        lstAllCommScenIds.Add(iCommScenId)
                    End While
                End Using
            End Using
        End Using

        AllCommScenIds = String.Join(",", lstAllCommScenIds.ToArray())

        If String.IsNullOrEmpty(AllCommScenIds) Then
            AllCommScenIds = "-1"
        End If

    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optFeeTypeChoice.ID, optFeeTypeChoice)
        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)
        c.Add(txtHireDate1.ID, txtHireDate1)
        c.Add(txtHireDate2.ID, txtHireDate2)
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
        AddControl(pnlBody, c, "Research-Queries-Financial-Service Fees-Remaining Receivables")
    End Sub
#End Region
#Region "Query"
    Private Function GetPeriod() As String
        If txtTransDate1.Text.Length > 0 And txtTransDate2.Text.Length > 0 Then
            Return DateTime.Parse(txtTransDate1.Text).ToString("MMMM dd yyyy") + " thru " + DateTime.Parse(txtTransDate2.Text).ToString("MMMM dd yyyy")
        ElseIf txtTransDate1.Text.Length > 0 Then
            Return "From " & DateTime.Parse(txtTransDate1.Text).ToString("MMMM dd yyyy")
        ElseIf txtTransDate2.Text.Length > 0 Then
            Return "Thru " & DateTime.Parse(txtTransDate2.Text).ToString("MMMM dd yyyy")
        Else
            Return "All Time"
        End If
    End Function
    Private Sub Requery()
        Dim grd As QueryGrid2 = grdResults

        'Setup the DataCommand
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeRemainingReceivables")
        AddStdParams(cmd)
        cmd.CommandTimeout = 180
        grd.DataCommand = cmd

        Session("rptcmd_query_servicefee_remainingreceivables") = cmd

        Session("xls_" & Me.GetType.Name) = grd.GetXlsHtml()
    End Sub
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
        If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))
        DatabaseHelper.AddParameter(cmd, "Period", GetPeriod())
        DatabaseHelper.AddParameter(cmd, "Where", GetCriteria())
        DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
        DatabaseHelper.AddParameter(cmd, "CommScenIds", AllCommScenIds)
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
    Private Function GetCriteria() As String

        Dim Where As String = String.Empty

        If csEntryTypeID.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csEntryTypeID.GenerateCriteria("tblEntryType.EntryTypeID"), optFeeTypeChoice.SelectedValue = 0)
        End If

        If Not String.IsNullOrEmpty(txtHireDate1.Text) Then
            Where = AddCriteria(Where, DataHelper.StripTime("tblhiredate.hiredate") & " >= '" & txtHireDate1.Text & "'")
        End If

        If Not String.IsNullOrEmpty(txtHireDate2.Text) Then
            Where = AddCriteria(Where, DataHelper.StripTime("tblhiredate.hiredate") & " <= '" & txtHireDate2.Text & "'")
        End If

        If Where.Length > 0 Then
            Where = "AND " & Where
        End If

        Return Where

    End Function
#End Region
End Class
