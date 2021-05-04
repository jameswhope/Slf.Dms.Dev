Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Partial Class reports_interface_frame
    Inherits System.Web.UI.Page

#Region "Variables"

    Protected qs As QueryStringCollection

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            If qs("rpt").Length > 0 Then
                Session("report") = qs("rpt")
            Else
                Session("report") = ""
            End If

            If qs("f") = String.Empty Then
                Session("format") = "pdf"
            Else
                Session("format") = qs("f")
            End If

            Session("download") = DataHelper.Nz_bool(qs("d"), False)

        End If

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)
        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""report""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
End Class