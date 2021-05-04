Imports System.Data
Imports System.ServiceModel
Imports System.IO
Imports jsonHelper
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_checkscan_reports
    Inherits System.Web.UI.Page
    
    <Services.WebMethod()> _
    Public Shared Function getCheck(ByVal checkid As String) As String
        Dim results As String = String.Empty
        Try
            Dim ssql As String = String.Format("select checkfrontpath, checkbackpath from tbliclchecks where check21id = {0}", checkid)
            Using dt As DataTable = SqlHelper.GetDataTable(ssql.ToString, CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    Dim img As New HtmlImage
                    img.Height = 200
                    img.Width = 600
                    img.Src = String.Format("ViewTiffHandler.ashx?f={0}", dr("checkfrontpath").ToString)
                    results += ControlToHTML(img)
                    results += "<br/>"
                    img = New HtmlImage
                    img.Height = 200
                    img.Width = 600
                    img.Src = String.Format("ViewTiffHandler.ashx?f={0}", dr("checkbackpath").ToString)
                    results += ControlToHTML(img)

                Next

            End Using

        Catch ex As Exception
            Return ex.Message.ToString
        End Try

        Return results
    End Function
    <Services.WebMethod()> _
    Public Shared Function getChecks(ByVal fileheaderid As String) As String
        Dim results As String = "load checks"
        Try
            Dim ssql As New StringBuilder
            ssql.AppendLine("select ic.ClientID ,p.FirstName + ' '  + p.LastName[Client], ic.CheckType ,ic.CheckRouting,ic.CheckAccountNum ,ic.CheckAmount ")
            ssql.AppendLine("from [wa].dbo.tblICLACKCashLetterHeader_10 aclh ")
            ssql.AppendLine("left join tblICL_CashLetterHeader clh on aclh.cashletterid = clh.CashLetterId ")
            ssql.AppendLine("left join tblICL_BundleHeader bh ON bh.CashLetterHeaderID = clh.CashLetterHeaderID ")
            ssql.AppendLine("left join tblICL_CheckDetail cd on cd.BundleID = bh.BundleHeaderID ")
            ssql.AppendLine("left join tblICLChecks ic ON ltrim(rtrim(ic.CheckOnUs)) = ltrim(rtrim(cd.OnUs)) AND ic.CheckRouting = isnull(cd.PayorBankRoutingNumber,'') + isnull(cd.PayorBankRoutingNumberCheckDigit,'') ")
            ssql.AppendLine("left JOIN tblClient c ON c.ClientID = ic.ClientID ")
            ssql.AppendLine("INNER JOIN tblPerson p ON p.PersonID = c.PrimaryPersonID ")
            ssql.AppendLine("INNER JOIN tblregister r ON r.registerid = ic.registerid ")
            ssql.AppendLine("where ic.DeleteDate IS NULL ")
            ssql.AppendFormat("and aclh.FileHeaderID={0} ", fileheaderid)
            ssql.AppendLine("and ic.ClientID is not null and r.Void is NULL AND r.Bounce IS null")

            Using dt As DataTable = SqlHelper.GetDataTable(ssql.ToString, CommandType.Text)
                Dim gv As New GridView
                gv.CssClass = "entry"
                gv.AutoGenerateColumns = False
                Dim cols As String() = {"ClientID", "Client", "CheckType", "CheckRouting", "CheckAccountNum", "CheckAmount"}
                For Each col As String In cols
                    Dim bc As New BoundField
                    bc.HeaderStyle.CssClass = "headItem5"
                    bc.ItemStyle.CssClass = "listItem"
                    bc.DataField = col
                    bc.HeaderText = col.Replace("Check", "")
                    Select Case col.ToLower
                        Case "clientid"
                            bc.Visible = False
                        Case "checkamount"
                            bc.DataFormatString = "{0:c2}"
                            bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
                            bc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                    End Select

                    gv.Columns.Add(bc)
                Next

                gv.DataSource = dt
                gv.DataBind()
                results = ControlToHTML(gv)
            End Using


        Catch ex As Exception
            Return ex.Message.ToString
        End Try

        Return results
    End Function

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        BindGrids()
    End Sub
    Private Sub BindGrids()

        dsICL.SelectParameters("start").DefaultValue = String.Format("{0} 12:00 AM", txtFrom.Text)
        dsICL.SelectParameters("end").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text)
        dsICL.DataBind()
        rptICL.DataBind()

        dsSummary.DataBind()
        gvSummary.DataBind()

        dsDetail.DataBind()
        gvDetail.DataBind()

        ComputeTotals()

    End Sub
    Private Sub ComputeTotals()
        Dim wColor As Drawing.Color = System.Drawing.Color.LightGoldenrodYellow
        Dim sColor As Drawing.Color = System.Drawing.Color.LightGreen
        gvSummary.ShowFooter = True
        gvSummary.Columns(0).FooterStyle.HorizontalAlign = HorizontalAlign.Left
        gvSummary.Columns(0).FooterText = "TOTAL"
        gvSummary.Columns(7).ItemStyle.BackColor = wColor
        gvSummary.Columns(8).ItemStyle.BackColor = wColor
        gvSummary.Columns(9).ItemStyle.BackColor = sColor
        gvSummary.Columns(10).ItemStyle.BackColor = sColor
        Using dv As DataView = dsSummary.Select(DataSourceSelectArguments.Empty)
            Using dt As DataTable = dv.ToTable
                If dt.Rows.Count > 0 Then
                    gvSummary.Columns(1).FooterText = dt.Compute("sum([Total Files])", Nothing).ToString
                    gvSummary.Columns(2).FooterText = dt.Compute("sum(TotalRECItems)", Nothing).ToString
                    gvSummary.Columns(3).FooterText = FormatCurrency(dt.Compute("sum(TotalRecAmount)", Nothing).ToString, 2)
                    Dim totAck As Integer = dt.Compute("sum(TotalAckItems)", Nothing).ToString
                    gvSummary.Columns(5).FooterText = totAck
                    gvSummary.Columns(6).FooterText = FormatCurrency(dt.Compute("sum(TotalAckAmount)", Nothing).ToString, 2)
                    gvSummary.Columns(7).FooterText = dt.Compute("sum(TotalAdjusted)", Nothing).ToString
                    gvSummary.Columns(8).FooterText = FormatCurrency(dt.Compute("sum(TotalAdjustedAmount)", Nothing).ToString, 2)
                    Dim totAccp As Integer = dt.Compute("sum(TotalAccepted)", Nothing).ToString
                    gvSummary.Columns(9).FooterText = String.Format("{0}", totAccp)
                    gvSummary.Columns(10).FooterText = FormatCurrency(dt.Compute("sum(TotalAcceptedAmount)", Nothing).ToString, 2)

                    Dim iclAcceptPct As String = FormatPercent(totAccp / totAck)
                    lblAcceptedPct.Text = iclAcceptPct
                End If
            End Using
        End Using


        gvDetail.Columns(0).FooterStyle.HorizontalAlign = HorizontalAlign.Left
        gvDetail.Columns(0).FooterText = "TOTAL"
        gvDetail.Columns(7).ItemStyle.BackColor = wColor
        gvDetail.Columns(8).ItemStyle.BackColor = wColor
        gvDetail.Columns(9).ItemStyle.BackColor = sColor
        gvDetail.Columns(10).ItemStyle.BackColor = sColor
        Using dv As DataView = dsDetail.Select(DataSourceSelectArguments.Empty)
            Using dt As DataTable = dv.ToTable
                If dt.Rows.Count > 0 Then
                    gvDetail.Columns(2).FooterText = dt.Compute("sum(TotalRECItems)", Nothing).ToString
                    gvDetail.Columns(3).FooterText = FormatCurrency(dt.Compute("sum(TotalRECAmount)", Nothing).ToString, 2)
                    gvDetail.Columns(5).FooterText = dt.Compute("sum(TotalAckItems)", Nothing).ToString
                    gvDetail.Columns(6).FooterText = FormatCurrency(dt.Compute("sum(TotalAckAmount)", Nothing).ToString, 2)
                    gvDetail.Columns(7).FooterText = dt.Compute("sum(TotalAdjusted)", Nothing).ToString
                    gvDetail.Columns(8).FooterText = FormatCurrency(dt.Compute("sum(TotalAdjustedAmount)", Nothing).ToString, 2)
                    gvDetail.Columns(9).FooterText = dt.Compute("sum(TotalAccepted)", Nothing).ToString
                    gvDetail.Columns(10).FooterText = FormatCurrency(dt.Compute("sum(TotalAcceptedAmount)", Nothing).ToString, 2)
                End If
            End Using
        End Using



    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            loadDates()
            BindGrids()
        End If

    End Sub

    Protected Sub rptREC_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptICL.ItemDataBound
        Select Case e.Item.ItemType
            Case ListItemType.Item, ListItemType.AlternatingItem
                Dim rowView As DataRowView = CType(e.Item.DataItem, DataRowView)
                Dim lbl As Label = TryCast(e.Item.FindControl("lblStatus"), Label)
                Select Case rowView("FileValidationStatus").ToString.Trim.ToLower
                    Case "FILE REJECTED".ToLower
                        lbl.ForeColor = System.Drawing.Color.Red
                    Case "FILE RECEIVED".ToLower
                        lbl.ForeColor = System.Drawing.Color.Green

                End Select


                Dim ssql As String = "SELECT FileHeaderId, Created, CustomerID, FileName, FileCreationDate, FileCreationTime, ResendIndicator, FileIDModifier, FileValidationStatus FROM WA.dbo.tblICLACKFileHeader_01 "
                ssql += String.Format("WHERE filename = '{0}' ORDER BY Created DESC", rowView("filename").ToString)

                Dim ds As SqlDataSource = e.Item.FindControl("dsAckChild")
                Dim gv As GridView = e.Item.FindControl("gvAckChild")
                ds.SelectParameters("filename").DefaultValue = rowView("filename").ToString
                ds.DataBind()

                gv.DataBind()

                ds = e.Item.FindControl("dsRecDetail")
                gv = e.Item.FindControl("gvRecDetail")
                ds.SelectParameters("FileHeaderId").DefaultValue = rowView("FileHeaderId").ToString
                ds.DataBind()
                gv.DataBind()


        End Select
    End Sub

    Protected Sub dsRec_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsICL.Selected
        If e.AffectedRows = 0 Then
            divNoICL.Style("display") = "block"
            tblICL.Style("display") = "none"

        Else
            tblICL.Style("display") = "block"
            divNoICL.Style("display") = "none"
        End If
    End Sub

    Protected Sub ddlRange_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlRange.SelectedIndexChanged
        setDates()
        BindGrids()
    End Sub
    Private Sub setDates()
        txtFrom.Enabled = False
        txtTo.Enabled = False

        Select Case ddlRange.SelectedItem.Value.ToLower
            Case "today"
                txtFrom.Text = Now.ToShortDateString
                txtTo.Text = Now.ToShortDateString
            Case "yesterday"
                txtFrom.Text = DateAdd("d", -1, Now).ToShortDateString
                txtTo.Text = DateAdd("d", -1, Now).ToShortDateString
            Case "lw"
                txtFrom.Text = DateAdd("d", -7, DateAdd("d", 0 - Now.DayOfWeek, Now)).ToShortDateString
                txtTo.Text = DateAdd("w", -1, DateAdd("d", 0 - Now.DayOfWeek, Now)).ToShortDateString
            Case "wtd"
                txtFrom.Text = DateAdd("d", 0 - Now.DayOfWeek, Now).ToShortDateString
                txtTo.Text = Now.ToShortDateString

            Case "mtd"
                txtFrom.Text = Now.AddDays(-1 * (Now.Day - 1)).ToShortDateString
                txtTo.Text = Now.ToShortDateString
            Case "ytd"
                txtFrom.Text = New DateTime(Now.Year, 1, 1).ToShortDateString()
                txtTo.Text = Now.ToShortDateString

            Case Else
                txtFrom.Text = Now.ToShortDateString
                txtTo.Text = Now.ToShortDateString
                txtFrom.Enabled = True
                txtTo.Enabled = True
        End Select
    End Sub
    Private Sub loadDates()

        ddlRange.Items.Add(New ListItem("Today", "today"))
        ddlRange.Items.Add(New ListItem("This Week", "wtd"))
        ddlRange.Items.Add(New ListItem("This Month", "mtd"))
        ddlRange.Items.Add(New ListItem("This Year", "ytd"))
        ddlRange.Items.Add(New ListItem("Yesterday", "yesterday"))
        ddlRange.Items.Add(New ListItem("Last Week", "lw"))
        ddlRange.Items.Add(New ListItem("Custom", "custom"))

        txtFrom.Text = Now.ToShortDateString
        txtTo.Text = Now.ToShortDateString

        txtFrom.Enabled = False
        txtTo.Enabled = False

    End Sub

    Protected Sub gvSummary_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.styleGridviewRows(e)

        End Select
    End Sub
    Protected Sub gvDetail_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetail.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                GridViewHelper.styleGridviewRows(e)

        End Select
    End Sub

    Protected Sub gvAck_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim ds As SqlDataSource = TryCast(e.Row.NamingContainer.Parent.FindControl("dsAckAdj"), SqlDataSource)
                Dim gv As GridView = TryCast(e.Row.NamingContainer.Parent.FindControl("gvAckAdj"), GridView)
                ds.SelectParameters("fileheaderid").DefaultValue = rowView("FileHeaderId").ToString
                ds.DataBind()
                gv.DataBind()
        End Select
    End Sub

End Class
