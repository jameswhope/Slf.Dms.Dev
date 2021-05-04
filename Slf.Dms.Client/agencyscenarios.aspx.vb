Imports Lexxiom.BusinessServices
Imports Lexxiom.BusinessData
Imports System.Data
Imports Drg.Util.DataAccess

Partial Class AgencyScenarios
    Inherits System.Web.UI.Page

    Private _agencyId As Integer

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadQueryString()
        If Not Me.IsPostBack Then
            LoadCommDetailInfo()
        End If
    End Sub

    Private Sub LoadCommDetailInfo()
        Dim bsAgency As New Agency(_agencyId)
        Me.lblAgency.Text = "Agency: " & GetAgencyName()
        Dim ds As AgencyCommissionDetail = bsAgency.AgencyCommissionDetail()
        If ds.AgencyCommStruct.Rows.Count = 0 Then
            RenderDefaultScenario()
        Else
            RenderScenarios(bsAgency, ds)
        End If
    End Sub

    Private Sub RenderScenarios(ByVal bsAgency As Agency, ByVal ds As AgencyCommissionDetail)
        'Hide Not Agency's recipients
        Dim dvAgencyCommDetail As DataView = New DataView(ds.AgencyCommStruct)
        Dim agencyCommRecIds As String = _agencyId.ToString & GetParentList(bsAgency.GetParents)
        dvAgencyCommDetail.RowFilter = "RecipientAgencyId in (" & agencyCommRecIds & ")"
        dvAgencyCommDetail.Sort = "CompanyId asc, ScenarioSequence asc, CommRecId asc"
        'Render Scenarios Table
        Dim sb As New StringBuilder
        sb.Append("<table style='width:100%;font-family:tahoma;font-size:11;table-layout:fixed;' cellSpacing=""3"" cellPadding=""3"" border=""0"">")
        Dim companyId As Integer = 0
        Dim scenarioId As Integer = 0
        Dim commStruct As AgencyCommissionDetail.AgencyCommStructRow
        Dim fees As AgencyCommissionDetail.FeesRow
        Dim disabled As String = "" 'Scenario greyed-out
        Dim availableMsg As String = String.Empty  'Message to be displayed in case the scenario is not available for the date
        Dim companyCount As Integer = 0 'Control separation between companies
        For Each drv As DataRowView In dvAgencyCommDetail
            commStruct = CType(drv.Row, AgencyCommissionDetail.AgencyCommStructRow)
            'Display company only once
            If companyId <> commStruct.CompanyId Then
                If companyCount > 0 Then sb.Append("<tr><td class='firstTD' ></td><td style=""background-image:url('" & ResolveUrl("~/images/dot.png") & "');background-repeat:repeat-x;background-position:left center;""><img height=""20"" width=""1"" src='" & ResolveUrl("~/images/spacer.gif") & "'/></td></tr>")
                sb.AppendFormat("<tr><td class='firstTD' >Settlement Attorney:</td><td style='text-decoration: underline;'>{0}</td></tr>", commStruct.CompanyName)
                companyId = commStruct.CompanyId
                companyCount += 1
                'Reset Scenario Id
                scenarioId = 0
            End If
            'Grey-out scenario if not available today
            availableMsg = ""
            disabled = ""
            If DateTime.Compare(DateTime.Parse(commStruct.StartDate), Now) <= 0 Then
                If Not commStruct.IsEndDateNull AndAlso DateTime.Compare(DateTime.Parse(commStruct.EndDate), Now) < 0 Then
                    availableMsg = "(Not available)"
                    disabled = "disabled='true'"
                End If
            Else
                availableMsg = String.Format("(Available on {0})", DateTime.Parse(commStruct.StartDate).ToShortDateString)
                disabled = "disabled='true'"
            End If

            'Display scenario only once
            If scenarioId <> commStruct.CommScenId Then
                sb.AppendFormat("<tr {2}><td class='firstTD'>Scenario:</td><td>{0}&nbsp;&nbsp;&nbsp;&nbsp;{1}</td></tr>", commStruct.ScenarioSequence, availableMsg, disabled)
                scenarioId = commStruct.CommScenId
            End If
            'Display recipient 
            sb.AppendFormat("<tr {1}><td class='firstTD'>Recipient:</td><td>{0}</td></tr>", commStruct.Recipient, disabled)
            'Dispolay Fees
            sb.AppendFormat("<tr {0}><td class='firstTD' style='vertical-align:top;'>Fees:</td><td>", disabled)
            sb.Append("<table cellpadding=""0"" cellspacing=""0"">")
            For Each fee As AgencyCommissionDetail.FeesRow In commStruct.GetChildRows("AgencyCommStruct_Fees")
                sb.AppendFormat("<tr><td style='width: 150px; font-family:tahoma;font-size:11px;' nowrap='true'>{0}</td><td style='font-family:tahoma;font-size:11px;' align='right'>{1}</td></tr>", fee.FeeName, String.Format("{0:P}", fee.Percent))
            Next
            sb.Append("</table>")
            sb.Append("</td></tr>")
        Next
        If companyCount > 1 Then sb.Append("<tr><td class='firstTD' ></td><td style=""background-image:url('" & ResolveUrl("~/images/dot.png") & "');background-repeat:repeat-x;background-position:left center;""><img height=""20"" width=""1"" src='" & ResolveUrl("~/images/spacer.gif") & "'/></td></tr>")
        sb.Append("</table>")
        ltrGrid.Text = sb.ToString
    End Sub

    'Gets a comma-delimited list with parents
    Private Function GetParentList(ByVal Parents As DataTable) As String
        Dim sb As New StringBuilder

        For Each dr As DataRow In Parents.Rows
            sb.AppendFormat(", {0}", dr("AgencyId").ToString)
        Next
        Return sb.ToString
    End Function

    Private Sub LoadQueryString()
        If IsNumeric(Request.QueryString("id")) Then
            _agencyId = DataHelper.Nz_int(Request.QueryString("id"), 0)
        Else
            _agencyId = -1
        End If
    End Sub

    Private Sub RenderDefaultScenario()
        Dim sb As New StringBuilder
        Dim msg As String = "No scenarios have been assigned to this agency. The default scenario will be used instead."
        sb.Append("<table border=""0"" cellpadding=""0"" cellspacing=""0"">")
        sb.Append("<tr><td colspan=""2""><div>")
        sb.Append("<table style=""border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px; border-left: #969696 1px solid; color: black; border-bottom: #969696 1px solid; font-family: Tahoma; "" cellspacing=""15"" cellpadding=""0"" width=""100%"" border=""0"">")
        sb.AppendFormat("<tr><td><td>{0}</td></tr>", msg)
        sb.Append("</table></div></td></tr></table>")
        ltrGrid.Text = sb.ToString
    End Sub

    Private Function GetAgencyName() As String
        Return Drg.Util.DataAccess.DataHelper.FieldLookup("tblAgency", "Name", "AgencyId=" & _agencyId)
    End Function
End Class
