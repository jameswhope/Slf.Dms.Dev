Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class Clients_Enrollment_credit_request
    Inherits System.Web.UI.Page

    'creates array list of premade choices that can't be changed.
    Enum ReportStatus
        ok = 0
        warning = 1
        [error] = 2
        excluded = 3
        noaction = 4
    End Enum

    Private UserID As Integer
    Private borrowers As Collections.Generic.Dictionary(Of String, Borrower)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'loads in json2 and jquery.modaldialog javascript
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery,
                                                  GlobalFiles.JQuery.UI,
                                                  "~/jquery/json2.js",
                                                  "~/jquery/jquery.modaldialog.js"
                                                  })
        'gets the name of the user and stores it
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        ' if page is being loaded for the first time then load a new enrollment page
        If Not Page.IsPostBack Then
            aBack.HRef = "../newenrollment3.aspx?id=" & Request.QueryString("id")
            grdborrowers.Columns(GetColumnByHeader(grdborrowers, "Result")).Visible = False
            BindBorrowers() 'gets the lead applicants ID and uses it to get the list of borrowers and binds it to a datagridview
        End If
    End Sub

    Private Function GetReuseList() As String()
        Dim l As New List(Of String) 'creates a new list of strings
        For Each row As GridViewRow In grdborrowers.Rows 'For loop
            If row.RowType = DataControlRowType.DataRow Then 'if the rowtype is a datarow then process
                Try 'if reuse checkbox is checked, then add dayakey with no -  
                    If CType(row.Cells(GetColumnByHeader(grdborrowers, "Reuse")).FindControl("chkReuse"), CheckBox).Checked Then
                        l.Add(grdborrowers.DataKeys(row.RowIndex).Value.replace("-", ""))
                    End If
                Catch ex As Exception
                    'Ignore
                End Try
            End If
        Next
        Return l.ToArray 'returns array to function call
    End Function

    Private Function GetExcludeList() As String()
        Dim l As New List(Of String) 'creates array of strings
        For Each row As GridViewRow In grdborrowers.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Try ' if exclude row is checked, then add to datakeys and replace - with ""
                    If CType(row.Cells(GetColumnByHeader(grdborrowers, "Exclude")).FindControl("chkExclude"), CheckBox).Checked Then
                        l.Add(grdborrowers.DataKeys(row.RowIndex).Value.replace("-", ""))
                    End If
                Catch ex As Exception
                    'Ignore
                End Try
            End If
        Next
        Return l.ToArray
    End Function

    'takes in strings and formats it
    Private Function GetHtmlMessage(ByVal msg As String, ByVal cssclass As String) As String
        Return String.Format("<p class='{0}'>{1}</p>", cssclass, HttpUtility.HtmlEncode(msg))
    End Function

    Private Sub SendCreditReportRequest()
        Dim reportid As Integer = -1
        Dim leadapplicantid As Integer = Request.QueryString("id") 'gets ID by query of HTTP string
        Dim creditreportid As String = String.Format("{0:yyyyMMddHHmmss}L{1}", Now, leadapplicantid) 'created creditreport ID by string format
        Dim errormsg As String = ""
        lblCreditReportId.Text = creditreportid 'fills label with credit report ID

        Try
            borrowers = CredStarHelper2.GetBorrowerCollection(leadapplicantid)
            Dim excludeList As String() = GetExcludeList()

            If borrowers.Count = excludeList.Length Then Throw New Exception("All leads have been excluded. The request has been aborted")

            CredStarHelper2.RequestCreditReport(reportid, leadapplicantid, creditreportid, UserID, borrowers, GetReuseList, excludeList)

            If reportid > 0 Then hdnReportID.Value = reportid

        Catch ex As Exception
            errormsg = ex.Message
            lblErrorMsg.Text = lblErrorMsg.Text & GetHtmlMessage(ex.Message, "errorMsg")
            If reportid > 0 Then CredStarHelper2.UpdateReportErrorMessage(reportid, errormsg)
        End Try

        'Load Re lblErrorMsg.Text =sults
        btnSendRequest.Enabled = False
        grdborrowers.Columns(GetColumnByHeader(grdborrowers, "Result")).Visible = True
        BindBorrowers()

        'Get status counters
        Dim statusCounter As Integer() = New Integer() {0, 0, 0, 0, 0} 'OK, warning, error, excluded, noaction


        For Each lead As Borrower In borrowers.Values
            Select Case lead.ReportStatus.ToLower
                Case "ok"
                    statusCounter(ReportStatus.ok) += 1
                Case "warning"
                    statusCounter(ReportStatus.warning) += 1
                    lblErrorMsg.Text = lblErrorMsg.Text & GetHtmlMessage(lead.StatusMessage, "warningMsg")
                Case "error"
                    statusCounter(ReportStatus.error) += 1
                Case "excluded"
                    statusCounter(ReportStatus.excluded) += 1
                Case Else
                    statusCounter(ReportStatus.noaction) += 1
            End Select
        Next

        'Determine possible actions: Resend, AutoSave, Save 
        If errormsg.Length > 0 Then
            tblLiabilities.Visible = False
            btnRequestAgain.Visible = True
            btnSave.Visible = False
        ElseIf statusCounter(ReportStatus.ok) = borrowers.Count Then
            'AutoSave
            SaveReport(leadapplicantid)
        ElseIf statusCounter(ReportStatus.ok) + statusCounter(ReportStatus.warning) + statusCounter(ReportStatus.excluded) = borrowers.Count Then
            'Save or Resend
            tblLiabilities.Visible = False
            btnRequestAgain.Visible = True
            btnSave.Visible = True
        Else
            'Resend Only
            tblLiabilities.Visible = False
            btnRequestAgain.Visible = True
            btnSave.Visible = False
        End If

    End Sub

    Private Sub SaveReport(ByVal LeadApplicantId As Integer)
        If Val(hdnReportID.Value) > 0 Then

            CredStarHelper2.UpdateLeadLastCreditReport(LeadApplicantId, hdnReportID.Value)

            tblLiabilities.Visible = True
            btnSendRequest.Visible = False
            btnRequestAgain.Visible = False
            btnSave.Visible = False

            'There is no need to show these columns after locking the report send buttons
            grdborrowers.Columns(GetColumnByHeader(grdborrowers, "Reuse")).Visible = False
            grdborrowers.Columns(GetColumnByHeader(grdborrowers, "Exclude")).Visible = False

            BindGrid()

            'Create pdfs for completed users
            CredStarHelper2.SaveDocuments(hdnReportID.Value, LeadApplicantId, UserID)

            ShowReport()
        End If
    End Sub

    Private Sub ShowReport()
        Dim html As String = CredStarHelper2.ShowCreditReport(hdnReportID.Value)

        If html.Trim.Length > 0 Then
            aViewReport.Text = html
        Else
            aViewReport.Visible = False
        End If
    End Sub

    Protected Sub btnSendRequest_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendRequest.Click
        SendCreditReportRequest()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        SaveReport(Request.QueryString("id"))
    End Sub

    'Binds the creditor information to the request2.aspx webpage grid
    Private Sub BindGrid()
        Dim tblCreditors As Data.DataTable = CredStarHelper.GetFilteredCreditLiabilities(CInt(hdnReportID.Value))
        Dim dv As DataView = New DataView()
        dv = tblCreditors.DefaultView
        dv.Sort = "UnpaidBalance" + " Desc" 'sorts the results by balance column before binding
        GridView1.DataSource = dv
        GridView1.DataBind()
        btnImport.Visible = (tblCreditors.Rows.Count > 0)
    End Sub

    Protected Sub btnImport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnImport.Click
        Dim CreditLiabilityID As Integer
        Dim chkSelect As CheckBox
        Dim count As Integer
        Dim dk As DataKey
        Dim leadApplicantID As String = CInt(Request.QueryString("id")) 'calls the current applicant's ID
        Dim creditorlist As List(Of Creditor) = CredStarHelper2.creditorList 'creates and gets the global creditorlist object
        Dim existsLiability As Object 'creates and object to test the existance of a liability
        'Dim dt As DataTable = New DataTable()
        'Dim queryString1 As String = "Select * From tblLeadCreditorInstance Where leadApplicantID = @leadapplicantID"
        Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString 'cholt 9/8/2020 changed to hidden string value
        'Dim leadCreditorName As String
        'Dim leadCreditorAccountNumber As String
        'Dim leadCreditorLeadApplicantID As String

        'Using connection As SqlConnection = New SqlConnection(connectionString)
        '    Using command As SqlCommand = New SqlCommand(queryString1, connection)
        '        Using sda As SqlDataAdapter = New SqlDataAdapter(command)
        '            command.Parameters.AddWithValue("@LeadApplicantID", leadApplicantID)
        '            connection.Open()
        '            sda.Fill(dt)
        '            connection.Close()
        '        End Using
        '    End Using
        'End Using

        'This function imports the creditorlist created from the xmlreader on CredStarHelper2
        'It loops all checked items and finds the same match in the creditorlist to apply information to the tblcreditor import
        For Each row As GridViewRow In GridView1.Rows
            If row.RowType = DataControlRowType.DataRow Then
                dk = GridView1.DataKeys(row.RowIndex)
                CreditLiabilityID = CInt(dk(0)) 'gets the current creditliability ID
                chkSelect = CType(row.Cells(0).FindControl("chkSelect"), CheckBox) 'gets the check control status
                Dim represented As Boolean = False 'defaults represented to 0 until checked by user

                If chkSelect.Checked Then 'checks for user checkmark then sets represented to 1
                    represented = True
                    count += 1
                End If

                Dim AccountNumber As String = row.Cells(3).Text
                Dim CreditorNameGrid As String = row.Cells(2).Text
                Dim minPmt As String = row.Cells(12).Text
                Dim IntRate As String = "15.5"

                'query string to check if a liability exists
                Dim existsString = "SELECT * FROM tblLeadCreditorInstance WHERE AccountNumber = @AccountNumber AND LeadApplicantID = @LeadApplicantID ORDER BY Created Desc"
                Using connection As SqlConnection = New SqlConnection(connectionString)
                    Using command As SqlCommand = New SqlCommand(existsString, connection)

                        command.Parameters.AddWithValue("@AccountNumber", AccountNumber)
                        command.Parameters.AddWithValue("@LeadApplicantID", CInt(leadApplicantID))


                        connection.Open()
                        existsLiability = command.ExecuteScalar()
                        connection.Close()
                    End Using
                End Using

                If existsLiability = Nothing Then 'if liability does not exist, then create it
                    CredStarHelper.ImportCreditLiability(CreditLiabilityID, CInt(Request.QueryString("id")), UserID, represented, AccountNumber, IntRate, minPmt)

                ElseIf chkSelect.Checked Then 'if liability exists and user has checked it, update with represented
                    Dim updateString = "UPDATE tblLeadCreditorInstance SET Represented = @Represented WHERE AccountNumber = @AccountNumber AND LeadApplicantID = @LeadApplicantID"
                    Using connection As SqlConnection = New SqlConnection(connectionString)
                        Using command As SqlCommand = New SqlCommand(updateString, connection)

                            command.Parameters.AddWithValue("@AccountNumber", AccountNumber)
                            command.Parameters.AddWithValue("@LeadApplicantID", CInt(leadApplicantID))
                            command.Parameters.AddWithValue("@Represented", CInt(represented))

                            connection.Open()
                            existsLiability = command.ExecuteNonQuery()
                            connection.Close()
                        End Using
                    End Using
                Else 'if liability exists and user has not checked it, do nothing.
                    'do nothing
                End If

                'Replaced with original creditor compare cholt 9/11/2020
                ''Loops the creditorlist object to import each creditor information
                'For i As Integer = 0 To creditorlist.Count - 1
                '    For j As Integer = 0 To creditorlist(i).CreditorAccount.Count - 1
                '        If AccountNumber = creditorlist(i).CreditorAccount(j).AccountNumber.ToString AndAlso CreditorNameGrid = creditorlist(i).CreditorName.ToString Then
                '            Dim CreditorName As String = creditorlist(i).CreditorName
                '            Dim Street As String = creditorlist(i).Address
                '            Street = Street.ToString.Replace("PO BOX", "P.O. Box").Replace("POB", "P.O. Box")
                '            Dim Street2 As String = creditorlist(i).Address2
                '            Dim City As String = creditorlist(i).City
                '            Dim StateCode As String = creditorlist(i).State
                '            Dim PostalCode As String = creditorlist(i).ZipCode
                '            'Dim exists As String = creditorlist(i).Exists

                '            'If String.Equals(exists, "False") Then 'if exists is false then add to tblcreditors
                '            If Not XMLReaderCreditorList.CompareCreditor(CreditorName, City, Street, Street2, StateCode, PostalCode) Then 'if not true then add to tblcreditors
                '                Dim queryString As String = "Insert into tblCreditor (name, street, street2, city, StateID, ZipCode, Created, CreatedBy, LastModified, LastModifiedBy, Validated, CreditorGroupID, CreditorAddressTypeID) values (@name, @street, @street2, @city, (Select stateid from tblstate where Abbreviation = @StateID), @ZipCode, GetDate(), '24', GetDate(), '24', '0', (select top 1 creditorgroupid from tblcreditorgroup where name = @name), '102')"

                '                Using connection As SqlConnection = New SqlConnection(connectionString)
                '                    Using command As SqlCommand = New SqlCommand(queryString, connection)

                '                        command.Parameters.AddWithValue("@name", CreditorName)
                '                        command.Parameters.AddWithValue("@street", Street)
                '                        command.Parameters.AddWithValue("@street2", Street2)
                '                        command.Parameters.AddWithValue("@city", City)
                '                        command.Parameters.AddWithValue("@StateID", StateCode)
                '                        command.Parameters.AddWithValue("@ZipCode", PostalCode)
                '                        connection.Open()
                '                        command.ExecuteNonQuery()
                '                        connection.Close()
                '                    End Using
                '                End Using
                '            End If
                '        End If


                '    Next
                'Next
            End If
        Next

        'For Each row As DataRow In dt.Rows
        '    leadCreditorAccountNumber = row("AccountNumber")
        '    leadCreditorName = row("Name")
        '    leadCreditorLeadApplicantID = row("LeadApplicantID")
        '    For i As Integer = 0 To creditorlist.Count - 1
        '        For j As Integer = 0 To creditorlist(i).CreditorAccount.Count - 1
        '            If leadCreditorLeadApplicantID = leadApplicantID AndAlso leadCreditorName = creditorlist(i).CreditorName AndAlso leadCreditorAccountNumber = creditorlist(i).CreditorAccount(j).AccountNumber Then
        '                'do nothing
        '            Else
        '                Dim queryString As String = "Insert into tblLeadCreditorInstance (LeadApplicantID, CreditorGroupID, CreditorID, AccountNumber, Balance, Name, Street, Street2, City, StateID, ZipCode, Phone, Ext, Created, CreatedBy, Modified, ModifiedBy, IntRate, MinPayment, CreditLiabilityID) values (@LeadApplicantID, (select top 1 creditorgroupid from tblcreditorgroup where name = @Name), (Select top 1 CreditorID from tblCreditor where name = @Name AND street = @street AND street2 = @street2), @AccountNumber, @Balance, @Name, @Street, @Street2, @City, (Select top 1 stateid from tblstate where Abbreviation = @StateID), @ZipCode, @Phone, @Ext, GetDate(), '24', GetDate(), '24', '15.50', @MinPayment, (Select top 1 CreditLiabilityID from tblCreditLiability where AccountNumber = @AccountNumber and ReportID = @ReportID))"

        '                Using connection As SqlConnection = New SqlConnection(connectionString)
        '                    Using command As SqlCommand = New SqlCommand(queryString, connection)
        '                        Dim nameParam As SqlParameter = command.Parameters.AddWithValue("@Name", creditorlist(i).CreditorName)
        '                        If creditorlist(i).CreditorName Is Nothing Then
        '                            nameParam.Value = DBNull.Value
        '                        End If

        '                        Dim reportParam As SqlParameter = command.Parameters.AddWithValue("@ReportID", hdnReportID.Value)
        '                        If creditorlist(i).CreditorName Is Nothing Then
        '                            reportParam.Value = DBNull.Value
        '                        End If

        '                        Dim accountNumberParam As SqlParameter = command.Parameters.AddWithValue("@AccountNumber", creditorlist(i).CreditorAccount(j).AccountNumber)
        '                        If creditorlist(i).CreditorAccount(j).AccountNumber Is Nothing Then
        '                            accountNumberParam.Value = DBNull.Value
        '                        End If

        '                        Dim balanceParam As SqlParameter = command.Parameters.AddWithValue("@Balance", creditorlist(i).CreditorAccount(j).TradeBalance)
        '                        If creditorlist(i).CreditorAccount(j).TradeBalance Is Nothing Then
        '                            balanceParam.Value = DBNull.Value
        '                        End If

        '                        Dim phone As String = creditorlist(i).AreaCode + creditorlist(i).PhoneNumber

        '                        Dim phoneParam As SqlParameter = command.Parameters.AddWithValue("@Phone", phone)
        '                        If phone Is Nothing Then
        '                            phoneParam.Value = DBNull.Value
        '                        End If

        '                        Dim extParam As SqlParameter = command.Parameters.AddWithValue("@Ext", creditorlist(i).ExtensionNumber)
        '                        If creditorlist(i).ExtensionNumber Is Nothing Then
        '                            extParam.Value = DBNull.Value
        '                        End If

        '                        Dim pmtParam As SqlParameter = command.Parameters.AddWithValue("@MinPayment", creditorlist(i).CreditorAccount(j).AmountOfPayment)
        '                        If creditorlist(i).CreditorAccount(j).AmountOfPayment Is Nothing Then
        '                            pmtParam.Value = DBNull.Value
        '                        End If

        '                        'command.Parameters.AddWithValue("@IntRate", creditorlist(i).CreditorAccount(j).)

        '                        Dim leadAppIDParam As SqlParameter = command.Parameters.AddWithValue("@LeadApplicantID", leadApplicantID)
        '                        If leadApplicantID Is Nothing Then
        '                            leadAppIDParam.Value = DBNull.Value
        '                        End If

        '                        Dim streetConvert As String = creditorlist(i).Address.ToString.Replace("PO BOX", "P.O. Box").Replace("POB", "P.O. Box")
        '                        Dim streetParam As SqlParameter = command.Parameters.AddWithValue("@street", streetConvert)
        '                        If creditorlist(i).Address Is Nothing Then
        '                            streetParam.Value = DBNull.Value
        '                        End If

        '                        Dim street2Param As SqlParameter = command.Parameters.AddWithValue("@street2", creditorlist(i).Address2)
        '                        If creditorlist(i).Address2 Is Nothing Then
        '                            street2Param.Value = DBNull.Value
        '                        End If

        '                        Dim cityParam As SqlParameter = command.Parameters.AddWithValue("@city", creditorlist(i).City)
        '                        If creditorlist(i).City Is Nothing Then
        '                            cityParam.Value = DBNull.Value
        '                        End If

        '                        Dim stateParam As SqlParameter = command.Parameters.AddWithValue("@StateID", creditorlist(i).State)
        '                        If creditorlist(i).State Is Nothing Then
        '                            stateParam.Value = DBNull.Value
        '                        End If

        '                        Dim zipParam As SqlParameter = command.Parameters.AddWithValue("@ZipCode", creditorlist(i).ZipCode)
        '                        If creditorlist(i).State Is Nothing Then
        '                            zipParam.Value = DBNull.Value
        '                        End If


        '                        connection.Open()
        '                        command.ExecuteNonQuery()
        '                        connection.Close()
        '                    End Using
        '                End Using
        '            End If
        '        Next
        '    Next
        'Next row



        If count > 0 Then 'if items are checked, reload the page after executing
            Response.Redirect("../newenrollment3.aspx?id=" & Request.QueryString("id"))
        Else 'if nothing was checked and import clicked
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "NothingToImport", "alert('No creditors have been selected to import.');", True)
        End If
    End Sub

    Protected Sub btnRequestAgain_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRequestAgain.Click
        lblErrorMsg.Text = ""
        tblLiabilities.Visible = False
        SendCreditReportRequest()
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

                If CType(e.Row.DataItem, System.Data.DataRowView)("unpaidbalance") <= 0 Then
                    e.Row.Cells(11).Style("color") = "#FF0000"
                Else
                    e.Row.Cells(11).Style("color") = "#000000"
                End If
        End Select
    End Sub

    Protected Sub btnCreditorRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreditorRefresh.Click
        Dim CreditorInfo() As String = hdnCreditorInfo.Value.Split("|")
        Dim CreditorID As Integer = CInt(CreditorInfo(0))
        Dim CreditorGroupID As Integer = CInt(CreditorInfo(7))
        Dim CreditLiabilityLookupID As Integer = CInt(hdnCreditLiabilityLookupID.Value)

        If CreditorID = -1 Then
            If CreditorGroupID = -1 Then
                CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(CreditorInfo(1), UserID)
            End If
            CreditorID = Drg.Util.DataHelpers.CreditorHelper.InsertCreditor(CreditorInfo(1), CreditorInfo(2), CreditorInfo(3), CreditorInfo(4), Integer.Parse(CreditorInfo(5)), CreditorInfo(6), UserID, CreditorGroupID)
        End If

        CredStarHelper.UpdateCreditLiabilityLookup(CreditLiabilityLookupID, CreditorID)
        BindGrid()
    End Sub

    'gets the lead applicants ID and uses it to get the list of borrowers and binds it to a datagridview
    Private Sub BindBorrowers()
        Dim LeadApplicantId As Integer = CInt(Request.QueryString("id"))
        grdborrowers.DataSource = CredStarHelper2.GetBorrowers(LeadApplicantId)
        grdborrowers.DataBind()
    End Sub

    Private Function CanReuseRecentFile(ByVal rowView As DataRowView) As Boolean
        'Allow to reuse xml file if file exists, is not too old, has a good hit indicator and does not contain flags
        Return (Not rowView("filehitindicator") Is DBNull.Value AndAlso CredStarHelper2.IsValidFileHit(rowView("filehitindicator"))) AndAlso
                (rowView("flags") Is DBNull.Value OrElse rowView("flags") = 0) AndAlso
                (Not rowView("LastOKDate") Is DBNull.Value AndAlso CDate(rowView("LastOKDate")).CompareTo(Now.AddDays(-30)) >= 0) AndAlso
                (Not rowView("xmlfile") Is DBNull.Value AndAlso Not rowView("xmlfile").ToString.Trim.Length = 0 AndAlso System.IO.File.Exists(rowView("xmlfile")))
    End Function

    Private Function CanExcludeBorrower(ByVal rowView As DataRowView) As Boolean
        'Allow to exclude a borrower if recent file was an invalid hit or file has flags
        Return (Not rowView("filehitindicator") Is DBNull.Value AndAlso Not CredStarHelper2.IsValidFileHit(rowView("filehitindicator"))) OrElse
                (Not rowView("flags") Is DBNull.Value AndAlso rowView("flags") > 0)
    End Function

    Protected Sub grdborrowers_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdborrowers.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            If rowView("dob") Is DBNull.Value OrElse CDate(rowView("dob")) = New Date(1900, 1, 1) Then
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Date of Birth")).Text = ""
            Else
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Date of Birth")).Text = CDate(rowView("dob")).ToShortDateString
            End If

            If CanReuseRecentFile(rowView) Then
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Reuse")).FindControl("chkReuse").Visible = True
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Reuse")).FindControl("chkReuse"), CheckBox).Checked = True
            Else
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Reuse")).FindControl("chkReuse").Visible = False
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Reuse")).FindControl("chkReuse"), CheckBox).Checked = False
            End If

            If CanExcludeBorrower(rowView) Then
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Exclude")).FindControl("chkExclude").Visible = True
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Exclude")).FindControl("chkExclude"), CheckBox).Checked = False
            Else
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Exclude")).FindControl("chkExclude").Visible = False
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Exclude")).FindControl("chkExclude"), CheckBox).Checked = False
            End If

            If Not rowView("Flags") Is DBNull.Value Then
                e.Row.Cells(GetColumnByHeader(grdborrowers, "Flags")).Text = CredStarHelper2.GetFlagsDescription(rowView("Flags")).Replace(",", ",<br />")
            End If

            'Validate borrower
            Try
                CredStarHelper2.ValidateBorrower(New Borrower With {
                .FirstName = rowView("FirstName"),
                .LastName = rowView("LastName"),
                .SSN = rowView("SSN"),
                .Street = rowView("Address"),
                .City = rowView("City"),
                .State = rowView("State"),
                .PostalCode = rowView("ZipCode"),
                .CoApp = (rowView("seq") <> 1)})
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Is Valid?")).FindControl("imgValid"), System.Web.UI.WebControls.Image).ImageUrl = "~/images/16x16_check.png"
            Catch ex As Exception
                lblErrorMsg.Text = lblErrorMsg.Text & GetHtmlMessage(ex.Message, "errorMsg")
                CType(e.Row.Cells(GetColumnByHeader(grdborrowers, "Is Valid?")).FindControl("imgValid"), System.Web.UI.WebControls.Image).ImageUrl = "~/images/16x16_exclamationpoint.png"
            End Try

            SetRowStatus(e.Row.Cells, rowView("SSN").ToString.Replace("-", ""))

        End If
    End Sub

    Private Function GetBorrower(ByVal ssn As String) As Borrower
        If Not borrowers Is Nothing AndAlso borrowers.ContainsKey(ssn) Then
            Return borrowers(ssn)
        Else
            Return Nothing
        End If
    End Function

    Private Sub SetRowStatus(ByVal cells As TableCellCollection, ByVal ssn As String)
        Dim status As String = ""
        Dim statusmessage As String = ""
        Dim lead As Borrower = GetBorrower(ssn)
        If Not lead Is Nothing Then
            status = lead.ReportStatus
            statusmessage = lead.StatusMessage
        End If
        SetRowStatus(cells, status, statusmessage)
    End Sub

    Private Sub SetRowStatus(ByVal cells As TableCellCollection, ByVal result As String, ByVal message As String)
        Dim colIndex As Integer = GetColumnByHeader(grdborrowers, "Result")

        If colIndex <> -1 Then
            cells(colIndex).Style.Add("cursor", "hand")
            cells(colIndex).ToolTip = message
            Select Case result.Trim.ToLower
                Case "ok"
                    CType(cells(colIndex).FindControl("imgResult"), System.Web.UI.WebControls.Image).ImageUrl = "~/images/valid.png"
                    CType(cells(colIndex).FindControl("lblResult"), System.Web.UI.WebControls.Label).Text = "Success"
                    SetRowBackColor(cells, System.Drawing.Color.LightGreen)
                Case "warning"
                    CType(cells(colIndex).FindControl("imgResult"), System.Web.UI.WebControls.Image).ImageUrl = "~/images/warning.png"
                    CType(cells(colIndex).FindControl("lblResult"), System.Web.UI.WebControls.Label).Text = "Warning"
                    SetRowBackColor(cells, System.Drawing.Color.LightYellow)
                Case "error"
                    CType(cells(colIndex).FindControl("imgResult"), System.Web.UI.WebControls.Image).ImageUrl = "~/images/error.png"
                    CType(cells(colIndex).FindControl("lblResult"), System.Web.UI.WebControls.Label).Text = "Error"
                    SetRowBackColor(cells, System.Drawing.Color.LightPink)
                Case Else

                    CType(cells(colIndex).FindControl("lblResult"), System.Web.UI.WebControls.Label).Text = ""
                    SetRowBackColor(cells, System.Drawing.Color.White)
            End Select

            CType(cells(colIndex).FindControl("imgResult"), System.Web.UI.WebControls.Image).Visible = result.Trim.ToLower.Length > 0
        End If


    End Sub

    Private Sub SetRowBackColor(ByVal cells As TableCellCollection, ByVal color As System.Drawing.Color)
        For Each cell As TableCell In cells
            cell.BackColor = color
        Next
    End Sub

    Private Function GetColumnByHeader(ByVal grid As System.Web.UI.WebControls.GridView, ByVal HeaderText As String) As Integer
        For Each column As DataControlField In grid.Columns
            If column.HeaderText = HeaderText Then
                Return grid.Columns.IndexOf(column)
            End If
        Next
        Return -1
    End Function

    Protected Sub Clients_Enrollment_credit_request_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        lblErrorMsg.Visible = (lblErrorMsg.Text.Trim.Length > 0)
    End Sub

    'Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
    '    Dim dtrslt As DataTable = CType(ViewState("dirState"), DataTable)

    '    If dtrslt.Rows.Count > 0 Then

    '        If Convert.ToString(ViewState("sortdr")) = "Desc" Then
    '            dtrslt.DefaultView.Sort = e.SortExpression & " Asc"
    '            ViewState("sortdr") = "Asc"
    '        Else
    '            dtrslt.DefaultView.Sort = e.SortExpression & " Desc"
    '            ViewState("sortdr") = "Desc"
    '        End If

    '        GridView1.DataSource = dtrslt
    '        GridView1.DataBind()
    '    End If
    'End Sub
End Class
