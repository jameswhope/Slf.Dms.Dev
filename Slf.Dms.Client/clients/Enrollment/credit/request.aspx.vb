
Partial Class Clients_Enrollment_credit_request
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            aBack.HRef = "../newenrollment2.aspx?id=" & Request.QueryString("id")
            RequestQuestions()
        End If
    End Sub

    Private Sub RequestQuestions()
        Dim questions As Collections.Generic.Dictionary(Of String, CredStarHelper.Question)
        Dim CreditReportId As String = ""
        Dim i As Integer = 1

        questions = CredStarHelper.CreditRequest(CInt(Request.QueryString("id")), CreditReportId)
        lblCreditReportId.Text = CreditReportId
        tblAuthQs.Visible = (questions.Count > 0)

        For Each question In questions
            Dim lbl As Label = CType(tblQuestions.FindControl("lblQuestion" & i), Label)
            Dim ddl As DropDownList = CType(tblQuestions.FindControl("ddlChoices" & i), DropDownList)

            lbl.Text = question.Value.Line
            ddl.Items.Clear()
            ddl.Items.Add(New ListItem("", "-1"))
            For Each choice In question.Value.Choices
                ddl.Items.Add(New ListItem(choice.Value, choice.Key))
            Next
            i += 1
        Next
    End Sub

    Protected Sub btnSendAnswers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendAnswers.Click
        Dim answers As New Collections.Generic.Dictionary(Of String, String)

        For i As Integer = 1 To 4
            Dim ddl As DropDownList = CType(tblQuestions.FindControl("ddlChoices" & i), DropDownList)
            answers.Add("Question " & i, ddl.SelectedItem.Value)
        Next

        hdnReportID.Value = CredStarHelper.AuthenticationAnswers(CInt(Request.QueryString("id")), answers, lblCreditReportId.Text, lblErrorMsg.Text, UserID)
        BindGrid()

        tblLiabilities.Visible = (lblErrorMsg.Text.Length = 0)
        btnSendAnswers.Enabled = False 'can only submit answers 1-time per CreditReportId
        btnRequestAgain.Visible = (lblErrorMsg.Text.Length > 0)

        Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("{0}.pdf", lblCreditReportId.Text)
        Dim fi As New IO.FileInfo(path)

        If fi.Exists Then
            aViewReport.HRef = path
        Else
            aViewReport.Visible = False
        End If
    End Sub

    Private Sub BindGrid()
        Dim tblCreditors As Data.DataTable = CredStarHelper.GetFilteredCreditLiabilities(CInt(hdnReportID.Value))
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

    Protected Sub btnRequestAgain_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRequestAgain.Click
        RequestQuestions()
        btnRequestAgain.Visible = False
        btnSendAnswers.Enabled = True
        lblErrorMsg.Text = ""
        tblLiabilities.Visible = False
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

                'Has lookup?
                If IsNumeric(hdn.Value) Then
                    lnk.Visible = False
                Else
                    chk.Visible = False
                    lnk.NavigateUrl = "javascript:FindCreditor(" & dk("CreditLiabilityLookupID") & ",""" & e.Row.Cells(2).Text.Replace("'", "") & """,""" & e.Row.Cells(4).Text.Replace("""", "'") & ""","""",""" & e.Row.Cells(5).Text.Replace("""", "'") & """," & dk("StateID") & ",""" & e.Row.Cells(7).Text.Replace("""", "'") & """);"
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
