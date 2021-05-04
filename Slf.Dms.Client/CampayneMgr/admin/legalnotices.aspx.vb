
Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_legalnotices
    Inherits System.Web.UI.Page



    Protected Sub admin_legalnotices_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLegalNotices", Data.CommandType.StoredProcedure)
        grdLegalNotices.DataSource = dt
        grdLegalNotices.DataBind()

    End Sub

    Protected Sub grdLegalNotices_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdLegalNotices.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim dr As DataRowView = CType(e.Row.DataItem, DataRowView)

                Dim view As LinkButton = e.Row.FindControl("lnkViewNotice")
                view.OnClientClick = String.Format("return ViewNotice('{0}','{1}','{2}','{3}');", _
                                                  dr("LegalNoticeId").ToString, _
                                                  dr("TypeOfNotice").ToString, _
                                                  dr("Name").ToString, _
                                                  dr("HtmlText").ToString)

                Dim edit As LinkButton = e.Row.FindControl("lnkEditNotice")
                edit.OnClientClick = String.Format("return EditNotice('{0}','{1}','{2}','{3}');", _
                                                  dr("LegalNoticeId").ToString, _
                                                  dr("TypeOfNotice").ToString, _
                                                  dr("Name").ToString, _
                                                  dr("HtmlText").ToString)

        End Select
    End Sub

    Protected Sub lnkSaveEdit_Click(sender As Object, e As System.EventArgs) Handles lnkSaveEdit.Click

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LegalNoticeId", hdnLegalNoticeId.Value))
        params.Add(New SqlParameter("TypeOfNotice", tbEditTypeofNotice.Text))
        params.Add(New SqlParameter("Name", tbEditNameOfNotice.Text))
        params.Add(New SqlParameter("HtmlText", taEditHtml.InnerText))
        params.Add(New SqlParameter("ModifiedBy", Userid))

        Try
            SqlHelper.ExecuteNonQuery("stp_InsertLegalNotification", CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            LeadHelper.LogError("", ex.Message, ex.StackTrace, Userid)
        End Try

    End Sub

    Public Property Userid() As Integer
        Get
            Return ViewState("_userid")
        End Get
        Set(ByVal value As Integer)
            ViewState("_userid") = value
        End Set
    End Property
End Class
