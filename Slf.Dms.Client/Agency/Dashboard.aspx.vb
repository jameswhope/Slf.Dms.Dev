Imports Infragistics.WebUI
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Agency_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.DateRangeBox.Period = "lastsixmonths"
            Me.DateRangeBox.GroupBy = "m"

            RebindDataSource()
        End If
    End Sub

    Private Sub RebindDataSource()

        ds_InitialDrafts.SelectParameters.Item("startdate").DefaultValue = Me.DateRangeBox.From
        ds_InitialDrafts.SelectParameters.Item("enddate").DefaultValue = Me.DateRangeBox.To.AddDays(1)
        ds_InitialDrafts.SelectParameters.Item("dateperiod").DefaultValue = Me.DateRangeBox.GroupBy
        ds_InitialDrafts.SelectParameters("UserID").DefaultValue = DataHelper.Nz_int(Page.User.Identity.Name)
        ds_InitialDrafts.DataBind()
        ucDeposits.Data.DataBind()


        ds_NonInitialDrafts.SelectParameters.Item("startdate").DefaultValue = Me.DateRangeBox.From
        ds_NonInitialDrafts.SelectParameters.Item("enddate").DefaultValue = Me.DateRangeBox.To.AddDays(1)
        ds_NonInitialDrafts.SelectParameters.Item("dateperiod").DefaultValue = Me.DateRangeBox.GroupBy
        ds_NonInitialDrafts.SelectParameters("UserID").DefaultValue = DataHelper.Nz_int(Page.User.Identity.Name)
        ds_NonInitialDrafts.DataBind()

        ds_Intake.SelectParameters.Item("startdate").DefaultValue = Me.DateRangeBox.From
        ds_Intake.SelectParameters.Item("enddate").DefaultValue = Me.DateRangeBox.To.AddDays(1)
        ds_Intake.SelectParameters.Item("dateperiod").DefaultValue = Me.DateRangeBox.GroupBy
        ds_Intake.SelectParameters("UserID").DefaultValue = DataHelper.Nz_int(Page.User.Identity.Name)
        ds_Intake.DataBind()

        Dim dw As DataView = ds_InitialDrafts.Select(DataSourceSelectArguments.Empty)
        Dim link, link2 As HyperLinkField
        Dim field As BoundField

        gvInitialDrafts.Columns.Clear()
        gvNonInitialDrafts.Columns.Clear()

        For Each col As DataColumn In dw.Table.Columns
            Select Case col.ColumnName.ToLower
                Case "label"
                    field = New BoundField
                    field.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                    field.HeaderText = ""
                    field.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                    field.DataField = col.ColumnName
                    gvInitialDrafts.Columns.Add(field)
                    gvNonInitialDrafts.Columns.Add(field)
            
                Case Else
                    link = New HyperLinkField
                    link.HeaderText = col.ColumnName
                    link.DataNavigateUrlFields = New String() {"Label"}
                    link.DataTextField = col.ColumnName
                    link.DataTextFormatString = "{0:c}"
                    link.DataNavigateUrlFormatString = "PaymentDetail.aspx?payment=first&type={0}&startdate=" & Me.DateRangeBox.From & "&enddate=" & Me.DateRangeBox.To.AddDays(1) & "&dateperiod=" & Me.DateRangeBox.GroupBy & "&datepartname=" & col.ColumnName
                    gvInitialDrafts.Columns.Add(link)

                    link2 = New HyperLinkField
                    link2.HeaderText = col.ColumnName
                    link2.DataNavigateUrlFields = New String() {"Label"}
                    link2.DataTextField = col.ColumnName
                    link2.DataTextFormatString = "{0:c}"
                    link2.DataNavigateUrlFormatString = "PaymentDetail.aspx?payment=other&type={0}&startdate=" & Me.DateRangeBox.From & "&enddate=" & Me.DateRangeBox.To.AddDays(1) & "&dateperiod=" & Me.DateRangeBox.GroupBy & "&datepartname=" & col.ColumnName
                    gvNonInitialDrafts.Columns.Add(link2)
            End Select
            
        Next


        'client intake table
        BuildClientIntakeTable()

        gvInitialDrafts.DataBind()
        gvNonInitialDrafts.DataBind()

        If dw.Table.Columns.Count > 9 Then
            divInitialDrafts.Style("height") = "93px"
            divNonInitialDrafts.Style("height") = "93px"
        Else
            divInitialDrafts.Style("height") = "73px"
            divNonInitialDrafts.Style("height") = "73px"
        End If
    End Sub

    Protected Sub btnViewReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnViewReport.Click
        Me.RebindDataSource()
    End Sub

    Protected Sub ucInitialDrafts_InvalidDataReceived(ByVal sender As Object, ByVal e As Infragistics.UltraChart.Shared.Events.ChartDataInvalidEventArgs) Handles ucInitialDrafts.InvalidDataReceived, ucDeposits.InvalidDataReceived
        e.Text = "No data to display."
        e.LabelStyle.Font = New Drawing.Font("tahoma", 11, Drawing.FontStyle.Bold)
        e.LabelStyle.FontSizeBestFit = False
        e.LabelStyle.HorizontalAlign = Drawing.StringAlignment.Center
        e.LabelStyle.VerticalAlign = Drawing.StringAlignment.Center
    End Sub

    Protected Sub ds_InitialDrafts_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles ds_InitialDrafts.Selecting, ds_NonInitialDrafts.Selecting
        e.Command.CommandTimeout = 360
    End Sub

    Private Sub BuildClientIntakeTable()
        Dim dvIntake As DataView = ds_Intake.Select(DataSourceSelectArguments.Empty)
        Dim field As BoundField
        gvIntake.Columns.Clear()
        For Each col As DataColumn In dvIntake.Table.Columns
            field = New BoundField
            field.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
            If col.ColumnName = "Label" Then
                field.HeaderText = ""
                field.ItemStyle.HorizontalAlign = HorizontalAlign.Left
            Else
                field.HeaderText = col.ColumnName
                field.ItemStyle.HorizontalAlign = HorizontalAlign.Right
            End If
            field.DataField = col.ColumnName
            gvIntake.Columns.Add(field)
        Next

        gvIntake.Columns(0).HeaderStyle.Wrap = False
        gvIntake.Columns(0).ItemStyle.Wrap = False

        AddHandler gvInitialDrafts.RowDataBound, AddressOf gvDrafts_RowDataBound
        AddHandler gvNonInitialDrafts.RowDataBound, AddressOf gvDrafts_RowDataBound

    End Sub

    Protected Sub gvDrafts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Dim newText As String = ""
        Select Case e.Row.Cells(0).Text
            Case "Income"
                newText = "Gross Fees Payment"
            Case "Net Income"
                newText = "Net Fees Payment"
            Case Else
                newText = e.Row.Cells(0).Text

        End Select
        e.Row.Cells(0).Text = newText
    End Sub

    Protected Sub gvInitialDrafts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInitialDrafts.RowDataBound

        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'change chargeback link to point to chargebackdetails.aspx
                '12.9.08.ug
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Select Case rowView(0).ToString.ToLower
                    Case "chargeback"
                        For Each dc As Control In e.Row.Controls
                            For Each c As Control In dc.Controls
                                If TypeOf c Is HyperLink Then
                                    Dim hl As HyperLink = TryCast(c, HyperLink)
                                    Dim newLink As String = hl.NavigateUrl
                                    newLink = newLink.Replace("PaymentDetail", "ChargebackDetail")
                                    hl.NavigateUrl = newLink
                                End If
                            Next
                        Next
                End Select
        End Select

    End Sub

    Protected Sub gvNonInitialDrafts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNonInitialDrafts.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'change chargeback link to point to chargebackdetails.aspx
                '12.9.08.ug
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Select Case rowView(0).ToString.ToLower
                    Case "chargeback"
                        For Each dc As Control In e.Row.Controls
                            For Each c As Control In dc.Controls
                                If TypeOf c Is HyperLink Then
                                    Dim hl As HyperLink = TryCast(c, HyperLink)
                                    Dim newLink As String = hl.NavigateUrl
                                    newLink = newLink.Replace("PaymentDetail", "ChargebackDetail")
                                    hl.NavigateUrl = newLink
                                End If
                            Next
                        Next
                End Select
        End Select

    End Sub
End Class
