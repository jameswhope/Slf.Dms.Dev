Imports System.Data
Imports Drg.Util.DataAccess

Partial Class Clients_Enrollment_PhoneList
    Inherits System.Web.UI.Page

    Private _lastMarket As String
    Private _totalBudget As Decimal
    Private _totalActual As Decimal
    Private _totalDiff As Decimal

    Private UserID As Integer

    Public ReadOnly Property TotalBudget() As Decimal
        Get
            Return _totalBudget
        End Get
    End Property

    Public ReadOnly Property TotalActual() As Decimal
        Get
            Return _totalActual
        End Get
    End Property

    Public ReadOnly Property TotalDiff() As Decimal
        Get
            Return _totalDiff
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            LoadMarkets()
            LoadPhoneListDates()
            LoadPhoneList()
        End If
    End Sub

    Private Sub LoadMarkets()
        Dim tbl As DataTable = SmartDebtorHelper.GetMarkets
        Dim row As DataRow

        row = tbl.NewRow
        row(0) = -1
        row(1) = "Select Market"
        tbl.Rows.InsertAt(row, 0)

        For Each row In tbl.Rows
            If Len(CStr(row("Market"))) > 30 Then
                row("Market") = Left(CStr(row("Market")), 30) & ".."
            End If
        Next

        With ddlMarket
            .DataSource = tbl
            .DataTextField = "Market"
            .DataValueField = "LeadMarketID"
            .DataBind()
        End With
    End Sub

    Private Sub LoadPhoneListDates()
        ddlPhoneList.DataSource = SmartDebtorHelper.GetPhoneListDates
        ddlPhoneList.DataTextFormatString = "{0:d}"
        ddlPhoneList.DataTextField = "ForDate"
        ddlPhoneList.DataValueField = "ForDate"
        ddlPhoneList.DataBind()
    End Sub

    Private Sub LoadPhoneList()
        If ddlPhoneList.Items.Count > 0 Then
            gvList.DataSource = SmartDebtorHelper.GetPhoneList(ddlPhoneList.SelectedItem.Text)
            gvList.DataBind()
            hPhoneList.InnerHtml = "Phone List for " & Format(CDate(ddlPhoneList.SelectedItem.Text), "M/d/yyyy")
        Else
            gvList.DataSource = SmartDebtorHelper.GetPhoneList("1/1/1900")
            gvList.DataBind()
            hPhoneList.InnerHtml = "Phone List"
        End If
    End Sub

    Private Sub SavePhoneList()
        Dim intLeadPhoneListID As Integer
        Dim txtPhone As TextBox
        Dim txtBudget As TextBox
        Dim txtActual As TextBox

        For Each row As GridViewRow In gvList.Rows
            If row.RowType = DataControlRowType.DataRow Then
                intLeadPhoneListID = CInt(gvList.DataKeys(row.RowIndex).Value)
                txtPhone = CType(row.FindControl("txtPhone"), TextBox)
                txtBudget = CType(row.FindControl("txtBudget"), TextBox)
                txtActual = CType(row.FindControl("txtActual"), TextBox)
                SmartDebtorHelper.UpdatePhoneList(intLeadPhoneListID, txtPhone.Text, Val(txtBudget.Text), Val(txtActual.Text), UserID)
            End If
        Next
    End Sub

    Protected Sub btnAddMarket_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddMarket.Click
        If Len(txtMarket.Text.Trim) > 0 Then
            SmartDebtorHelper.AddMarket(txtMarket.Text, UserID)
            LoadMarkets()
            txtMarket.Text = ""
        End If
    End Sub

    Protected Sub btnAddSource_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSource.Click
        If ddlMarket.SelectedIndex > 0 AndAlso Len(txtSource.Text.Trim) > 0 Then
            Dim intLeadSourceID As Integer = SmartDebtorHelper.AddSource(CInt(ddlMarket.SelectedItem.Value), txtSource.Text, DataHelper.Nz_int(Page.User.Identity.Name))

            'Current pending changes (if any)
            SavePhoneList()
            'Add new row
            SmartDebtorHelper.AddPhoneList(ddlPhoneList.SelectedItem.Text, intLeadSourceID, "", 0, 0, UserID)
            'Reload display
            LoadPhoneList()

            txtSource.Text = ""
            txtSource.Focus()
        End If
    End Sub

    Protected Sub gvList_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvList.DataBound
        Dim dt As DataTable = CType(gvList.DataSource, DataTable)
        If dt.Rows.Count > 0 Then
            lblLastMod.Text = "Last modified " & dt.Rows(dt.Rows.Count - 1)("LastModified") & " by " & dt.Rows(dt.Rows.Count - 1)("LastModifiedBy")
        End If
    End Sub

    Protected Sub gvList_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvList.RowCommand
        Dim intLeadPhoneListID As Integer

        Select Case e.CommandName.ToLower
            Case "remove"
                Dim key As DataKey = gvList.DataKeys(e.CommandArgument)
                intLeadPhoneListID = CInt(key(0))
                SavePhoneList()
                SmartDebtorHelper.RemovePhoneList(intLeadPhoneListID)
                LoadPhoneList()
        End Select
    End Sub

    Protected Sub gvList_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvList.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If _lastMarket = e.Row.Cells(0).Text Then
                e.Row.Cells(0).Text = ""
            Else
                _lastMarket = e.Row.Cells(0).Text
            End If

            Dim txtBudget As TextBox = e.Row.Cells(3).FindControl("txtBudget")
            Dim txtActual As TextBox = e.Row.Cells(4).FindControl("txtActual")

            _totalBudget += Val(txtBudget.Text)
            _totalActual += Val(txtActual.Text)
            _totalDiff += (Val(txtBudget.Text) - Val(txtActual.Text))

            Dim btn As ImageButton = e.Row.Cells(6).Controls(0)
            btn.OnClientClick = "if (!confirm('Are you sure you want to remove this source?')) return false;"

            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub

    Protected Sub ddlPhoneList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPhoneList.SelectedIndexChanged
        LoadPhoneList()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        SavePhoneList()
        LoadPhoneList()
    End Sub

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        If IsDate(txtForDate.Text) Then
            If chkCopy.Checked Then
                SmartDebtorHelper.CopyPhoneList(ddlPhoneList.SelectedItem.Text, txtForDate.Text, UserID)
                LoadPhoneListDates()
                Dim li As ListItem = ddlPhoneList.Items.FindByText(txtForDate.Text)
                If Not IsNothing(li) Then
                    li.Selected = True
                    LoadPhoneList()
                End If
            Else
                ddlPhoneList.Items.Add(New ListItem(txtForDate.Text, txtForDate.Text))
                ddlPhoneList.SelectedIndex = (ddlPhoneList.Items.Count - 1)
                LoadPhoneList()
            End If
            txtForDate.Text = ""
        End If
    End Sub

    Protected Sub btnDeletePhoneList_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnDeletePhoneList.Click
        SmartDebtorHelper.DeletePhoneList(ddlPhoneList.SelectedItem.Text, UserID)
        LoadPhoneListDates()
        LoadPhoneList()
    End Sub
End Class


'<script language="javascript" type="text/javascript">
'        var i = 0;
'        var oInterval = null;

'        function RunCounter() {
'            if (i++ < 100)
'                document.getElementById('<%=Label1.ClientID %>').innerHTML = i;
'            else {
'                clearInterval(oInterval);
'                oInterval = null;
'            }
'        }

'        function txtActual_OnChange(txt) {
'            /*document.getElementById('<%=Label1.ClientID %>').innerHTML = '';
'            i = 0;
'            oInterval = setInterval(RunCounter, 15);*/
'        }
'    </script>