Imports System.Data
Imports System.Data.SqlClient

Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data.Common

Partial Class public_options
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _AccountID As String
    Private _DataClientID As String
    Private _Information As SettlementMatterHelper.SettlementInformation
    Private _SigningBatchID As String

#End Region 'Fields

#Region "Properties"

    Public Property AccountID() As String
        Get
            Return _AccountID
        End Get
        Set(ByVal value As String)
            _AccountID = value
        End Set
    End Property

    Public Property DataClientID() As String
        Get
            Return _DataClientID
        End Get
        Set(ByVal value As String)
            _DataClientID = value
        End Set
    End Property

    Public Property Information() As SettlementMatterHelper.SettlementInformation
        Get
            Return _Information
        End Get
        Set(ByVal value As SettlementMatterHelper.SettlementInformation)
            _Information = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    ''' <summary>
    ''' Binds the Grid with data of all the open settlements for a particular client
    ''' </summary>
    ''' <param name="sClientID">Integer to uniquely identify a client converted to string</param>
    ''' <remarks></remarks>
    Public Sub BindGrid(ByVal sClientID As Integer, Optional ByVal bOnlyDeposited As Boolean = False)

        'cmd.CommandText = "SELECT * FROM tblAdHocACH WHERE ClientID = @ClientID " & IIf(OnlyNotDeposited = 1, "AND RegisterID is null", "") & " ORDER BY tblAdHocACH.DepositDate Desc, tblAdHocACH.Created Desc"


        dsOptions.SelectParameters("clientid").DefaultValue = sClientID
        dsOptions.DataBind()
        gvOptions.DataBind()

        Using dt As DataTable = TryCast(dsOptions.Select(DataSourceSelectArguments.Empty), DataView).ToTable
            If Not IsNothing(dt) Then
                If dt.Rows.Count > 0 Then
                    lblSDABalance.Text = FormatCurrency(dt.Rows(0)("RegisterBalance").ToString, 2, 0, 0)
                    lblPFOBalance.Text = FormatCurrency(dt.Rows(0)("PFOBalance".ToString), 2, 0, 0)

                    Dim dep As DataSet = ClientHelper2.ExpectedDeposits(sClientID, DateAdd(DateInterval.Day, 90, Now))
                    If dep.Tables(1).Rows.Count > 0 Then
                        lblDeliveryDate.Text = Format(CDate(dep.Tables(1).Rows(0)("depositdate")), "MMM d")
                        lblDeliveryAmount.Text = FormatCurrency(Val(dep.Tables(1).Rows(0)("depositamount")), 2)
                    End If
                End If


                dsACH.SelectParameters("clientid").DefaultValue = sClientID
                dsACH.SelectParameters("onlyDeposited").DefaultValue = bOnlyDeposited
                dsACH.DataBind()
                gvAch.DataBind()


                'Dim ssql As String = "stp_lexxsign_getClientAchInfo"
                'Dim myparams As New List(Of SqlParameter)

                'myparams.Add(New SqlParameter("clientid", sClientID))
                'myparams.Add(New SqlParameter("onlyDeposited", bOnlyDeposited))

                'Using dtAch As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, myparams.ToArray)
                '    gvAch.DataSource = dtAch
                '    gvAch.DataBind()
                'End Using

            End If
        End Using





    End Sub

    Protected Sub gvOptions_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOptions.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                For Each tc As TableCell In e.Row.Cells
                    If tc.HasControls Then
                        If TypeOf tc.Controls(0) Is LinkButton Then
                            Dim lnk As LinkButton = tc.Controls(0)
                            If Not IsNothing(lnk) Then
                                If gvOptions.SortExpression = lnk.CommandArgument Then
                                    tc.Controls.Clear()
                                    Dim tbl As New Table
                                    tbl.CssClass = "entry"
                                    Dim tr As New TableRow
                                    Dim td As New TableCell

                                    td.Controls.Add(lnk)
                                    tr.Cells.Add(td)

                                    td = New TableCell
                                    td.Width = 10
                                    Dim glyph As New Label
                                    glyph.EnableTheming = False
                                    glyph.Font.Name = "webdings"
                                    glyph.Font.Size = FontUnit.Small
                                    glyph.Text = IIf(gvOptions.SortDirection = SortDirection.Ascending, " 5", " 6").ToString
                                    td.Controls.Add(glyph)
                                    tr.Cells.Add(td)

                                    tbl.Rows.Add(tr)
                                    tc.Controls.Add(tbl)
                                End If

                            End If
                        End If

                    End If
                Next
        End Select
    End Sub
    Protected Sub gvOptions_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOptions.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#F0E68C'; ")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#ffffff'; this.style.textDecoration = 'none';")

        End Select
    End Sub
    Private Sub ProcessSelected()
        'store settlement ids
        Dim sbGroup As New List(Of String)

        For index As Integer = 0 To gvOptions.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvOptions.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, delete it...
            If cb.Checked Then
                Dim sid As Integer = gvOptions.DataKeys(index).Item(0).ToString
                sbGroup.Add(sid)
            End If
        Next

        If sbGroup.Count > 0 Then
            divMsg.Style("display") = "block"
            divMsg.Attributes("class") = "info"
            Dim sbID As String = SqlHelper.ExecuteScalar(String.Format("Select signingbatchid from tbllexxsigndocs where relationid = {0}", sbGroup(0).ToString), CommandType.Text)
            Dim sqlList As New List(Of String)
            For Each sb As String In sbGroup
                sqlList.Add(String.Format("update tbllexxsigndocs set signingbatchid = '{0}' where relationid = {1}", sbID, sb))
            Next

            divMsg.InnerHtml = Join(sqlList.ToArray, "<br>")
            SqlHelper.ExecuteNonQuery(Join(sqlList.ToArray, ";"), CommandType.Text)

            Response.Redirect(String.Format("lexxsign.aspx?sbid={0}", sbID))
        Else
            divMsg.Style("display") = "block"
            divMsg.Attributes("class") = "error"
            divMsg.InnerHtml = "Nothing Selected!"

        End If

    End Sub


    Protected Sub public_options_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.QueryString("sbid") Is Nothing Then
            _SigningBatchID = Request.QueryString("sbid")
            DataClientID = SqlHelper.ExecuteScalar(String.Format("select clientid from tbllexxsigndocs where signingbatchid = '{0}'", _SigningBatchID), CommandType.Text)
        End If

        If Not IsPostBack Then
            ViewState("SortDir") = "DESC"
            LoadBanks(ddlBanks)
            BindGrid(DataClientID)
        End If
    End Sub

#End Region 'Methods

    Protected Sub btnProceed_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProceed.Click
        ProcessSelected()
    End Sub


    Protected Sub OnlyNotDeposited_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OnlyNotDeposited.CheckedChanged
        BindGrid(DataClientID, OnlyNotDeposited.Checked)

    End Sub

    Private Sub LoadBanks(ByVal ddl As DropDownList)
        Dim ssql As String = String.Format("select cba.bankaccountid,rn.customername,rn.routingnumber, cba.accountnumber, banktype from tblclientbankaccount cba inner join tblroutingnumber rn on rn.routingnumber = cba.routingnumber where clientid = {0}", DataClientID)
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            ddl.DataSource = dt
            ddl.DataTextField = "Customername"
            ddl.DataValueField = "bankaccountid"
            ddl.DataBind()
            If dt.Rows.Count > 0 Then
                txtBankRouting.Text = dt.Rows(0).Item("routingnumber").ToString
                txtBankAcct.Text = dt.Rows(0).Item("accountnumber").ToString
                lblBankAcctType.Text = dt.Rows(0).Item("banktype").ToString
                txtDepositAmt.Text = "0.00"
                txtDepositDate.Text = FormatDateTime(Now, DateFormat.ShortDate)
            End If
        End Using
    End Sub
    Private Sub LoadBanks(ByVal ddl As DropDownList, ByVal selectedBankName As String)
        Dim ssql As String = String.Format("select cba.bankaccountid,rn.customername,rn.routingnumber, cba.accountnumber, banktype from tblclientbankaccount cba inner join tblroutingnumber rn on rn.routingnumber = cba.routingnumber where clientid = {0}", DataClientID)
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)

            For Each row As DataRow In dt.Rows
                Dim li As New ListItem
                li.Text = String.Format("{0} - {1} - {2}", row("customername"), row("accountnumber"), row("BankType"))
                li.Value = row("bankaccountid").ToString
                If li.Text.ToLower = selectedBankName.ToLower Then
                    li.Selected = True
                End If

                ddl.Items.Add(li)
            Next

        End Using
    End Sub
    Protected Sub ddlBanks_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBanks.SelectedIndexChanged
        'get client banks

        txtBankRouting.Text = ""
        txtBankAcct.Text = ""
        lblBankAcctType.Text = "S"
    End Sub

    Protected Sub lnkSaveACH_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveACH.Click

        Dim myparams As New List(Of SqlParameter)

        myparams.Add(New SqlParameter("clientid", DataClientID))
        myparams.Add(New SqlParameter("DepositDate", txtDepositDate.Text))
        myparams.Add(New SqlParameter("DepositAmount", txtDepositAmt.Text))
        myparams.Add(New SqlParameter("BankName", ddlBanks.SelectedItem.Text))
        myparams.Add(New SqlParameter("BankRoutingNumber", txtBankRouting.Text))
        myparams.Add(New SqlParameter("BankAccountNumber", txtBankAcct.Text))
        myparams.Add(New SqlParameter("BankType", lblBankAcctType.Text))
        myparams.Add(New SqlParameter("BankAccountId", ddlBanks.SelectedValue))
        myparams.Add(New SqlParameter("Userid", 1481))

        SqlHelper.ExecuteNonQuery("stp_lexxsign_insertClientAchInfo", CommandType.StoredProcedure, myparams.ToArray)

        dsACH.DataBind()
        gvAch.DataBind()

    End Sub

    Protected Sub gvAch_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAch.RowCommand
        Select Case e.CommandName.ToLower
            Case "delete".ToLower
                Dim achID As String = e.CommandArgument
                dsACH.DeleteParameters("AdHocAchID").DefaultValue = achID

            Case "update".ToLower
                Dim achID As String = e.CommandArgument
                dsACH.UpdateParameters("AdHocAchID").DefaultValue = achID
                dsACH.UpdateParameters("DepositDate").DefaultValue = txtDepositDate.Text
                dsACH.UpdateParameters("DepositAmount").DefaultValue = txtDepositAmt.Text
                dsACH.UpdateParameters("BankAccountId").DefaultValue = ddlBanks.SelectedValue
        End Select
    End Sub

    Protected Sub gvAch_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAch.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                Dim ddl As DropDownList = TryCast(e.Row.FindControl("ddlBankName"), DropDownList)
                If Not IsNothing(ddl) Then
                    LoadBanks(ddl, rowView("bankname").ToString)
                End If


        End Select
    End Sub
End Class