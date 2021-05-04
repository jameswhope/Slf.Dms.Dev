Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Partial Class util_pop_findduplicatephone
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)
            Dim AgencyId As Integer = CInt(UserHelper.UserAgency(UserID).Rows(0)("AgencyId").ToString)

            Dim qs As QueryStringCollection = LoadQueryString()

            If Not qs Is Nothing Then
                Dim phoneNumber As String = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("phone")).Trim)).Trim

                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("agencyId", AgencyId))
                params.Add(New SqlParameter("phoneNumber", phoneNumber))

                Try
                    gvDuplicateLeads.DataSource = SqlHelper.GetDataTable("stp_getDuplicateLeads", CommandType.StoredProcedure, params.ToArray)
                    gvDuplicateLeads.DataBind()
                Catch ex As Exception
                    Response.Redirect("error.aspx")
                End Try
            End If
        End If
    End Sub

    Protected Function LoadQueryString() As QueryStringCollection
        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString
    End Function

    Protected Sub gvDuplicateLeads_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rv As DataRowView = CType(e.Row.DataItem, DataRowView)

                e.Row.Style("background-color") = "#FFDB72"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#FFCE49';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#FFDB72';")
                'End If

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onclick", "redirectToLead(" & rv.Row.Item(0).ToString & ");")

        End Select
    End Sub

End Class
