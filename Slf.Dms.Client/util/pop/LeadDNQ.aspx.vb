Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class util_pop_LeadDNQ
    Inherits System.Web.UI.Page

   Public Reason As String
   Public ApplicantID As Integer
   Public StatusID As Integer
   Public UserID As Integer
   Public Saved As Boolean

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      If Not IsPostBack Then
            Me.lblMessage.Text = "This applicant Does Not Qualify. Please selet a reason why this applicant does not qualify for the Client Intake Department program."
         If Not Request.QueryString("a") Is Nothing Then ApplicantID = CInt(Val(Request.QueryString("a").ToString))
         If Not Request.QueryString("s") Is Nothing Then StatusID = CInt(Val(Request.QueryString("s").ToString))
         UserID = DataHelper.Nz_int(Page.User.Identity.Name)
         LoadAllReasons()
         ddlReason.Attributes.Add("onChange", "GetReasonValue();")
      End If

   End Sub

   Public Sub ddlIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlReason.SelectedIndexChanged
      Reason = Me.ddlReason.SelectedValue
      If Reason = "Other" Then
         Me.txtOther.Style.Item("display") = "block"
      End If
   End Sub

   Public Sub btnSave_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
      If Not Saved Then
         If Reason <> "" Then
            If Reason = "Other" Then
               If txtOther.Text <> "" Then
                  Reason = "Other: " & txtOther.Text.ToString
               Else
                  Alert.Show("Please enter a reason why this applicant does not qualify.")
                  Exit Sub
               End If
            End If
            SaveReason(CInt(Val(Request.QueryString("a"))), CInt(Val(Request.QueryString("s"))), Reason, DataHelper.Nz_int(Page.User.Identity.Name))
            Saved = True
         Else
            Alert.Show("Please enter a reason why this applicant does not qualify.")
         End If
      End If

   End Sub

   Private Sub LoadAllReasons()
      Dim dr As SqlDataReader

      dr = SDReasonHelper.LoadReasons()
      ddlReason.Items.Clear()
      ddlReason.Items.Add("")

      If dr.HasRows Then
         Do While dr.Read
            ddlReason.Items.Add(dr.Item("Description").ToString)
         Loop
      End If
      ddlReason.SelectedIndex = 0

   End Sub

   Private Sub SaveReason(ByVal ApplicantID As Integer, ByVal StatusID As Integer, ByVal Reason As String, ByVal UserID As Integer)
      If SDReasonHelper.SaveReason(ApplicantID, StatusID, Reason, UserID) Then
         Me.hdnReason.Value = Me.ddlReason.SelectedValue
         Saved = True
         Response.Write("<script>window.close();</script>")
      Else
         Response.Write("<script>window.close();</script>")
      End If
   End Sub
End Class
