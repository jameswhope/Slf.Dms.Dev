
Partial Class Clients_Enrollment_credit_import
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            aBack.HRef = "../newenrollment2.aspx?id=" & Request.QueryString("id")
            BindGrid()
            Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("{0}.pdf", Request.QueryString("creditReportId"))
            Dim fi As New IO.FileInfo(path)
            If fi.Exists Then
                aViewReport.HRef = path
            Else
                aViewReport.Visible = False
            End If
        End If
    End Sub

    Private Sub BindGrid()
        Dim tblCreditors As Data.DataTable = CredStarHelper.GetFilteredCreditLiabilities(CInt(Request.QueryString("reportId")))
        GridView1.DataSource = tblCreditors
        GridView1.DataBind()
        btnImport.Visible = (tblCreditors.Rows.Count > 0)
    End Sub

    Protected Sub btnImport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnImport.Click
        Dim CreditLiabilityID As Integer
        Dim chkSelect As CheckBox
        Dim count As Integer
        Dim dk As DataKey

        For Each row As GridViewRow In GridView1.Rows
            If row.RowType = DataControlRowType.DataRow Then
                dk = GridView1.DataKeys(row.RowIndex)
                CreditLiabilityID = CInt(dk(0))
                chkSelect = CType(row.Cells(0).FindControl("chkSelect"), CheckBox)
                If chkSelect.Checked Then
                    CredStarHelper.ImportCreditLiability(CreditLiabilityID, CInt(Request.QueryString("id")), UserID)
                    count += 1
                End If
            End If
        Next

        If count > 0 Then
            Response.Redirect("../newenrollment2.aspx?id=" & Request.QueryString("id"))
        Else
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "NothingToImport", "alert('No creditors have been selected to import.');", True)
        End If
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim chk As CheckBox = e.Row.Cells(0).FindControl("chkSelect")
                Dim lnk As HyperLink = e.Row.Cells(0).FindControl("lnkFindCreditor")
                Dim hdn As HiddenField = e.Row.Cells(0).FindControl("hdnCreditorID")
                Dim dk As DataKey = GridView1.DataKeys(e.Row.RowIndex)

                'e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#b9b9b9';")
                'e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                'Imported?
                If IsDate(e.Row.Cells(12).Text) Then
                    chk.Visible = False
                    lnk.Visible = False
                    e.Row.Style("color") = "#b9b9b9"
                Else
                    'Has lookup?
                    If IsNumeric(hdn.Value) Then
                        lnk.Visible = False
                    Else
                        chk.Visible = False
                        lnk.NavigateUrl = "javascript:FindCreditor(" & dk("CreditLiabilityLookupID") & ",""" & e.Row.Cells(2).Text.Replace("'", "") & """,""" & e.Row.Cells(4).Text.Replace("""", "'") & ""","""",""" & e.Row.Cells(5).Text.Replace("""", "'") & """," & dk("StateID") & ",""" & e.Row.Cells(7).Text.Replace("""", "'") & """);"
                    End If
                End If
        End Select
    End Sub

    Protected Sub btnCreditorRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreditorRefresh.Click
        Dim CreditorInfo() As String = hdnCreditorInfo.Value.Split("|")
        Dim CreditorID As Integer = CInt(creditorInfo(0))
        Dim CreditorGroupID As Integer = CInt(creditorInfo(7))
        Dim CreditLiabilityLookupID As Integer = CInt(hdnCreditLiabilityLookupID.Value)

        If CreditorID = -1 Then
            If CreditorGroupID = -1 Then
                CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(creditorInfo(1), UserID)
            End If
            CreditorID = Drg.Util.DataHelpers.CreditorHelper.InsertCreditor(creditorInfo(1), creditorInfo(2), creditorInfo(3), creditorInfo(4), Integer.Parse(creditorInfo(5)), creditorInfo(6), UserID, CreditorGroupID)
        End If

        CredStarHelper.UpdateCreditLiabilityLookup(CreditLiabilityLookupID, CreditorID)
        BindGrid()
    End Sub
End Class
