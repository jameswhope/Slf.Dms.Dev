Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports DataManagerHelper

Partial Class admin_LeadAssignment
    Inherits System.Web.UI.Page

    Protected Sub admin_LeadAssignment_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlOffers.DataSource = LoadOffers()
            ddlOffers.DataBind()
            ddlUsers.DataSource = LoadUsers()
            ddlUsers.DataBind()
        End If
    End Sub

    Protected Function LoadOffers() As DataTable
        Return SqlHelper.GetDataTable("SELECT OfferID, Offer FROM tblOffers WHERE Active = 1 AND CallCenter = 1 ORDER BY Offer", CommandType.Text)
    End Function

    Protected Function LoadBuyers() As DataTable
        Return SqlHelper.GetDataTable("SELECT cast(b.BuyerID as varchar(5)) + '|' + cast(x.CallTransfer as varchar(1)) [BuyerID], b.Buyer FROM tblBuyers b JOIN tblbuyerofferxref x on x.buyerid = b.buyerid and x.callcenter=1 and x.active = 1 WHERE b.Active = 1 AND x.OfferID = " & ddlOffers.SelectedItem.Value & " ORDER BY b.Buyer", CommandType.Text)
    End Function

    Protected Function LoadUsers() As DataTable
        Return SqlHelper.GetDataTable("SELECT UserID, Firstname + ' ' + Lastname [UserName] FROM tblUser WHERE Active = 1 ORDER BY UserName", CommandType.Text)
    End Function

    Protected Function LoadSales(ByVal phoneNumber As String) As DataTable
        Dim strSQL As String
        strSQL = "select s.submittedofferid, l.leadid, l.fullname, l.phone, l.email, buyer, offer, s.submitted, s.pointvalue, s.price, case when u.Firstname is not null then u.Firstname + ' ' + left(u.LastName,1) + '.' else '' end [SubmittedBy], u.UserId "
        strSQL += "from tblsubmittedoffers s "
        strSQL += "join tbloffers o on o.offerid = s.offerid "
        strSQL += "join tblleads l on l.leadid = s.leadid "
        strSQL += "join tblleadstatus ls on ls.leadstatusid = l.leadstatusid "
        strSQL += "join tblbuyers b on b.buyerid = s.buyerid "
        strSQL += "left join tblUser u on u.UserId = s.SubmittedBy "
        strSQL += "where s.valid = 1 "
        strSQL += "and l.phone = '" & phoneNumber & "' "
        strSQL += "order by submitted"

        Return SqlHelper.GetDataTable(strSQL, CommandType.Text)
    End Function

    Protected Sub btnGetInfo_Click() Handles btnGetInfo.Click
        If Me.txtPhoneNumber.Text.Length = 10 Then
            Dim tbl As DataTable = LoadSales(Me.txtPhoneNumber.Text)
            gvSoldTo.DataSource = tbl
            gvSoldTo.DataBind()
            If tbl.Rows.Count = 0 Then
                ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showErrorToast', 'No valid submissions found.');", True)
            End If
        End If
    End Sub

    Protected Sub btnPostAssignment_Click() Handles btnPostAssignment.Click
        Dim value() As String = Split(ddlBuyers.SelectedValue, "|")
        Dim buyerID As Integer = CInt(value(0))
        Dim calltransfer As Boolean = IIf(value(1).Equals("1"), True, False)
        Dim LeadID As Integer = GetLeadID(Me.txtPhoneNumber.Text)
        If LeadID > 0 Then
            Dim id As Integer = LeadHelper.InsertSubmittedOffer(LeadID, CInt(Val(Me.ddlOffers.SelectedValue)), buyerID, "success", "manual pixel fired", "", "true", CInt(Val(Me.ddlUsers.SelectedValue)), calltransfer)
            If id > 0 Then
                ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showSuccessToast', 'Submission added.');", True)
                btnGetInfo_Click()
            End If
        Else
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showErrorToast', 'Lead not found.');", True)
        End If
    End Sub

    Protected Function GetLeadID(ByVal PhoneNumber As String) As Integer
        Dim strSQL As String
        Dim LeadID As Integer

        strSQL = "select top 1 leadid "
        strSQL += "from tblleads "
        strSQL += "where phone = '" & PhoneNumber & "' "
        strSQL += "order by LeadID desc"

        Try
            LeadID = SqlHelper.ExecuteScalar(strSQL, CommandType.Text)
        Catch ex As Exception
            'do nothing
        End Try

        Return LeadID
    End Function

    Protected Sub ddlOffers_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlOffers.SelectedIndexChanged
        ddlBuyers.DataSource = LoadBuyers()
        ddlBuyers.DataBind()
    End Sub

    Protected Sub gvSoldTo_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSoldTo.RowCommand
        Select Case e.CommandName
            Case "remove"
                Dim row As GridViewRow = gvSoldTo.Rows(e.CommandArgument)
                SqlHelper.ExecuteNonQuery("update tblSubmittedOffers set Valid = 0 where submittedofferID = " & gvSoldTo.DataKeys(e.CommandArgument).Item(0).ToString, CommandType.Text)
                If Not CDate(row.Cells(5).Text).Equals(Today) Then
                    SqlHelper.ExecuteNonQuery("update tblSubmittedOffers set Valid = 0 where submittedofferID = " & gvSoldTo.DataKeys(e.CommandArgument).Item(0).ToString, CommandType.Text, , SqlHelper.ConnectionString.IDENTIFYLEWHSE)
                End If
                ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showSuccessToast', 'Submission removed.');", True)
                btnGetInfo_Click()
        End Select
    End Sub

    Protected Sub gvSoldTo_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSoldTo.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btn As LinkButton = e.Row.FindControl("btnRemove")
            If IsDBNull(e.Row.DataItem("UserId")) Then
                btn.Visible = False
            End If
            btn.CommandArgument = e.Row.RowIndex
        End If
    End Sub
End Class
