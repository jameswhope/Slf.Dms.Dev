Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Linq
Imports System.Net
Imports System.Security.Cryptography
Imports System.Security.Cryptography.X509Certificates

Imports AssistedSolutions.WebControls.CityStateFinder

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports Infragistics.WebUI.UltraWebGrid

Imports LeadRoadmapHelper
Imports Lexxiom.ImportClients
Imports LexxiomLetterTemplates
Imports SmartDebtorHelper

Imports Microsoft.Azure
Imports Microsoft.WindowsAzure
Imports System.Net.Mail
Imports Newtonsoft.Json.Linq

Partial Class Clients_Enrollment_NewEnrollment2
    Inherits System.Web.UI.Page

#Region "Fields"

    Public CurrentStatus As Integer = -1
    Public EndPageRedirect As Boolean = True
    Public ExportDtl As Int16 = 0
    Public FromWhere As String = String.Empty
    Public Loading As Boolean
    Public UserGroupID As Integer
    Public UserID As Integer
    Public UserTypeID As Integer
    Public a As Boolean = True
    Public aID As Integer = 0
    Public AgencyID As Integer

    Private Const maxMonths As Integer = 400

    Private IsManager As Boolean

#End Region 'Fields

#Region "Enumerations"

    Private Enum ModelType
        Variable
        OnePayment
    End Enum

#End Region 'Enumerations

#Region "Methods"

    Public Sub AddSigningChoices()
        Dim ssql As String = String.Format("select top 1 currentstatus from tblleaddocuments where leadapplicantid = {0} and documenttypeid not in (9,9072,9073)  order by submitted desc", aID)
        Dim cstatus As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        If cstatus = "Waiting on signatures" Then
            Dim l As ListItem = rblSignChoice.Items.FindByValue("echo")
            l.Enabled = True
            l.Selected = True
        End If
    End Sub

    Public Function GetLeadId() As Integer
        Return aID
    End Function

    Public Function GetUserId() As Integer
        Return DataHelper.Nz_int(Page.User.Identity.Name)
    End Function

    Public Sub SaveAndNoEndPage()
        Loading = False
        EndPageRedirect = False
        Save(a, aID)
        Loading = False
    End Sub

    Public Function SetCurrentStatus(ByVal docId As String, ByVal status As String) As String
        If status.ToLower = "document signed" Or status.Equals("Uploaded") Then

            Dim sid As String = DataHelper.FieldLookup("tblLeadDocuments", "SigningBatchID", String.Format("documentid='{0}'", docId))
            If sid <> "" Then

                Dim dIds As New List(Of String)
                Dim dt As DataTable = Nothing
                dt = SqlHelper.GetDataTable(String.Format("select documentid from tblleaddocuments where SigningBatchID= '{0}'", sid))

                'Dim listofDocuments As New List(Of String)
                'listofDocuments = AzureStorageHelper.GetLeadDocuments(d("documentid").toString())

                'for Each f As String In listofDocuments
                dIds.Add(String.Format("window.open('https://lexxwarestore1.blob.core.windows.net/leaddocuments/{0}.pdf');", docId))
                'Next

                Return String.Format("<a href=""#"" onclick=""{0}"">{1}</a>", Join(dIds.ToArray, ""), status)
            Else
                If status.Equals("Uploaded") Then
                    Return String.Format("<a href='https://lexxwarestore1.blob.core.windows.net/leaddocuments/{0}.pdf' target='_blank' title='Click to view'>{1}</a>", docId, status)
                Else
                    Return String.Format("<a href='{0}{1}.pdf' target='_blank' title='Click to view'>{2}</a>", "path", docId, status)
                End If
            End If
        Else
            Return status
        End If
    End Function

    Public Function ViewDocument(ByVal docId As String) As String
        Dim path As String = "https://lexxwarestore1.blob.core.windows.net/leaddocuments/"
        Dim ssql As String = String.Format("select SigningBatchId, DocumentTypeId from tblLeadDocuments where documentid='{0}'", docId)
        Dim dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)

        Dim plt As String() = docId.Split(".")

        If dt.Rows(0)("DocumentTypeId").ToString = "2103" Then
            Return String.Format("<a href='https://lexxwarestore1.blob.core.windows.net/leaddocuments/audio/{0}.wav' target='_blank' title='Click to hear'>{1}</a>", plt(0).ToString, "Hear")
        ElseIf dt.Rows(0)("DocumentTypeId").ToString = "345" Then
            Return String.Format("<a href='https://lexxwarestore1.blob.core.windows.net/leaddocuments/audio/{0}.mp3' target='_blank' title='Click to hear'>{1}</a>", plt(0).ToString, "Hear")
        Else
            Return String.Format("<a href='https://lexxwarestore1.blob.core.windows.net/leaddocuments/audio/{0}.pdf' target='_blank' title='Click to view'>{1}</a>", plt(0).ToString, "View")
        End If

    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery,
                                                  GlobalFiles.JQuery.UI,
                                                  "~/jquery/json2.js",
                                                  "~/jquery/jquery.modaldialog.js"
                                                  })

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserId=" & UserID))
        AgencyID = Integer.Parse(DataHelper.FieldLookup("tblUser", "AgencyID", "UserId=" & UserID))
        IsManager = Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID)

        aID = Request.QueryString("id")
        FromWhere = Request.QueryString("pg")
        ExportDtl = Request.QueryString("fxid")
        Me.hdnCIDDialerCallMadeId.Value = Request.QueryString("cmid")
        Me.hdnCallAppointmentId.Value = Request.QueryString("atid")

        CalculatorModelControl1.ApplicantID = aID
        CalculatorModelControl1.UseLeadData = True

        If aID > 0 Then 'This is an update or this is an insert if there is no Applicant ID jhope 04/19
            a = False
        Else
            a = True
        End If

        If Not IsPostBack Then
            tabAttachFile.Visible = True
            'If AgencyID > 0 AndAlso aID > 0 Then
            If aID > 0 Then
                gvVerification.Visible = True
                If IsManager OrElse PermissionHelperLite.HasPermission(UserID, "Client Intake-Verification Call") Then
                    tab3PV.Visible = True
                End If
            End If

            SetProperties()
            LoadCallVars()

            If Me.hdnCallAppointmentId.Value.Trim.Length > 0 AndAlso CInt(Me.hdnCallAppointmentId.Value) > 0 Then
                LoadAppointmentCall()
                Me.AppointmentCallPopup.Show()
            End If

            If Me.hdnCIDDialerCallMadeId.Value.Trim.Length > 0 Then
                tdDialerResults.Visible = True
                BuildCIDDialerOutButtons()
            End If

            'Insert call info if present
            Me.InsertCallInfo(aID)

            Loading = True
            LoadData()
            assignTXT(UserID, aID)

            If a = "true" AndAlso hdnCallId.Value.Trim.Length > 0 AndAlso hdnProductId.Value.Trim.Length > 0 Then
                AutoInsertLead()
            End If

            'only user group managers can add a new applicant manually
            'If Not IsManager Then
            '    Dim tbButton As Infragistics.WebUI.UltraWebToolbar.TBarButton = DirectCast(uwToolBar.Items(2), Infragistics.WebUI.UltraWebToolbar.TBarButton)
            '    Dim tbSep As Infragistics.WebUI.UltraWebToolbar.TBSeparator = DirectCast(uwToolBar.Items(3), Infragistics.WebUI.UltraWebToolbar.TBSeparator)
            '    tbButton.Visible = False
            '    uwToolBar.Items.Remove(tbSep)
            'End If

            bShowGridLinks(aID)

            divMsg.Style("display") = "none"
            divMsg.InnerText = ""

            If Request.QueryString("a") = "saved" Then
                lblLastSave.Text = "Applicant saved " & Now.ToString
            End If

            CanCalculate()
        Else
            Loading = False

            If ddlLeadSource.SelectedItem.Text = "Paper Lead" Or Me.ddlLeadSource.SelectedItem.Text = "Radio" Or Me.ddlLeadSource.SelectedItem.Text = "TV" Then
                trPaperLeadCode.Style("display") = ""
            End If

            If ddlHardship.SelectedItem.Text = "Other" Then
                trHardshipOther.Style("display") = ""
            End If
        End If

        BindGrids()
        AddSigningChoices()

        If LeadHelper.VerificationComplete(aID) Then
            imgVer.Src = ResolveUrl("~/images/16x16_blue_check.png")
            imgVer.Attributes("title") = "Verification complete"
        End If

    End Sub

    Protected Sub Page_LoadComplete(sender As Object, e As System.EventArgs) Handles Me.LoadComplete
        If Not (ddlCompany.SelectedValue = "10" Or ddlCompany.SelectedValue = "11") Then
            tabCustomPackage.Visible = False
            tabGenericPackage.Visible = False
        End If

        'If (ddlCompany.SelectedValue = "19") Then
        '    Response.Redirect(String.Format("~/clients/enrollment/newenrollment3.aspx?id={0}&p1=0&p2=0&s=1", aID))
        'End If
        If Not (UserID = 2374 Or UserID = 493 Or UserID = 1848) Then
            Response.Redirect(String.Format("~/clients/enrollment/newenrollment3.aspx?id={0}&p1=0&p2=0&s=1", aID))
        End If
    End Sub

    Protected Sub Page_PreInit(sender As Object, e As System.EventArgs) Handles Me.PreInit
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        AgencyID = Integer.Parse(DataHelper.FieldLookup("tblUser", "AgencyID", "UserId=" & UserID))



        If AgencyID <> 858 Then
            'query variables 
            Dim leadappid As String = ""
            Dim p1 As String = ""
            Dim p2 As String = ""
            Dim saved As String = ""

            'query assignments
            leadappid = Request.QueryString("id")
            p1 = Request.QueryString("p1")
            p2 = Request.QueryString("p2")
            saved = Request.QueryString("s")

            'redirect
            'Response.Redirect(String.Format("~/clients/enrollment/newenrollment3.aspx?id={0}&p1={1}&p2={2}&s={3}", leadappid, p1, p2, saved))
        End If
    End Sub

    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad
        Loading = True
    End Sub

    'jhope 9/23/2010

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Loading = True
    End Sub

    Protected Sub btnAppointmentRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAppointmentRefresh.Click
        BindAppointments()
    End Sub

    Protected Sub btnCoAppRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCoAppRefresh.Click
        Dim aID As Integer = Request.QueryString("id")

        dsCoApp.SelectParameters("applicantID").DefaultValue = aID
        dsCoApp.DataBind()
    End Sub

    Protected Sub btnCreditorRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreditorRefresh.Click
        Dim aID As Integer = Request.QueryString("id")
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim creditorInfo() As String = hdnCreditorInfo.Value.Split("|")
        Dim CreditorID As Integer = CInt(creditorInfo(0))
        Dim CreditorGroupID As Integer = CInt(creditorInfo(7))

        If CreditorID = -1 Then
            If CreditorGroupID = -1 Then
                CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(creditorInfo(1), UserID)
            End If
            CreditorID = CreditorHelper.InsertCreditor(creditorInfo(1), creditorInfo(2), creditorInfo(3), creditorInfo(4), Integer.Parse(creditorInfo(5)), creditorInfo(6), UserID, CreditorGroupID)
        End If

        If Val(hdnLeadCreditorInstance.Value) > 0 Then
            strSQL = "UPDATE tblLeadCreditorInstance SET "
            strSQL += "CreditorGroupID = " & CreditorGroupID & ", "
            strSQL += "CreditorID = " & CreditorID & ", "
            strSQL += "Name = '" & creditorInfo(1).Replace("'", "''") & "', "
            strSQL += "Street = '" & creditorInfo(2).Replace("'", "''") & "', "
            strSQL += "Street2 = '" & creditorInfo(3).Replace("'", "''") & "', "
            strSQL += "City = '" & creditorInfo(4).Replace("'", "''") & "', "
            strSQL += "StateID = " & creditorInfo(5) & ", "
            strSQL += "ZipCode = '" & creditorInfo(6) & "', "
            strSQL += "Modified = '" & Now & "', "
            strSQL += "ModifiedBy = " & UserID & " "
            strSQL += "WHERE leadCreditorInstance = " & hdnLeadCreditorInstance.Value
        Else
            strSQL = "INSERT INTO tblLeadCreditorInstance (LeadApplicantID, CreditorGroupID, CreditorID, Name, Street, Street2, City, StateID, ZipCode, Balance, Created, CreatedBy, Modified, ModifiedBy) "
            strSQL += "VALUES ("
            strSQL += aID & ", "
            strSQL += CreditorGroupID & ", "
            strSQL += CreditorID & ", '"
            strSQL += creditorInfo(1).Replace("'", "''") & "', '"
            strSQL += creditorInfo(2).Replace("'", "''") & "', '"
            strSQL += creditorInfo(3).Replace("'", "''") & "', '"
            strSQL += creditorInfo(4).Replace("'", "''") & "', "
            strSQL += creditorInfo(5) & ", '"
            strSQL += creditorInfo(6) & "', "
            strSQL += "0,'"
            strSQL += Now & "', "
            strSQL += UserID & ", '"
            strSQL += Now & "', "
            strSQL += UserID & ")"
        End If

        cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
        cmd.Connection.Open()
        cmd.ExecuteNonQuery()

        If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()

        SaveCreditorAccountInfo()

        dsCreditors.SelectParameters("applicantID").DefaultValue = aID
        wGrdCreditors.DataBind()
        wGrdCreditors.Visible = True
    End Sub

    Protected Sub btnForCreditorRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnForCreditorRefresh.Click
        'Dim aID As Integer = Request.QueryString("id")
        'Dim strSQL As String
        'Dim cmd As SqlCommand
        'Dim creditorInfo() As String = hdnForCreditorInfo.Value.Split("|")

        'Try
        '    If Val(hdnLeadCreditorInstance.Value) > 0 Then
        '        strSQL = "UPDATE tblLeadCreditorInstance SET "
        '        strSQL += "ForCreditorGroupID = " & creditorInfo(7) & ", "
        '        strSQL += "ForCreditorID = " & creditorInfo(0) & ", "
        '        strSQL += "ForName = '" & creditorInfo(1).Replace("'", "''") & "', "
        '        strSQL += "ForStreet = '" & creditorInfo(2).Replace("'", "''") & "', "
        '        strSQL += "ForStreet2 = '" & creditorInfo(3).Replace("'", "''") & "', "
        '        strSQL += "ForCity = '" & creditorInfo(4).Replace("'", "''") & "', "
        '        strSQL += "ForStateID = " & creditorInfo(5) & ", "
        '        strSQL += "ForZipCode = '" & creditorInfo(6) & "', "
        '        strSQL += "Modified = '" & Now & "', "
        '        strSQL += "ModifiedBy = " & UserID & " "
        '        strSQL += "WHERE leadCreditorInstance = " & hdnLeadCreditorInstance.Value

        '        cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
        '        cmd.Connection.Open()
        '        cmd.ExecuteNonQuery()
        '        cmd.Connection.Close()

        '        dsCreditors.SelectParameters("applicantID").DefaultValue = aID
        '        wGrdCreditors.DataBind()
        '        wGrdCreditors.Visible = True
        '    End If
        'Catch ex As Exception
        '    'do nothing
        'End Try
    End Sub

    Protected Sub btnNotesRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNotesRefresh.Click
        Dim aID As Integer = Request.QueryString("id")

        dsNotes.SelectParameters("applicantID").DefaultValue = aID
        dsNotes.DataBind()
    End Sub

    Protected Sub btnRemoveAppointment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveAppointment.Click
        Dim AppointmentId As Integer = hdnAppointmentId.Value
        CIDAppointmentHelper.UpdateLeadAppointment(AppointmentId, "", Nothing, Nothing, "", LeadAppointmentStatus.Cancelled, "", Nothing, Nothing, Nothing, UserID)
        'BindAppointments()
    End Sub

    Protected Sub btnRemoveBank_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveBank.Click
        Dim cmd As SqlCommand

        Try
            cmd = New SqlCommand("delete from tblLeadBanks where LeadBankID = " & hdnLeadBankID.Value, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            BindBanks()
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Protected Sub btnRemoveCoApp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveCoApp.Click
        Dim cmd As SqlCommand

        Try
            cmd = New SqlCommand("delete from tblLeadCoApplicant where LeadCoApplicantID = " & hdnLeadCoApplicantID.Value, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            dsCoApp.SelectParameters("applicantID").DefaultValue = aID
            dsCoApp.DataBind()
            ShowGrid(dsCoApp, wGrdCoApp)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Protected Sub btnRemoveCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveCreditor.Click
        Try
            SaveCreditorAccountInfo()
            Dim connectionString As String = "server= lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180"

            'Dim params(0) As SqlParameter
            'params(0) = New SqlParameter("@LeadCreditorInstance", CInt(hdnLeadCreditorInstance.Value))
            'SqlHelper.ExecuteNonQuery("stp_enrollment_removeLeadCreditorInstance", , params)
            Dim updateString = "UPDATE tblLeadCreditorInstance SET Represented = @Represented WHERE LeadCreditorInstance = @LeadCreditorInstance"
            Using connection As SqlConnection = New SqlConnection(connectionString)
                Using command As SqlCommand = New SqlCommand(updateString, connection)

                    command.Parameters.AddWithValue("@LeadCreditorInstance", CInt(hdnLeadCreditorInstance.Value))
                    command.Parameters.AddWithValue("@Represented", 0)

                    connection.Open()
                    command.ExecuteNonQuery()
                    connection.Close()
                End Using
            End Using

            dsCreditors.SelectParameters("applicantID").DefaultValue = aID
            wGrdCreditors.DataBind()
            ShowGrid(dsCreditors, wGrdCreditors)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Protected Sub btnSaveAndNoEndPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveAndNoEndPage.Click
        SaveAndNoEndPage()
    End Sub

    Protected Sub btnSendFollowup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendFollowup.Click
        If Not InStr(txtEmailAddress.Text, "@") > 1 AndAlso Not InStr(txtEmailAddress.Text, ".") > 5 Then
            divMsg.Style("display") = ""
            divMsg.InnerText = "Please enter a valid email address."
        Else
            If lblFollowup.Text.Contains("#2") Then
                HydraHelper.SendFollowup(HydraHelper.EmailType.Followup_2, aID, txtEmailAddress.Text, UserID, CInt(ddlCompany.SelectedItem.Value))
            Else
                HydraHelper.SendFollowup(HydraHelper.EmailType.Followup_1, aID, txtEmailAddress.Text, UserID, CInt(ddlCompany.SelectedItem.Value))
            End If
            SetupEmailComm()
            gvLeadEmails.DataBind()
        End If
    End Sub

    Protected Sub ddlProduct_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProduct.SelectedIndexChanged
        Dim serviceFee As Double = CDbl(SqlHelper.ExecuteScalar("select isnull(servicefee,60) from tblleadproducts where productid = " & ddlProduct.SelectedItem.Value, CommandType.Text))
        'CalculatorModelControl1.MonthlyFeePerAcct = serviceFee
        'CalculatorModelControl1.ServiceFeeCap = serviceFee
        'CalculatorModelControl1.DepositCommittment = serviceFee * 2
        'CalculatorModelControl1.ReCalcModel(aID)

        If ddlProduct.SelectedItem.Text = "PAYDAY-LOANS" Then
            AgencyID = 870
            hdnProductId.Value = 215
            Save(a, aID)
        ElseIf ddlProduct.SelectedItem.Value = 213 OrElse ddlProduct.SelectedItem.Value = 216 OrElse ddlProduct.SelectedItem.Value = 217 Then
            AgencyID = 868
            hdnProductId.Value = ddlProduct.SelectedItem.Value
            Save(a, aID)
        Else
            'Do Nothing
        End If

        If IsPostBack Then
            hdnProcessingPattern.Value = ChangeProcessingPattern(ddlProduct.SelectedItem.Value)
            SqlHelper.ExecuteNonQuery(String.Format("Update tblLeadApplicant set ProcessingPattern = '{0}' where leadapplicantid = {1}", hdnProcessingPattern.Value, aID), CommandType.Text)
        End If

        'If aID > 0 Then
        '    Save(a, aID)
        'End If

    End Sub

    Protected Sub ddlReasons_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlReasons.SelectedIndexChanged
        trReasonOther.Visible = (ddlReasons.SelectedItem.Text = "Other")

    End Sub

    Protected Sub ddlStatus_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlStatus.SelectedIndexChanged
        Dim reasonid As Integer = -1
        If Not ddlReasons.SelectedItem Is Nothing AndAlso Not ddlReasons.SelectedItem.Value Is Nothing Then
            reasonid = ddlReasons.SelectedItem.Value
        End If
        ReloadReasons(reasonid)
    End Sub

    Protected Sub ddlVendor_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVendor.SelectedIndexChanged
        Loading = True
        ddlProduct.Items.Clear()
        bindDDL(ddlProduct, String.Format("select productid, productcode from tblleadproducts where vendorid = {0} and active = 1 order by productcode", ddlVendor.SelectedItem.Value), "productcode", "productid")
        If ddlProduct.Items.Count = 0 Then
            ddlProduct.Items.Add(New ListItem("Please select a vendor", -1))
        End If
        Loading = False
        ddlProduct_SelectedIndexChanged(Nothing, Nothing)
    End Sub

    Protected Sub gvDocuments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocuments.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            'Select Case rowView("documentName").ToString
            '    Case "Legal Service Agreement - CID"

            '    Case Else
            '        e.Row.Style("display") = "none"
            'End Select
            If IsDate(e.Row.Cells(5).Text) Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style.Item("color") = "#000"
                Next
            End If

        End If
    End Sub

    Protected Sub gvVerification_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVerification.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(2).Text.Equals("Y") Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style.Item("color") = "#000"
                Next
            End If
            Dim dv As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim colIndex As Integer = GetGridColumnIndex(Me.gvVerification, "Rec")
            'Recorded File Column
            Dim img As HtmlImage = CType(e.Row.Cells(colIndex).FindControl("ImgRec"), HtmlImage)
            Dim aAnchor As HtmlAnchor = CType(e.Row.Cells(colIndex).FindControl("aRecFile"), HtmlAnchor)
            Dim leaddocpath As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString
            Dim leaddocvirtualpath As String = ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString
            Dim ehostdomain As String = System.Configuration.ConfigurationManager.AppSettings("externalhostdomain").ToString
            img.Visible = (Not dv("RecCallIdKey") Is DBNull.Value AndAlso dv("RecCallIdKey").ToString.Trim.Length > 0)
            If Not dv("RecordedCallPath") Is DBNull.Value AndAlso dv("RecordedCallPath").ToString.Trim.Length > 0 Then
                img.Src = "~/images/wav_rec.png"
                If Me.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
                    aAnchor.HRef = dv("RecordedCallPath").ToString.Trim.Replace(leaddocpath, leaddocvirtualpath).Replace("\", "/")
                Else
                    aAnchor.HRef = dv("RecordedCallPath").ToString.Trim
                End If
            Else
                img.Src = "~/images/wav_dis.png"
                aAnchor.HRef = "#"
            End If
            'Document Path Column
            colIndex = GetGridColumnIndex(Me.gvVerification, "Doc")
            img = CType(e.Row.Cells(colIndex).FindControl("ImgRecDoc"), HtmlImage)
            aAnchor = CType(e.Row.Cells(colIndex).FindControl("aRecDoc"), HtmlAnchor)
            If Not dv("DocumentPath") Is DBNull.Value AndAlso dv("DocumentPath").ToString.Trim.Length > 0 Then
                img.Src = "~/images/16x16_pdf.png"
                img.Style("Display") = "block"
                If Me.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
                    aAnchor.HRef = dv("DocumentPath").ToString.Trim.Replace(leaddocpath, leaddocvirtualpath).Replace("\", "/")
                Else
                    aAnchor.HRef = dv("DocumentPath").ToString.Trim
                End If
            Else
                img.Src = ""
                img.Style("Display") = "none"
                aAnchor.HRef = "#"
            End If
        End If
    End Sub

    Private Function GetGridColumnIndex(ByVal grv As System.Web.UI.WebControls.GridView, ByVal HeaderText As String) As Integer
        For Each col As System.Web.UI.WebControls.DataControlField In grv.Columns
            If col.HeaderText.Trim.ToLower = HeaderText.Trim.ToLower Then
                Return grv.Columns.IndexOf(col)
            End If
        Next
        Return -1
    End Function


    Protected Sub lnkCreditReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCreditReport.Click
        Dim invalidBorrowers As String = ""

        If CredStarHelper.ValidateBorrowers(aID, invalidBorrowers) Then
            Response.Redirect(String.Format("credit/request2.aspx?id={0}", aID))
        Else
            divMsg.Style("display") = ""
            divMsg.InnerText = "The following fields are required to request a credit report: First Name, Last Name, Street, City, State, Zip Code, SSN. Please provide missing information for " & invalidBorrowers
        End If
    End Sub

    Protected Sub lnkGenerate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGenerate.Click
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantId", aID))
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoForPrivica", CommandType.StoredProcedure, params.ToArray)
        Dim locked As Boolean

        'check if lsa is locked
        If Not IsDBNull(dt.Rows(0)("LSALocked")) Then
            locked = dt.Rows(0)("LSALocked")
        ElseIf IsDBNull(dt.Rows(0)("LSALocked")) Then
            locked = True
        Else
            locked = True
        End If

        Select Case chkElectronicLSA.Checked
            Case True
                If locked = 0 Then
                    generateLSA(True, True)
                Else
                    divMsg.Style("display") = ""
                    divMsg.InnerText = "Generating E-LSA is locked until ""Privica QA"" is completed OR ""ID's to Privica"" is completed."
                End If
            Case Else
                If locked = 0 Then
                    generateLSA()
                Else
                    divMsg.Style("display") = ""
                    divMsg.InnerText = "Generating LSA is locked until ""Privica QA"" is completed OR ""ID's to Privica"" is completed."
                End If

        End Select
    End Sub

    Protected Sub lnkGo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGo.Click
        Dim bLexx As Boolean = False
        Select Case rblSignChoice.SelectedValue.ToLower
            Case "lexx"
                bLexx = True
            Case Else
                bLexx = False
        End Select
        generateLSA(True, bLexx)
    End Sub

    'Disconnect for FreePBX call controls
    'Commented Out by CCastelo 2018/03/05
    'Protected Sub lnkLeadDisconnectType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLeadDisconnectType.Click
    '    Dim LeadId As Integer = aID
    '    Dim CallMadeId As Integer = hdnCIDDialerCallMadeId.Value
    '    Dim resultid As Integer = Me.hdnLeadDisconnectType.Value.Trim
    '    'Update Call Made
    '    DialerHelper.UpdateLeadCallMade(CallMadeId, "", "", Nothing, "", resultid)
    '    'Update Appointment Call if applies
    '    CIDAppointmentHelper.UpdateAppointmentStatus4Result(CallMadeId, resultid, UserID)
    '    Dim bStatusChanged As Boolean = DialerHelper.CIDDialerChangeStatusOnDisconnect(LeadId, resultid, UserID)
    '    'Update Status
    '    If bStatusChanged Then
    '        Dim StatusId As Integer = DialerHelper.GetLeadStatus(aID)
    '        Dim reasonId As Nullable(Of Integer) = DialerHelper.GetLeadReason(aID)
    '        ddlStatus.SelectedIndex = ddlStatus.Items.IndexOf(ddlStatus.Items.FindByValue(StatusId))
    '        If reasonId.HasValue Then
    '            ddlReasons.SelectedIndex = ddlReasons.Items.IndexOf(ddlReasons.Items.FindByValue(reasonId.Value))
    '        End If
    '    End If
    '    'Disconnect call
    '    DisconnectCurrentCall()
    '    'DisconnectSpecificCall(CallMadeId)
    'End Sub

    'Disconnect for Vicidial
    'Commented Out by CCastelo 2018/03/05
    'Protected Sub lnkViciLeadDisposition_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkViciLeadDisposition.Click
    '    Dim LeadId As Integer = aID
    '    Dim StatusId As Integer = CInt(Me.hdnViciLeadDispoStatus.Value)
    '    Dim ReasonId As Integer = Val(Me.hdnViciLeadDispoReason.Value)
    '    Dim bStatusChanged As Boolean = VicidialHelper.CIDDialerChangeStatusOnDisconnect(LeadId, StatusId, ReasonId, UserID)
    '    If bStatusChanged Then
    '        ddlStatus.SelectedIndex = ddlStatus.Items.IndexOf(ddlStatus.Items.FindByValue(StatusId))
    '        If ReasonId > 0 Then
    '            ReloadReasons(ReasonId)
    '            ddlReasons.SelectedIndex = ddlReasons.Items.IndexOf(ddlReasons.Items.FindByValue(ReasonId))
    '        End If
    '        trReasons.Visible = (ReasonId > 0)
    '        SaveAndNoEndPage()
    '    End If
    'End Sub

    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click
        Loading = False
        Save(a, aID, True)
        Loading = False
    End Sub

    Protected Sub lnkSaveAndRedirect_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndRedirect.Click
        Loading = False
        Save(a, aID, False)
        Loading = False
        'redirect
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Loading = False
        Save(a, aID)
        Loading = False
    End Sub

    Protected Sub txtSZip_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSZip.TextChanged
        Try
            ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)

            Dim loc() As CityStateLocations = AssistedSolutions.WebControls.CityStateFinder.CityStateFinder.SearchOn(txtSZip.Text, True)
            Dim li As ListItem
            Dim CompanyID As String

            If loc.Length > 0 Then
                cboStateID.ClearSelection()
                li = cboStateID.Items.FindByText(loc(0).StateAbbreviation)
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
                txtCity.Text = loc(0).City

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.CommandText = "select x.companyid from tblStatesAgencyXRef x join tblState s on s.StateID = x.StateId where active = 1 and s.name = '" & loc(0).StateName & "' and x.AgencyId = " & AgencyID
                        cmd.Connection.Open()
                        CompanyID = CStr(cmd.ExecuteScalar())
                        ddlCompany.ClearSelection()
                        li = ddlCompany.Items.FindByValue(CompanyID)
                        If Not IsNothing(li) Then
                            li.Selected = True
                            ddlCompany.Enabled = False
                        End If
                    End Using
                End Using

                CheckState()
            End If

            'Populate client name in step 3 only if a name does not already exist there
            'If txtFirstName.Text.Trim = "" AndAlso txtLastName.Text.Trim = "" Then

            '    txtName.Text = Regex.Replace(txtName.Text.Trim, "\s+", " ")

            '    Dim name As String() = Split(txtName.Text, " ")
            '    If name.Length > 0 Then
            '        txtFirstName.Text = name(0)
            '        If name.Length > 1 Then
            '            'Get Middle Initial
            '            Dim nIndex As Integer = 1
            '            If name(1).Length = 1 OrElse (name(1).Length < 3 AndAlso name(1).EndsWith(".")) Then
            '                txtFirstName.Text = txtFirstName.Text & " " & name(1)
            '                nIndex = 2
            '            End If
            '            'Get LastName(s)
            '            txtLastName.Text = String.Join(" ", name, nIndex, name.GetUpperBound(0) - nIndex + 1)
            '        End If
            '    End If
            'End If

        Catch ex As Exception
            ddlCompany.Enabled = True
        Finally
            'always populate even if web service is not working
            txtZip.Text = txtSZip.Text
        End Try
    End Sub

    Protected Sub uwgAppointments_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles uwgAppointments.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim AppointmentID As Integer = e.Row.Cells(3).Value.ToString
        Dim StatusId As Integer = e.Row.Cells(4).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditAppointment(" & AppointmentID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"
        Dim strDelete As String = "<a href=""javascript:RemoveAppointment(" & AppointmentID & ");"" title=""Cancel Appointment"" ><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ style=""border-style: none"" /></a>"

        e.Row.Cells(1).Style.Padding.Left = Unit.Pixel(3)
        e.Row.Cells(1).Value = strUrl

        'e.Row.Cells(0).AllowEditing = AllowEditing.No

        If (StatusId = LeadAppointmentStatus.Pending) Then
            e.Row.Cells(0).Text = strDelete
            e.Row.Cells(0).Style.BackColor = System.Drawing.Color.Gold
            e.Row.Cells(1).Style.BackColor = System.Drawing.Color.Gold
            e.Row.Cells(2).Style.BackColor = System.Drawing.Color.Gold
        Else
            e.Row.Cells(0).Text = ""
            e.Row.Cells(1).Style.BackColor = Nothing
        End If

        e.Row.Cells(2).Style.Padding.Left = Unit.Pixel(3)
    End Sub

    Protected Sub wGrdBanking_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles wGrdBanking.DataBound
        'disable lsa void check
        'option if no routing number
        chkVoidedCheck.Enabled = True
        If Not IsNothing(TryCast(dsBanks.Select(DataSourceSelectArguments.Empty), DataView)) Then
            Using dt As DataTable = TryCast(dsBanks.Select(DataSourceSelectArguments.Empty), DataView).ToTable()
                If dt.Rows.Count > 0 Then
                    Dim rn As String = dt.Rows(0).Item("routingnumber").ToString
                    If Len(rn.Trim) = 9 Then
                        chkVoidedCheck.Enabled = True
                    End If
                    lnkAddBanks.Visible = False
                ElseIf aID > 0 Then
                    lnkAddBanks.Visible = True
                End If
            End Using
        End If
    End Sub

    Protected Sub wGrdBanking_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdBanking.InitializeLayout
        e.Layout.Bands(0).Columns.Add("Type", "Type")
        e.Layout.Bands(0).Columns.FromKey("Type").CellStyle.HorizontalAlign = HorizontalAlign.Center
        e.Layout.Bands(0).Columns.FromKey("Type").Width = Unit.Pixel(65)
        e.Layout.Bands(0).Columns.FromKey("Checking").Hidden = True
    End Sub

    Protected Sub wGrdBanking_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdBanking.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim bankID As Integer = e.Row.Cells(5).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditBank(" & bankID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"
        e.Row.Cells(1).Value = strUrl

        Dim strAcctNum As String = e.Row.Cells(3).Value.ToString
        e.Row.Cells(3).Value = "**" & Right(strAcctNum, 4)

        Dim strAcctType As String = ""
        Select Case e.Row.Cells(4).Value.ToString
            Case False
                strAcctType = "Savings"
            Case True
                strAcctType = "Checking"
        End Select

        e.Row.Cells.FromKey("type").Value = strAcctType
    End Sub

    Protected Sub wGrdCoApp_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdCoApp.InitializeLayout
        Me.wGrdCoApp.DataKeyField = "LeadCoApplicantID"
        e.Layout.Bands(0).DataKeyField = "LeadCoApplicantID"
        e.Layout.Bands(0).BaseTableName = "tblLeadCoApplicant"

        e.Layout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes
        e.Layout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes
        'e.Layout.AllowDeleteDefault = AllowDelete.Yes  --20180306
    End Sub

    Protected Sub wGrdCoApp_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdCoApp.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim coAppID As Integer = e.Row.Cells(3).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditCoApp(" & coAppID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"

        e.Row.Cells(1).Style.Padding.Left = Unit.Pixel(3)
        e.Row.Cells(1).Value = strUrl
    End Sub

    Protected Sub wGrdCreditors_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles wGrdCreditors.DataBound
        CalculatorModelControl1.ReCalcModel(aID)
    End Sub

    Protected Sub wGrdCreditors_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdCreditors.InitializeLayout
        Me.wGrdCreditors.DataKeyField = "LeadCreditorInstance"
        e.Layout.Bands(0).DataKeyField = "LeadCreditorInstance"
        e.Layout.Bands(0).BaseTableName = "tblLeadCreditorInstance"
        e.Layout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
        e.Layout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.No
        'e.Layout.AllowDeleteDefault = AllowDelete.Yes
    End Sub

    Protected Sub wGrdCreditors_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdCreditors.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim creditorInstanceID As Integer = e.Row.Cells(4).Value.ToString
        Dim title As String = ""

        If Len(cellValue) > 30 Then
            cellValue = Left(cellValue, 30) & ".."
            title = e.Row.Cells(1).Value.ToString.Replace("'", "")
        End If
        e.Row.Cells(1).Value = "<a href='javascript:EditCreditor(" & creditorInstanceID & ",""" & e.Row.Cells(1).Value.ToString.Replace("'", "") & """,""" & e.Row.Cells(7).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(8).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(9).Value.ToString.Replace("""", "'") & """," & e.Row.Cells(10).Value & ",""" & e.Row.Cells(11).Value.ToString.Replace("""", "'") & """);' title='" & title & "'>" & Server.HtmlEncode(cellValue) & "</a>"

        ''For Creditor
        'cellValue = e.Row.Cells(2).Value.ToString
        'If Trim(cellValue) = "" Then
        '    strUrl = "<a href='javascript:AddForCreditor(" & creditorInstanceID & ")'>[add]</a>"
        'Else
        '    strUrl = "<a href='javascript:EditForCreditor(" & creditorInstanceID & ",""" & e.Row.Cells(2).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(13).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(14).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(15).Value.ToString.Replace("""", "'") & """," & e.Row.Cells(16).Value & ",""" & e.Row.Cells(17).Value.ToString.Replace("""", "'") & """);'>" & Server.HtmlEncode(cellValue) & "</a>"
        'End If
        'e.Row.Cells(2).Value = strUrl
    End Sub

    Protected Sub wGrdNotes_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdNotes.InitializeRow

        Dim cellValue As String = CType(e.Row.Cells(2).Value.ToString, String)
        Dim noteID As Integer = e.Row.Cells(4).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditNote(" & noteID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"

        e.Row.Cells(2).Value = strUrl
    End Sub

    Private Sub AssignHardshipData(ByVal rdr As SqlDataReader)
        Dim debt As Double
        Dim income As Double
        Dim li As ListItem

        If rdr.Read Then
            income = Val(rdr("MonthlyIncome"))
            debt = rdr("Groceries") + rdr("CarIns") + rdr("HealthIns") + rdr("Utilities") + rdr("PhoneBill") + rdr("HomeIns") + rdr("CarPayments") + rdr("AutoFuel") + rdr("DiningOut") + rdr("Entertainment") + rdr("HouseRent") + rdr("Other")
            lblDebtToIncome.Text = FormatPercent(debt / income, 0)

            li = ddlHardship.Items.FindByText(rdr("Hardship"))
            If Not IsNothing(li) Then
                ddlHardship.ClearSelection()
                li.Selected = True
            End If

            If ddlHardship.SelectedItem.Text = "Other" Then
                trHardshipOther.Style("display") = ""
            End If

            li = ddlOwnRent.Items.FindByText(rdr("OwnRent"))
            If Not IsNothing(li) Then
                ddlOwnRent.ClearSelection()
                li.Selected = True
            End If

            txtHomePrinciple.Text = Format(rdr("HomePrinciple"), "0.00")
            txtHomeValue.Text = Format(rdr("HomeValue"), "0.00")
            txt401K.Text = Format(rdr("401K"), "0.00")
            txtSavChecking.Text = Format(rdr("SavingsChecking"), "0.00")
            txtOtherAssets.Text = Format(rdr("OtherAssets"), "0.00")
            'attempts to get the formatted value of nvarchar field otherwise displays nvarchar
            Dim value As String = rdr("OtherDebts").ToString
            Dim number As Decimal
            If Decimal.TryParse(value, number) Then
                txtOtherDebts.Text = Format(number, "0.00")
            ElseIf String.IsNullOrEmpty(rdr("OtherDebts").ToString) Then
                txtOtherDebts.Text = "0.00"
            Else
                txtOtherDebts.Text = rdr("OtherDebts").ToString
            End If
            txtIncome.Text = Format(rdr("MonthlyIncome"), "0.00")
            txtGroceries.Text = Format(rdr("Groceries"), "0.00")
            txtCarIns.Text = Format(rdr("CarIns"), "0.00")
            txtHealthIns.Text = Format(rdr("HealthIns"), "0.00")
            txtUtilities.Text = Format(rdr("Utilities"), "0.00")
            txtPhoneBill.Text = Format(rdr("PhoneBill"), "0.00")
            txtHomeIns.Text = Format(rdr("HomeIns"), "0.00")
            txtCarPymt.Text = Format(rdr("CarPayments"), "0.00")
            txtAutoFuel.Text = Format(rdr("AutoFuel"), "0.00")
            txtDiningOut.Text = Format(rdr("DiningOut"), "0.00")
            txtEntertainment.Text = Format(rdr("Entertainment"), "0.00")
            txtHousePymt.Text = Format(rdr("HouseRent"), "0.00")
            txtOtherMthly.Text = Format(rdr("Other"), "0.00")
            If IsDBNull(rdr("HardshipOther")) Then
                txtHardshipOther.Text = ""
            Else
                txtHardshipOther.Text = rdr("HardshipOther")
            End If
            If IsDBNull(rdr("Occupation")) Then
                txtOccupation.Text = ""
            Else
                txtOccupation.Text = rdr("Occupation").ToString
            End If
            If IsDBNull(rdr("NumOfKidsInHouse")) Then
                txtKids.Text = "0"
            Else
                txtKids.Text = rdr("NumOfKidsInHouse").ToString
            End If

            If IsDBNull(rdr("NumOfGrandKidsInHouse")) Then
                txtGrandKids.Text = "0"
            Else
                txtGrandKids.Text = rdr("NumOfGrandKidsInHouse").ToString
            End If

            If IsDBNull(rdr("Work_Income")) Then
                txtWorkIncome.Text = "0.00"
            Else
                txtWorkIncome.Text = Format(rdr("Work_Income"), "0.00")
            End If
            If IsDBNull(rdr("SocialSecurity_Income")) Then
                txtSSIncome.Text = "0.00"
            Else
                txtSSIncome.Text = Format(rdr("SocialSecurity_Income"), "0.00")
            End If
            If IsDBNull(rdr("Disability_Income")) Then
                txtDisability.Text = "0.00"
            Else
                txtDisability.Text = Format(rdr("Disability_Income"), "0.00")
            End If
            If IsDBNull(rdr("Retirement_Income")) Then
                txtRetirePen.Text = "0.00"
            Else
                txtRetirePen.Text = Format(rdr("Retirement_Income"), "0.00")
            End If
            If IsDBNull(rdr("Unemployment_Income")) Then
                txtUnemployment.Text = "0.00"
            Else
                txtUnemployment.Text = Format(rdr("Unemployment_Income"), "0.00")
            End If
            If IsDBNull(rdr("SelfEmployed_Income")) Then
                txtSelfEmployed.Text = "0.00"
            Else
                txtSelfEmployed.Text = Format(rdr("SelfEmployed_Income"), "0.00")
            End If
            'Dim hIncomeTypes() As String = Split(rdr("monthlyincometypes").ToString, ",")
            'For Each hi As ListItem In cblHardshipIncome.Items
            '    For i As Integer = 0 To hIncomeTypes.Length - 1
            '        If hIncomeTypes(i) = hi.Value Then
            '            hi.Selected = True
            '        End If
            '    Next
            'Next
            If rdr("seed").ToString.Trim.Length > 0 Then
                lblKeyword.Text = "Keyword: " & rdr("seed").ToString
            End If
        End If
    End Sub

    Private Sub AssignTheApplicantCalculatorData(ByVal rdr As SqlDataReader, Optional ByVal ProductID As Integer = 0)
        Dim li As ListItem

        While rdr.Read
            '2. Calculator
            CalculatorModelControl1.TotalDebt = Format(rdr.Item("TotalDebt"), "0.##")
            CalculatorModelControl1.InitialDeposit = CInt(rdr.Item("InitialDeposit"))
            CalculatorModelControl1.DepositCommittment = CInt(rdr.Item("DepositCommittment"))

            If Not IsDBNull(rdr.Item("MaintenanceFeeCap")) Then
                'Calulator has been saved
                With CalculatorModelControl1
                    .ServiceFeeCap = Format(rdr.Item("MaintenanceFeeCap"), "0.00")
                    .TotalNumberOfAccts = rdr.Item("NoAccts")
                    .SettlementFeePct = rdr.Item("SettlementFeePct")
                    .EstimateGrowthPct = rdr.Item("EstGrowth")
                    .InterestRate = rdr.Item("PBMIntRate")
                    .MinPaymentAmt = rdr.Item("PBMMinAmt")
                    .MinPaymentPct = rdr.Item("PBMMinPct")
                End With
            End If
            'removed ccastelo 9/27/12
            'If Not IsDBNull(rdr.Item("ServiceFeePerAcct")) Then
            '    CalculatorModelControl1.MonthlyFeePerAcct = Format(rdr.Item("ServiceFeePerAcct"), "0.00")
            'End If

            If Not rdr.Item("DateOfFirstDeposit") Is DBNull.Value Then
                If CDate(rdr.Item("DateOfFirstDeposit")) > "1/1/1900" Then
                    txtFirstDepositDate.Text = rdr.Item("DateOfFirstDeposit")
                End If
            End If

            li = ddlDepositDay.Items.FindByText(rdr.Item("ReOccurringDepositDay").ToString)
            If Not IsNothing(li) Then
                ddlDepositDay.ClearSelection()
                li.Selected = True
            End If
        End While
    End Sub

    Private Sub AssignTheApplicantData(ByVal rdr As SqlDataReader)
        While rdr.Read
            Dim li As ListItem

            '1. Setup
            Me.txtFName.Text = StrConv(rdr.Item("FirstName").ToString, VbStrConv.ProperCase)
            Me.txtMName.Text = StrConv(rdr.Item("MiddleName").ToString, VbStrConv.ProperCase)
            Me.txtLName.Text = StrConv(rdr.Item("LastName").ToString, VbStrConv.ProperCase)
            Me.txtPhone.Text = rdr.Item("LeadPhone").ToString
            Me.txtSZip.Text = rdr.Item("LeadZip").ToString
            Me.ddlBehind.Items.FindByValue(rdr.Item("BehindID")).Selected = True
            Me.ddlConcerns.Items.FindByValue(rdr.Item("ConcernsID")).Selected = True
            'Me.ddlCompany.Items.FindByValue(rdr.Item("CompanyID")).Selected = True
            Me.ddlCompany.SelectedIndex = Me.ddlCompany.Items.IndexOf(Me.ddlCompany.Items.FindByValue(rdr.Item("CompanyID")))
            Me.ddlLanguage.Items.FindByValue(rdr.Item("LanguageID")).Selected = True
            Me.ddlDelivery.Items.FindByValue(rdr.Item("DeliveryID")).Selected = True

            If Not IsDBNull(rdr("SourceUrl")) Then
                lblLeadSrc.Text = rdr("SourceUrl").ToString
            ElseIf Not IsDBNull(rdr("SourceCampaign")) Then
                lblLeadSrc.Text = rdr("SourceCampaign").ToString
            End If

            If Not IsDBNull(rdr("SourceCampaign")) Then
                lbCampaignSrc.Text = rdr("SourceCampaign").ToString
            End If

            If Not IsDBNull(rdr.Item("Prefix")) Then
                li = ddlPrefix.Items.FindByText(rdr.Item("Prefix"))
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If

            If Not IsDBNull(rdr.Item("RepID")) Then
                li = ddlAssignTo.Items.FindByValue(rdr.Item("RepID"))
                If Not IsNothing(li) Then
                    li.Selected = True
                Else
                    ddlAssignTo.Items.Add(New ListItem(rdr.Item("rep"), rdr.Item("RepID")))
                    ddlAssignTo.Items.FindByValue(rdr.Item("RepID")).Selected = True
                End If
            End If

            li = ddlLeadSource.Items.FindByValue(rdr.Item("LeadSourceID"))
            If Not IsNothing(li) Then
                li.Selected = True
            Else
                'old source, no source, or show is false
                ddlLeadSource.Items.Add(New ListItem(IIf(rdr("source") Is DBNull.Value, "", rdr("source")), rdr("LeadSourceID")))
                ddlLeadSource.Items.FindByValue(rdr("LeadSourceID")).Selected = True
            End If

            '1.12.2010 jhernandez
            'Cannot change the source if RGR/Hydra/PMG lead
            If Not IsDBNull(rdr("RgrId")) Or Not IsDBNull(rdr("PublisherId")) Then
                ddlLeadSource.Enabled = False
            End If

            'Check for ProductID as DNIS. Disable it if is DNIS jhope 9/23/2010
            If Not IsDBNull(rdr.Item("ProductID")) Then
                'Select Case CInt(rdr("ProductID"))
                '    Case 142 'BLOHP 30
                '        CalculatorModelControl1.MonthlyFeePerAcct = 30
                '    Case 143 'BLOHP 60
                '        CalculatorModelControl1.MonthlyFeePerAcct = 60
                '    Case 144 'BLOHP 90
                '        CalculatorModelControl1.MonthlyFeePerAcct = 90
                '    Case Else 'Anything else

                'End Select
                Dim isDNIS As Boolean = DataHelper.FieldLookup("tblLeadProducts", "IsDNIS", "ProductID = " & rdr.Item("ProductID").ToString)
                If isDNIS Then
                    ddlLeadSource.Enabled = False
                End If
            Else
                'lead doesnt have a product ID, allow managers to set one
                'If IsManager Or AgencyID > 0 Then
                '    LoadVendors()
                'End If
            End If

            Dim dt As DataTable = SqlHelper.GetDataTable(String.Format("select p.ProductDesc, p.ProductID, p.VendorId from tblLeadProducts p join tblLeadApplicant l on l.ProductId = p.productId where LeadApplicantID = {0}", aID), CommandType.Text)
            If Not dt Is Nothing Then
                Dim dr As DataRow = dt.Rows(0)
                li = ddlVendor.Items.FindByValue(dr.Item("VendorId"))
                If Not IsNothing(li) Then
                    li.Selected = True
                    ddlVendor_SelectedIndexChanged(Nothing, Nothing)
                End If
            End If

            If Not dt Is Nothing Then
                Dim dr As DataRow = dt.Rows(0)
                li = ddlProduct.Items.FindByValue(dr.Item("ProductID"))
                If Not IsNothing(li) Then
                    ddlProduct.SelectedItem.Selected = False
                    li.Selected = True
                End If
            End If

            li = ddlStatus.Items.FindByValue(rdr.Item("StatusID"))
            If Not IsNothing(li) Then
                li.Selected = True
            Else
                'old status, no status, or show is false
                ddlStatus.Items.Add(New ListItem(IIf(rdr("Status") Is DBNull.Value, "", rdr("Status")), rdr("StatusID")))
                ddlStatus.Items.FindByValue(rdr("StatusID")).Selected = True
            End If

            'If CInt(rdr.Item("StatusID")) = 10 And Not rdr.Item("Processor") Is DBNull.Value Then
            '    If CInt(rdr.Item("Processor")) > 0 Then
            '        trProcessor.Visible = True
            '        Me.ddlProcessor.Items.FindByValue(rdr.Item("Processor")).Selected = True
            '    End If
            'End If

            'If the lead has been converted to a client, lock down Setup
            Dim clientID As Object = SqlHelper.ExecuteScalar("select c.clientid from tblclient c join tblimportedclient i on i.importid = c.serviceimportid join tblleadapplicant l on l.leadapplicantid = i.externalclientid where l.leadapplicantid = " & aID, CommandType.Text)
            If IsNumeric(clientID) Then
                ddlLeadSource.Enabled = False
                ddlCompany.Enabled = False
                ddlAssignTo.Enabled = False
                hdnClientID.Value = clientID
                ddlStatus.Items.Clear()
                Select Case CInt(rdr.Item("StatusID"))
                    Case 18 'Returned
                        bindDDL(ddlStatus, "select statusid, description from tblleadstatus where statusid in (12,18,19,22)", "description", "statusid", False)
                        ddlStatus.Enabled = True
                    Case 21 'Returned by Attorney
                        bindDDL(ddlStatus, "select statusid, description from tblleadstatus where statusid in (12,21,22)", "description", "statusid", False)
                        ddlStatus.Enabled = True
                    Case Else
                        bindDDL(ddlStatus, String.Format("select statusid, description from tblleadstatus where statusid in ({0})", rdr.Item("StatusID")), "description", "statusid", False)
                        ddlStatus.Enabled = False
                End Select
                li = ddlStatus.Items.FindByValue(rdr.Item("StatusID"))
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If

            If Not IsDBNull(rdr("ReasonID")) Then
                bindDDL(ddlReasons, String.Format("select LeadReasonsID, Description from tblLeadReasons where StatusID={0} And (Show = 1 or leadreasonsid = {1}) order by DisplayOrder", rdr("StatusID"), rdr("ReasonID")), "Description", "LeadReasonsID", False)
                li = ddlReasons.Items.FindByValue(rdr("ReasonID"))
                If Not IsNothing(li) Then
                    trReasons.Visible = True
                    li.Selected = True
                    If li.Text = "Other" Then
                        trReasonOther.Visible = True
                        txtReasonOther.Text = CStr(rdr("ReasonOther"))
                    End If
                End If
            End If

            If Not rdr.Item("TimeZoneId") Is DBNull.Value Then
                Me.ddlTimeZone.Items.FindByValue(rdr.Item("TimeZoneId")).Selected = True
            End If
            If Not rdr.Item("FirstAppDate") Is DBNull.Value Then
                Me.FirstAppDate.Value = rdr.Item("FirstAppDate")
            End If
            If Not rdr.Item("FirstAppTime") Is DBNull.Value Then
                Me.FirstAppTime.Value = rdr.Item("FirstAppTime")
                Me.CalculateTime(False)
            End If

            Me.txtPaperLeadCode.Text = rdr.Item("PaperLeadCode").ToString

            If Me.ddlLeadSource.SelectedItem.Text = "Paper Lead" Or Me.ddlLeadSource.SelectedItem.Text = "Radio" Or Me.ddlLeadSource.SelectedItem.Text = "TV" Then
                trPaperLeadCode.Style("display") = ""
            End If

            If aID > 0 AndAlso ddlAssignTo.SelectedIndex > 0 Then 'In pipeline?
                'Only managers can re-assign
                ddlAssignTo.Enabled = (IsManager OrElse PermissionHelperLite.HasPermission(UserID, "Client Intake-Assign to any rep"))
            End If

            'If source is not already locked down by above rules only allow mgrs to set it
            If ddlLeadSource.Enabled And Not (IsManager OrElse PermissionHelperLite.HasPermission(UserID, "Client Intake-Edit Lead Source")) Then
                ddlLeadSource.Enabled = False
            End If

            'Get the closer rep (if avail)
            Dim params(0) As SqlParameter
            Dim tblCloser As DataTable
            params(0) = New SqlParameter("@leadapplicantid", aID)
            tblCloser = SqlHelper.GetDataTable("stp_enrollment_getCloser", CommandType.StoredProcedure, params)
            If tblCloser.Rows.Count = 1 Then
                trCloser.Visible = True
                bindDDL(ddlCloser, "Select UserID, FirstName + ' ' + LastName [Name] from tbluser Where UserGroupId IN (25) and locked = 0 Order by [Name]", "Name", "UserID")
                Dim liCloser As ListItem = ddlCloser.Items.FindByValue(tblCloser.Rows(0)("closerid"))
                If Not IsNothing(liCloser) Then
                    liCloser.Selected = True
                End If
                ddlCloser.Enabled = PermissionHelperLite.HasPermission(UserID, "Client Intake-ReAssign Closer")
                ddlCloser.Attributes.Add("CloserID", tblCloser.Rows(0)("closerid"))
                ddlCloser.Attributes.Add("LeadAuditID", tblCloser.Rows(0)("leadauditid"))
            End If

            '3. Primary
            txtFirstName.Text = StrConv(rdr.Item("FirstName").ToString, VbStrConv.ProperCase)
            txtMiddleName.Text = StrConv(rdr.Item("MiddleName").ToString, VbStrConv.ProperCase)
            txtLastName.Text = StrConv(rdr.Item("LastName").ToString, VbStrConv.ProperCase)
            txtAddress.Text = rdr.Item("Address1").ToString
            txtCity.Text = StrConv(rdr.Item("City").ToString, VbStrConv.ProperCase)
            cboStateID.Items.FindByValue(rdr.Item("StateID")).Selected = True
            txtZip.Text = rdr.Item("ZipCode").ToString
            txtHomePhone.Text = rdr.Item("HomePhone").ToString
            txtBusPhone.Text = rdr.Item("BusinessPhone").ToString
            txtCellPhone.Text = rdr.Item("CellPhone").ToString
            txtFaxNo.Text = rdr.Item("FaxNumber").ToString
            txtSSN.Text = rdr.Item("SSN").ToString
            If IsDate(rdr.Item("DOB")) Then
                If CDate(rdr.Item("DOB")) > "1/1/1900" Then
                    txtDOB.Text = rdr.Item("DOB").ToString
                End If
            End If
            txtEmailAddress.Text = rdr.Item("Email").ToString
            Dim b As Infragistics.WebUI.UltraWebToolbar.TBarButton = CType(Me.uwToolBar.Items.FromKey("switch"), Infragistics.WebUI.UltraWebToolbar.TBarButton)
            b.Visible = (CDate(rdr.Item("Created")) < New Date(2009, 9, 30, 18, 32, 0) AndAlso rdr.Item("LeadTransferOutDate") Is DBNull.Value)

            Dim useCreditReport As Boolean = PermissionHelperLite.HasPermission(UserID, "Client Intake-Credit Report")

            Dim htmlReport As String = String.Empty
            If Not IsDBNull(rdr("ReportID")) Then
                'htmlReport = CredStarHelper2.ShowCreditReport(rdr("ReportID")).Trim
            End If

            Dim hasReport As Boolean = (htmlReport.Length > 0)

            aViewReport.Text = htmlReport
            aViewReport.Visible = hasReport
            spanCredSep2.Visible = hasReport
            Me.tdReport.Visible = hasReport

            spanCredSep.Visible = "True" 'useCreditReport
            lnkCreditReport.Visible = "True"  'useCreditReport AndAlso Not hasReport
            aImportCreditors.Visible = "True" 'useCreditReport AndAlso hasReport

            If useCreditReport AndAlso hasReport Then
                aImportCreditors.HRef = String.Format("credit/import2.aspx?id={0}&reportId={1}", aID, rdr("ReportID"))
            End If

            'Show/hide 3pv documents columns
            Dim verifreports As Boolean = PermissionHelperLite.HasPermission(UserID, "Client Intake-Verification Call-Documents")
            Me.gvVerification.Columns(GetGridColumnIndex(Me.gvVerification, "Doc")).Visible = verifreports
            Me.gvVerification.Columns(GetGridColumnIndex(Me.gvVerification, "Rec")).Visible = verifreports

            If Not IsDBNull(rdr.Item("ProcessingPattern")) Then
                hdnProcessingPattern.Value = rdr.Item("ProcessingPattern").ToString
            End If

        End While
    End Sub

    Private Sub AutoInsertLead()
        If Not Me.ddlAssignTo.Items.FindByValue(UserID) Is Nothing Then
            Me.ddlAssignTo.Items.FindByValue(UserID).Selected = True
        Else
            Dim rep As String = Drg.Util.DataHelpers.UserHelper.GetName(UserID)
            ddlAssignTo.Items.Add(New ListItem(rep, UserID))
            ddlAssignTo.Items.FindByValue(UserID).Selected = True
        End If
        'Find CompanyId, StateId from Area Code
        If hdnAni.Value.Trim.Length = 10 Then
            Try
                Dim dt As DataTable = SmartDebtorHelper.GetAreaCodeInfo(hdnAni.Value.Trim.Substring(0, 3))
                If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
                    Me.cboStateID.SelectedIndex = Me.cboStateID.Items.IndexOf(Me.cboStateID.Items.FindByValue(dt.Rows(0)("stateid")))
                    Me.ddlCompany.SelectedIndex = Me.ddlCompany.Items.IndexOf(Me.ddlCompany.Items.FindByValue(dt.Rows(0)("companyid")))
                End If
            Catch ex As Exception
                'Do not assign state and low firm
            End Try
        End If
        Me.SaveAndNoEndPage()
    End Sub

    Private Function BeginTheTransfer() As Boolean
        Dim ToShip As New List(Of Lexxiom.ImportClients.ClientInfo)
        Dim JobId As Integer = 0
        Dim LeadIds As New List(Of Integer)
        Dim SmartDebtorSourceId As Integer = 1
        Dim bTransferred As Boolean = True
        Dim ThreePVExists As Boolean = False
        Dim LSAExists As Boolean = False
        Dim dtDocs As DataTable

        dtDocs = SqlHelper.GetDataTable(String.Format("select * from tblLeadDocuments where leadApplicantId = {0} and DocumentTypeId in (222, 345) and currentstatus in ('Document signed', 'Uploaded')", aID), CommandType.Text)

        'For Each rw As DataRow In dtDocs.Rows
        '    If CInt(rw("DocumentTypeId")) = 222 Then 'Checking to see if file type is a LSA
        '        Dim FileExists As Boolean = System.IO.File.Exists(ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString & String.Format("{0}.pdf", rw("DocumentId").ToString))
        '        If FileExists Then
        '            LSAExists = True
        '        End If
        '    End If
        '    If CInt(rw("DocumentTypeId")) = 345 Then 'Checking to see if file type is a LSA
        '        Dim FileExists As Boolean = System.IO.File.Exists(ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString & String.Format("Audio\{0}.wav", rw("DocumentId").ToString))
        '        If FileExists Then
        '            ThreePVExists = True
        '        End If
        '    End If
        'Next

        'If Not AgencyID > 0 Then
        '    ThreePVExists = True
        'End If

        'If Not (LSAExists AndAlso ThreePVExists) Then
        '    If Not LSAExists Then
        '        divMsg.Style("display") = ""
        '        divMsg.InnerHtml &= "Legal Service Agreement is not present.<br />"
        '    End If
        '    If Not ThreePVExists Then
        '        divMsg.Style("display") = ""
        '        divMsg.InnerHtml &= "3PV is not present.<br />"
        '    End If
        '    Return False
        'End If

        Try
            divMsg.Style("display") = "none"
            divMsg.InnerText = ""
            LeadIds.Add(aID)
            JobId = CreateExportJob(UserID)
            CreateExportDetails(JobId, LeadIds)
            LockClients(JobId)
            Try
                ToShip.Add(CreateClient(aID))
            Catch ex As Exception
                UpdateLeadStatus(JobId, aID, ClientImportStatus.failed, ex.Message)
                divMsg.Style("display") = ""
                divMsg.InnerText = "Unable to set lead status to In Process. " & ex.Message
                bTransferred = False
            End Try
            If ToShip.Count = 0 Then Throw New Exception("noship")
            Dim report As ImportReport = ProcessManager.ImportClients(ToShip, SmartDebtorSourceId)
            SaveReport(JobId, report, UserID)
            UnLockClients(JobId)

            If report.SuccededClients.Count = 1 Then
                Dim ClientID As Integer = SmartDebtorHelper.GetClientID(aID)

                'Now we can update the lead's status to In Process
                SqlHelper.ExecuteNonQuery(String.Format("update tblleadapplicant set statusid=10 where leadapplicantid={0}", aID), CommandType.Text)
                Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(aID)
                LeadRoadmapHelper.InsertRoadmap(aID, 10, parentID, "Applicant Status Changed.", UserID)

                'Do actions performed when data entry gets resolved since we're now skipping the data entry worksheet

                RoadmapHelper.InsertRoadmap(ClientID, 7, Nothing, UserID) 'Recieved LSA
                'RoadmapHelper.InsertRoadmap(clientID, 8, Nothing, UserID) 'Recieved deposit

                'CreateDirForClient(ClientID)

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    DatabaseHelper.AddParameter(cmd, "VWDESaved", Now)
                    DatabaseHelper.AddParameter(cmd, "VWDESavedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "VWDEResolved", Now) 'Allows client to skip data entry sheet
                    DatabaseHelper.AddParameter(cmd, "VWDEResolvedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
                    DataHelper.AuditedUpdate(cmd, "tblClient", ClientID, UserID)
                End Using

                'Resolve Data Entry
                TaskHelper.Resolve("tblClientTask.ClientID = " & ClientID & " AND tblTask.TaskTypeID = 12", 1, UserID)

                'Resolve Underwriting for StoneWall
                'If AgencyID > 0 Then
                SmartDebtorHelper.SendToAttorney(ClientID, UserID)
                'End If

                Try
                    'update privica XREF with clientID
                    Dim cmd1 As SqlCommand
                    Dim sql1 As New StringBuilder
                    sql1.Append("update tblPrivicaXRef set ")
                    sql1.AppendFormat("ClientID={0} ", ClientID)
                    sql1.AppendFormat("where leadid={0}", aID)
                    cmd1 = New SqlCommand(sql1.ToString, ConnectionFactory.Create())
                    cmd1.Connection.Open()
                    cmd1.ExecuteNonQuery()
                    cmd1.Connection.Close()
                Catch ex As Exception
                    'do nothing
                End Try

                'Saves tblleadhardship data to the client tblhardshipdata
                SaveHardshipData(ClientID)

            ElseIf report.FailedClients.Count = 1 Then
                Throw New Exception(report.FailedClients(0).ClientImportException.Message)
            Else
                Throw New Exception("Unknown error occured.")
            End If
        Catch ex As Exception
            UnLockClients(JobId)
            UpdateReportStatus(JobId, ProcessStatus.failed, ex.Message)
            If ex.Message <> "noship" Then
                divMsg.Style("display") = ""
                divMsg.InnerText = "Unable to set lead status to In Process. " & ex.Message
            End If
            bTransferred = False
        End Try

        Return bTransferred
    End Function

    Public Sub SaveHardshipData(ByVal clientID As Integer)
        Dim actionText As String = ""
        Dim cmdText As String = ""

        Using cmd As New SqlClient.SqlCommand
            cmd.CommandType = CommandType.Text
            cmd.Connection = New SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)

            'insert
            cmdText = "INSERT INTO tblHardshipData(ClientID, ClientAcctNum, HardshipDate, OwnRent, Hardship, ConcernsID, BehindID , NumChildren, NumGrandChildren, MonthlyIncome_Client_Work, MonthlyIncome_Client_SocialSecurity, MonthlyIncome_Client_Disability, MonthlyIncome_Client_RetirementPension, MonthlyIncome_Client_401K, MonthlyIncome_Client_Savings, MonthlyIncome_Client_Other, MonthlyIncome_Client_OtherDebts, MonthlyIncome_Client_SelfEmployed, MonthlyIncome_Client_Unemployed, MonthlyIncome_Client_JobDescription, MonthlyExpenses_Rent, MonthlyExpenses_EquityValueOfHome, MonthlyExpenses_Carpayment, MonthlyExpenses_CarInsurance, MonthlyExpenses_Utilities, MonthlyExpenses_Groceries, MonthlyExpenses_OweOnHome, MonthlyExpenses_DiningOut, MonthlyExpenses_Entertainment, MonthlyExpenses_MedicalInsurance, MonthlyExpenses_Gasoline, MonthlyExpenses_HomeInsurance, MonthlyExpenses_PhoneCell, MonthlyExpenses_Other, Created, CreatedBy, LastModified, LastModifiedBy) VALUES (@ClientID, @ClientAcctNum, getdate(), @OwnRent, @Hardship, @ConcernsID, @BehindID, @NumChildren, @NumGrandChildren, @MonthlyIncome_Client_Work, @MonthlyIncome_Client_SocialSecurity, @MonthlyIncome_Client_Disability, @MonthlyIncome_Client_RetirementPension, @MonthlyIncome_Client_401K, @MonthlyIncome_Client_Savings, @MonthlyIncome_Client_Other, @MonthlyIncome_Client_OtherDebts ,@MonthlyIncome_Client_SelfEmployed, @MonthlyIncome_Client_Unemployed, @MonthlyIncome_Client_JobDescription, @MonthlyExpenses_Rent, @MonthlyExpenses_EquityValueOfHome, @MonthlyExpenses_Carpayment, @MonthlyExpenses_CarInsurance, @MonthlyExpenses_Utilities, @MonthlyExpenses_Groceries, @MonthlyExpenses_OweOnHome, @MonthlyExpenses_DiningOut, @MonthlyExpenses_Entertainment, @MonthlyExpenses_MedicalInsurance, @MonthlyExpenses_Gasoline, @MonthlyExpenses_HomeInsurance, @MonthlyExpenses_PhoneCell, @MonthlyExpenses_Other, GETDATE(), @CreatedBy, GETDATE(), @LastModifiedBy)"
            cmd.CommandText = cmdText

            Dim sqlAcct As String = String.Format("select accountnumber from tblclient where clientid = {0}", clientID.ToString)
            Dim acctNum As String = SharedFunctions.AsyncDB.executeScalar(sqlAcct, ConfigurationManager.AppSettings("connectionstring").ToString)

            cmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", clientID))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@ClientAcctNum", acctNum))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@OwnRent", ddlOwnRent.SelectedItem.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Hardship", ddlHardship.SelectedItem.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@ConcernsID", ddlConcerns.SelectedItem.Value))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@BehindID", ddlBehind.SelectedItem.Value))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@NumChildren", txtKids.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@NumGrandChildren", txtGrandKids.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Work", txtWorkIncome.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_SocialSecurity", txtSSIncome.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Disability", txtDisability.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_RetirementPension", txtRetirePen.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_401K", txt401K.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Savings", txtSavChecking.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Other", txtOtherAssets.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_OtherDebts", txtOtherDebts.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_SelfEmployed", txtSelfEmployed.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Unemployed", txtUnemployment.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_JobDescription", txtOccupation.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Rent", txtHousePymt.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_EquityValueOfHome", txtHomeValue.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Carpayment", txtCarPymt.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_CarInsurance", txtCarIns.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Utilities", txtUtilities.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Groceries", txtGroceries.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_OweOnHome", txtHomePrinciple.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_DiningOut", txtDiningOut.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Entertainment", txtEntertainment.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_MedicalInsurance", txtHealthIns.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Gasoline", txtAutoFuel.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_HomeInsurance", txtHomeIns.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_PhoneCell", txtPhoneBill.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Other", txtOtherMthly.Text.ToString))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@CreatedBy", "24"))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@LastModifiedBy", "24"))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@created", Date.Now))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@LastModified", Date.Now))

            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()

            cmd.ExecuteNonQuery()

            cmd.Connection.Close()
        End Using
    End Sub


    Private Sub BindAppointments()
        lnkAddAppointment.Visible = (aID > 0)
        dsAppointments.SelectParameters("LeadApplicantID").DefaultValue = aID
        dsAppointments.DataBind()
        ShowGrid(dsAppointments, uwgAppointments)
    End Sub

    Private Sub BindBanks()
        lnkAddBanks.Visible = (aID > 0)
        chkVoidedCheck.Enabled = True
        dsBanks.SelectParameters("applicantID").DefaultValue = aID
        dsBanks.DataBind()
        ShowGrid(dsBanks, wGrdBanking)
        lnkAddBanks.Visible = (wGrdBanking.Rows.Count = 0 And aID > 0)
        wGrdBanking_DataBound(Nothing, System.EventArgs.Empty)
    End Sub

    Private Sub BindGrids()
        dsNotes.SelectParameters("applicantID").DefaultValue = aID
        dsNotes.DataBind()
        ShowGrid(dsNotes, wGrdNotes)

        BindBanks()

        dsCoApp.SelectParameters("applicantID").DefaultValue = aID
        dsCoApp.DataBind()
        ShowGrid(dsCoApp, wGrdCoApp)

        BindAppointments()

        If Not Page.IsPostBack Then
            dsCreditors.SelectParameters("applicantID").DefaultValue = aID
            wGrdCreditors.DataBind()
            ShowGrid(dsCreditors, wGrdCreditors)
        End If
    End Sub

    Private Sub BuildCIDDialerOutButtons()
        Dim dt As System.Data.DataTable = CallControlsHelper.GetCIDDialerResultTypes()
        Me.rptCIDDailerResults.DataSource = dt
        Me.rptCIDDailerResults.DataBind()
    End Sub

    Private Sub CalculateTime(ByVal local As Boolean)
        Dim LocalFromUtc As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", "FromUTC", "DBIsHere = 1"))
        Dim LeadfromUtc As Integer = LocalFromUtc

        If Me.ddlTimeZone.SelectedIndex > 0 Then
            LeadfromUtc = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", "FromUTC", "TimeZoneID = " & ddlTimeZone.SelectedValue))
        End If

        Try
            If local Then
                Me.FirstAppTime.Value = Nothing
                Me.FirstAppTime.Value = FirstAppLeadTime.Value.AddHours(LocalFromUtc - LeadfromUtc)
            Else
                Me.FirstAppLeadTime.Value = Nothing
                Me.FirstAppLeadTime.Value = FirstAppTime.Value.AddHours(LeadfromUtc - LocalFromUtc)
            End If
        Catch ex As Exception
            'Do Nothing
        End Try
    End Sub

    Private Function CanCalculate() As String
        Dim fields As String = ""

        'Calculator required fields
        If Trim(ConstructFullName(txtFName.Text, txtMName.Text, txtLName.Text)) = "" Then fields &= "Name \n"
        If txtPhone.Text.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "").Length < 10 Then fields &= "Phone \n"
        If txtSZip.Text.Trim.Length < 5 Then fields &= "Zip Code \n"
        If ddlBehind.SelectedIndex = 0 Then fields &= "Behind \n"
        If ddlHardship.SelectedIndex = 0 Then fields &= "Hardship \n"
        If Not Val(txtIncome.Text) > 0 Then fields &= "Monthly Income \n"
        'If Not Val(txtNumAccts.Text) > 0 Then fields &= "# of Accounts \n"
        'If Not Val(txtTotalDebt.Text) > 0 Then fields &= "Total Debt \n"
        'If ddlLeadSource.SelectedIndex = 0 Then fields &= "Source \n"
        'If ddlCompany.SelectedItem.value = 0 Then fields &= "Law Firm \n"
        If ddlAssignTo.SelectedIndex = 0 Then fields &= "Assign To \n"

        'btnCalculate.Visible = (fields.Length = 0)

        'Added by ccastelo 4/2/2014 - Must Add Creditors to Create LSA Document
        If Not HasCreditors() Then fields &= "Add Creditors \n"

        Return fields
    End Function

    Private Function HasCreditors() As Boolean
        Dim ssql As String = String.Format("select top 1 * from tblLeadCreditorInstance where LeadApplicantId = {0}", aID)
        Dim result As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        If result Is Nothing Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub CheckForLeadTransfered()
        'Get the lead id associated with the call
        Dim callId As String = hdnCallId.Value.Trim
        Dim LeadId As Nullable(Of Integer) = 0
        If callId.Length > 0 Then
            Dim sb As New System.Text.StringBuilder
            sb.AppendFormat("Select LeadApplicantId From tblLeadCall Where CallIdKey = '{0}'", callId)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                Dim objid As Object = cmd.ExecuteScalar()
                If Not objid Is Nothing AndAlso Not objid Is DBNull.Value Then Int32.TryParse(objid, LeadId)
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try

            If Not LeadId.HasValue OrElse LeadId.Value = 0 Then
                'Check for repeat callers
                Dim phone As String = hdnAni.Value.Trim
                If phone.Length > 0 Then
                    sb = New System.Text.StringBuilder
                    sb.AppendFormat("Select Top 1 LeadApplicantId From tblLeadApplicant Where Replace(Replace(Replace(Replace(leadphone,' ',''),'-',''),'(', ''),')','') = '{0}' or Replace(Replace(Replace(Replace(homephone,' ',''),'-',''),'(', ''),')','') = '{0}' or Replace(Replace(Replace(Replace(cellphone,' ',''),'-',''),'(', ''),')','') = '{0}' order by statusid desc", phone)
                    cmd = New SqlCommand(sb.ToString, ConnectionFactory.Create())
                    Try
                        cmd.Connection.Open()
                        Dim objid As Object = cmd.ExecuteScalar()
                        If Not objid Is Nothing AndAlso Not objid Is DBNull.Value Then Int32.TryParse(objid, LeadId)
                    Finally
                        If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
                    End Try
                End If
            End If

            If LeadId.HasValue AndAlso LeadId.Value > 0 Then
                Me.Response.Redirect(String.Format("{0}?id={1}&p1={2}&p2={3}&s={4}", GetDefaultPage(LeadId.Value), LeadId.Value, Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
            End If
        End If
    End Sub

    Private Sub ClearAllEntryData()
        '1.Setup
        Me.txtFName.Text = ""
        Me.txtMName.Text = ""
        Me.txtLName.Text = ""
        Me.txtPhone.Text = ""
        Me.txtZip.Text = ""
        Me.txtPaperLeadCode.Text = ""
        Me.FirstAppDate.Text = ""
        Me.FirstAppTime.Value = ""
        Me.FirstAppLeadTime.Value = ""

        'Dim li As New ListItem("New", 16)
        'li.Selected = True
        'ddlStatus.Items.Add(li)

        'Notes grid
        wGrdNotes.DataSource = Nothing

        '3. Primary
        txtFirstName.Text = ""
        txtMiddleName.Text = ""
        txtLastName.Text = ""
        txtAddress.Text = ""
        txtCity.Text = ""
        txtZip.Text = ""
        txtHomePhone.Text = ""
        txtBusPhone.Text = ""
        txtCellPhone.Text = ""
        txtFaxNo.Text = ""
        txtSSN.Text = ""
        txtDOB.Text = ""
        txtEmailAddress.Text = ""

        'Co-App grid
        Me.wGrdCoApp.DataSource = Nothing
    End Sub

    Private Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    reader.Read()
                    rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                End Using

                If Not System.IO.Directory.Exists(rootDir) Then
                    IO.Directory.CreateDirectory(rootDir)
                    cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder ORDER BY [Name] ASC"
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            IO.Directory.CreateDirectory(rootDir + DatabaseHelper.Peel_string(reader, "Name"))
                        End While
                    End Using
                End If
            End Using
        End Using

        Return rootDir
    End Function

    Private Sub DisconnectCurrentCall()
        'Force Disconnect Interaction
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "disconnectcurrent", "disconnectleadcall();", True)
    End Sub

    Private Sub DisconnectSpecificCall(ByVal CallMadeId As Integer)
        'Dim calloutboundkey As String = DialerHelper.GetCIDCallOutboundKey(CallMadeId)
        'If calloutboundkey.Trim.Length > 0 Then
        '    Try
        '        Dim interId As String = calloutboundkey.Trim.Substring(0, 10)
        '        Dim s As ININ.IceLib.Connection.Session = Session("iceSession")
        '        Dim man As ININ.IceLib.Interactions.InteractionsManager = ININ.IceLib.Interactions.InteractionsManager.GetInstance(s)
        '        Dim inter As ININ.IceLib.Interactions.Interaction = man.CreateInteraction(New ININ.IceLib.Interactions.InteractionId(interId))
        '        'Force Disconnect
        '        inter.Disconnect()
        '    Catch ex As Exception
        '        'Ignore
        '    End Try
        'End If
    End Sub

    Private Sub FirstAppLeadTime_ValueChanged(ByVal sender As Object, ByVal args As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles FirstAppLeadTime.ValueChange
        CalculateTime(True)
    End Sub

    Private Sub FirstAppTime_ValueChanged(ByVal sender As Object, ByVal args As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles FirstAppTime.ValueChange
        CalculateTime(False)
    End Sub

    Private Function FormatDate(ByVal v As Date) As String
        Dim NewDate As Date = v
        If DatePart(DateInterval.Year, NewDate).ToString = "1900" Then
            v = ""
        End If
        Return v
    End Function

    Private Function FormatPhone(ByVal p As String) As String
        Dim NewPhone As String = p
        If Val(Mid(p, 2, 3)) = 0 Then
            NewPhone = NewPhone.Replace("(", "")
            NewPhone = NewPhone.Replace(")", "")
            NewPhone = NewPhone.Replace("-", "")
            NewPhone = ""
        End If
        Return NewPhone
    End Function

    Private Function GetDefaultPage(ByVal LeadId As String) As String
        Dim defaultpage As String = DataHelper.FieldLookup("tblLeadApplicant", "EnrollmentPage", "LeadApplicantId=" & LeadId)

        If Not defaultpage Is Nothing AndAlso defaultpage.Trim.Length > 0 Then
            Return defaultpage
        Else
            Return "prompt.aspx"
        End If
    End Function

    Private Function GetProductCost(ByVal ProductId As String) As String
        Dim Cost As String = String.Empty

        If ddlLeadSource.SelectedItem.Value = "4" Then 'Referral
            Cost = "0"
        ElseIf ProductId.Length > 0 Then
            Cost = DataHelper.FieldLookup("tblLeadProducts", "Cost", "ProductId=" & ProductId)
        End If

        If Cost Is Nothing OrElse Cost.Trim.Length = 0 Then
            Cost = "NULL"
        End If

        Return Cost
    End Function

    Private Sub GetProductIdFromDNIS()
        'For calls that create new leads, get and assign a LeadSource if possible.
        If hdnCallId.Value.Length > 0 Then
            Dim dt As DataTable = CallControlsHelper.GetLeadProductFromDNIS(hdnCallId.Value)
            If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
                hdnProductId.Value = dt.Rows(0)("ProductId").ToString.Trim
                Me.ddlLeadSource.Items.FindByValue(dt.Rows(0)("DefaultSourceID")).Selected = True
                Me.ddlLeadSource.Enabled = False
            Else
                'PrductId not found redirect to default page
                Response.Redirect("Default.aspx")
            End If
        End If
    End Sub

    Private Function GetUserExt() As String
        Dim ext As String = "000"
        Dim tbl As DataTable
        Dim params(0) As SqlParameter

        params(0) = New SqlParameter("userid", UserID)
        tbl = SqlHelper.GetDataTable("stp_SmartDebtor_GetAgentInfoFromUserID", CommandType.StoredProcedure, params)
        If tbl.Rows.Count = 1 Then
            ext = tbl.Rows(0)(0) 'ParaLegalExt
        End If

        Return ext
    End Function

    Private Sub InsertCallInfo(ByVal LeadId As Integer)
        Dim callId As String = hdnCallId.Value.Trim
        If callId.Length > 0 Then
            Dim sb As New System.Text.StringBuilder
            sb.AppendFormat("if Not Exists(Select CallIdKey From tblLeadCall Where CallIdKey = '{0}')", callId)
            sb.Append(" Insert Into tblLeadCall(LeadApplicantId, CallIdKey, Dnis, Ani, Created, CreatedBy, LastModified, LastModifiedBy) ")
            sb.AppendFormat(" values ({0}, '{1}', '{2}', '{3}', Getdate(), {4}, Getdate(), {4})", IIf(LeadId = 0, "null", LeadId), callId, hdnDnis.Value.Trim, hdnAni.Value.Trim, UserID)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                'Reset Vars
                'hdnCallId.Value = ""
                'hdnDnis.Value = ""
                'hdnAni.Value = ""
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try
        End If
    End Sub

    Private Sub LoadAppointmentCall()
        Dim dt As DataTable = CIDAppointmentHelper.GetLeadAppointment(CInt(hdnCallAppointmentId.Value))
        If dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            Me.lblleadPhoneNumberAppointment.Text = LocalHelper.FormatPhone(dr("PhoneNumber"))
            Me.lblleadDTAppointmentLocal.Text = String.Format("{0} {1}", CDate(dr("AppointmentDate")).ToShortDateString, CDate(dr("AppointmentDate")).ToShortTimeString)
            Me.lblleadAppointmentby.Text = dr("createdbyuser")
            Dim utc = CIDAppointmentHelper.GetUTC(dr("TimeZoneId"))
            Dim myUtc As Integer = -8
            Dim LeadDate As DateTime = CDate(dr("AppointmentDate")).AddHours(utc - myUtc)
            Me.lblleadDTAppointment.Text = String.Format("{0} {1}", LeadDate.ToShortDateString, LeadDate.ToShortTimeString)
            If Not dr("AppointmentNote") Is DBNull.Value Then Me.lblLeadNoteAppointment.Text = dr("AppointmentNote")
        End If
    End Sub

    Private Sub LoadCallVars()
        If Not Request.QueryString("dnis") Is Nothing Then hdnDnis.Value = Request.QueryString("dnis")
        If Not Request.QueryString("ani") Is Nothing Then hdnAni.Value = Request.QueryString("ani")
        If Not Request.QueryString("callidkey") Is Nothing Then hdnCallId.Value = Request.QueryString("callidkey")
        CheckForLeadTransfered()
    End Sub

    Private Sub LoadData()
        bindDDL(ddlBehind, "SELECT BehindID, description FROM tblLeadBehind", "description", "BehindID")
        bindDDL(ddlConcerns, "select concernsid, [description]  from tblLeadConcerns", "description", "concernsid")
        bindDDL(ddlDelivery, "select deliveryid, description from tblLeadDelivery", "description", "deliveryid")
        'bindDDL(ddlStatus, "select statusid, description from tblLeadStatus where Show = 1 order by description", "description", "statusid")
        bindDDL(ddlLanguage, "select LanguageID, [name] from tblLanguage", "name", "LanguageID")
        bindDDL(ddlTimeZone, "SELECT TimeZoneID, Name FROM tblTimeZone Order By Name Asc", "Name", "TimeZoneId")
        bindDDL(cboStateID, "select stateid, abbreviation from tblstate", "abbreviation", "stateid")
        bindDDL(ddlLeadSource, "Select LeadSourceID, Name from tblleadsources where Show = 1", "Name", "LeadSourceID")
        'bindDDL(ddlCompany, "select distinct c.CompanyID, c.Name from tblcompany c join tblState s on s.CompanyID = c.CompanyID", "name", "Companyid", False)
        LoadVendors()
        LoadStatuses()
        If aID > 0 Then
            Dim obj As Object = SqlHelper.ExecuteScalar(String.Format("select StatusId from tblLeadApplicant where leadapplicantid = {0}", aID), CommandType.Text)
            Dim statusId As Integer = 0
            If Not obj Is Nothing Then
                statusId = CInt(obj)
            End If

            'Dim dt As DataTable = SqlHelper.GetDataTable(String.Format("select p.ProductDesc, p.ProductID, p.VendorId from tblLeadProducts p join tblLeadApplicant l on l.ProductId = p.productId where LeadApplicantID = {0}", aID), CommandType.Text)
            'If Not dt Is Nothing Then
            '    Dim dr As DataRow = dt.Rows(0)
            '    bindDDL(ddlProduct, String.Format("select ProductDesc, ProductID from tblLeadProducts where ProductId = {0}", dr("ProductId").ToString), "ProductDesc", "ProductId", False)
            '    bindDDL(ddlVendor, String.Format("select VendorCode, VendorID from tblLeadVendors where VendorId = {0}", dr("VendorId").ToString), "VendorCode", "VendorID", False)
            'End If

            If statusId = 10 Or statusId = 3 Or statusId = 21 Then
                bindDDL(ddlCompany, String.Format("select distinct c.CompanyID, c.Name  from tblCompany c join tblLeadApplicant la on la.CompanyId = c.CompanyId where la.LeadApplicantId = {0}", aID), "name", "Companyid", False)
            Else
                bindDDL(ddlCompany, String.Format("select distinct x.companyid, c.Name from tblStatesAgencyXRef x join tblState s on s.StateID = x.StateId join tblCompany c on c.CompanyId = x.CompanyId where x.AgencyId = {0} and c.Active = 1", AgencyID), "name", "Companyid", False)
            End If
        Else
            bindDDL(ddlCompany, String.Format("select distinct x.companyid, c.Name from tblStatesAgencyXRef x join tblState s on s.StateID = x.StateId join tblCompany c on c.CompanyId = x.CompanyId where x.AgencyId = {0}  and c.Active = 1", AgencyID), "name", "Companyid", False)
        End If
        'bindCBL(cblHardshipIncome, "SELECT [IncomeTypeID],[IncomeTypeDescription] FROM [tblClientIncomeTypes]", "IncomeTypeDescription", "IncomeTypeID")

        'If PermissionHelperLite.HasPermission(UserID, "Client Intake-Assign to any rep") Then
        '    'Can assign to any CID user
        '    bindDDL(ddlAssignTo, "Select UserID, FirstName + ' ' + LastName[Name] from tbluser Where UserGroupId IN (1,25) and locked = 0 Order by [Name]", "Name", "UserID")
        'Else
        '    'Can only assign to a closer
        '    bindDDL(ddlAssignTo, "Select UserID, FirstName + ' ' + LastName[Name] from tbluser Where UserGroupId IN (25) and locked = 0 Order by [Name]", "Name", "UserID")
        'End If

        If AgencyID > 0 Then
            If IsManager OrElse PermissionHelperLite.HasPermission(UserID, "Client Intake-Assign to any rep") Then
                bindDDL(ddlAssignTo, String.Format("Select u.UserID, FirstName + ' ' + LastName[Name] from tblUser u join tblAgency a on a.agencyid = u.agencyid Where UserGroupId IN (26) and a.AgencyID = {0} and locked = 0 and temporary = 0 Order by [Name]", AgencyID), "Name", "UserID")
            Else
                'Only display himself
                bindDDL(ddlAssignTo, String.Format("Select UserID, FirstName + ' ' + LastName[Name] from tblUser Where UserGroupId IN (26) and AgencyID is not null and UserId = {0} and locked = 0 and temporary = 0 Order by [Name]", UserID), "Name", "UserID")
            End If
        Else
            bindDDL(ddlAssignTo, "Select UserID, FirstName + ' ' + LastName[Name] from tblUser Where UserGroupId IN (1,3,4,6,11,25,27) and locked = 0 and temporary = 0 Order by [Name]", "Name", "UserID")
        End If

        For x As Integer = 1 To 30
            ddlDepositDay.Items.Add(x.ToString)
        Next

    End Sub

    Private Sub LoadVendors()
        ddlVendor.Items.Clear()
        If AgencyID > 0 Then
            bindDDL(ddlVendor, String.Format("select VendorID, VendorCode from tblLeadVendors where active = 1 and AgencyID = {0} order by VendorCode", AgencyID), "VendorCode", "VendorID", False)
            ddlVendor_SelectedIndexChanged(Nothing, Nothing)
        ElseIf (AgencyID = -1 AndAlso IsManager = 0) Then
            bindDDL(ddlVendor, "select VendorID, VendorCode from tblLeadVendors where active = 1 and VendorId in (211, 222) order by VendorCode", "VendorCode", "VendorID", False)
            ddlVendor_SelectedIndexChanged(Nothing, Nothing)
        Else
            bindDDL(ddlVendor, "select VendorID, VendorCode from tblLeadVendors where active = 1 order by VendorCode", "VendorCode", "VendorID")
            ddlProduct.Items.Add(New ListItem("Please select a vendor", -1))
        End If
    End Sub

    Private Sub LoadStatuses()
        ddlStatus.Items.Clear()
        Dim statusId As Integer = 0

        Using dt As DataTable = SqlHelper.GetDataTable("select ls.statusid [statusid], ls.[description], lsg.GroupName, lsg.[order] from tblLeadStatus ls join tblleadstatusgroup lsg on lsg.StatusGroupId = ls.StatusGroupId where Show = 1 order by lsg.[Order]")
            For Each dr As DataRow In dt.Rows
                Dim item1 As ListItem = New ListItem(dr("Description").ToString(), dr("Statusid").ToString())
                item1.Attributes.Add("OptionGroup", dr("GroupName").ToString())

                ddlStatus.Items.Add(item1)
            Next
        End Using

    End Sub

    Private Sub PrintInfoSheet()
        If Not aID = 0 Then
            Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
            rDoc = rpt.ViewApplicantInformationSheet_Mossler_20150427(aID)
            Dim memStream As New System.IO.MemoryStream()
            Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
            pdf.ConvertMetaToPng = True

            pdf.Export(rDoc, memStream)

            memStream.Seek(0, IO.SeekOrigin.Begin)

            Session("infosheet") = memStream.ToArray

            Dim _sb As New System.Text.StringBuilder()
            _sb.Append("window.open('viewLSA.aspx?type=info','',")
            _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

            divMsg.Style("display") = "none"
            divMsg.InnerText = ""
        End If
    End Sub

    Private Function RequiredLSAFieldsValid(Optional ByVal eLSA As Boolean = False) As Boolean
        Dim fields As String = CanCalculate()

        'LSA required fields
        If ddlPrefix.SelectedIndex = 0 Then fields &= "Prefix \n"
        If txtFirstName.Text.Trim = "" Then fields &= "First Name \n"
        If txtLastName.Text.Trim = "" Then fields &= "Last Name \n"
        If txtAddress.Text.Trim = "" Then fields &= "Address \n"
        If cboStateID.SelectedIndex = 0 Then fields &= "State \n"
        If txtZip.Text.Trim.Length < 5 Then fields &= "Zip \n"
        If txtSSN.Text.Replace("-", "").Replace(" ", "").Trim.Length <> 9 Then fields &= "SSN \n"
        If txtDOB.Text.Trim = "" Then fields &= "DOB \n"
        If ddlLanguage.SelectedIndex = 0 Then fields &= "Language \n"
        If Not IsDate(txtFirstDepositDate.Text) Then fields &= "First Deposit \n"
        'If wGrdBanking.Rows.Count = 0 Then fields &= "Banking Information \n"
        'If wGrdCreditors.Rows.Count = 0 Then fields &= "Creditors \n"
        Dim bGotIncomeType As Boolean = False
        'For Each incomeType As ListItem In cblHardshipIncome.Items
        '    If incomeType.Selected Then
        '        bGotIncomeType = True
        '        Exit For
        '    End If
        'Next
        'If bGotIncomeType = False Then fields &= "Income Type \n"

        If eLSA Then
            Dim tblBorrowers As DataTable = CredStarHelper.GetBorrowers(aID)

            If Len(txtEmailAddress.Text.Trim) < 5 Then
                fields &= "Email Address \n"
            End If

            For i As Integer = 1 To tblBorrowers.Rows.Count - 1
                If Len(CStr(tblBorrowers.Rows(i)("email"))) < 5 Then
                    fields &= CStr(tblBorrowers.Rows(i)("firstname")) & "'s Email Address \n"
                End If
            Next
        End If

        If Len(fields) > 0 Then
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "LSAFields", "alert(""The following fields are required to generate an LSA:\n\n" & fields & """);", True)
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub ReturnToAttorney()
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("clientid", CInt(hdnClientID.Value)))
        params.Add(New SqlParameter("depositamount", CalculatorModelControl1.DepositCommittment))
        params.Add(New SqlParameter("userid", UserID))
        SqlHelper.ExecuteNonQuery("stp_ReturnToAttorney", , params.ToArray)

        If Trim(txtQuickNote.Text) <> "" Then
            Drg.Util.DataHelpers.NoteHelper.InsertNote(txtQuickNote.Text.Trim, UserID, CInt(hdnClientID.Value))
        End If
    End Sub

    Private Sub Save(ByVal a As Boolean, ByVal aID As Integer, Optional ByVal bClose As Boolean = False)
        Dim cmd As SqlCommand
        Dim strSQL As String
        Dim Assigned As Boolean = False
        Dim IsProcessedBy As Integer
        Dim birthdate As String = txtDOB.Text
        Dim CurrentAssignment As String

        If aID > 0 Then
            IsProcessedBy = CInt(Val(DataHelper.FieldLookup("tblLeadApplicant", "Processor", "LeadApplicantID = " & aID)))
        Else
            IsProcessedBy = 0
        End If

        Dim dFirstAppointment As String = "Null"
        Dim tFirstAppTime As String = "12:00 AM"
        Dim TimeZone As String = "Null"
        Dim ReasonID As String = "Null"
        Dim ReasonOther As String = ""

        If Me.FirstAppTime.Text.Trim.Length > 0 Then
            tFirstAppTime = Me.FirstAppTime.Text.Trim
        End If
        If Me.FirstAppDate.Text.Trim.Length > 0 Then
            dFirstAppointment = String.Format("'{0} {1}'", Me.FirstAppDate.Text.Trim, tFirstAppTime)
        End If
        If Me.ddlTimeZone.Text.Trim.Length > 0 Then
            TimeZone = ddlTimeZone.SelectedValue
        End If

        If IsDate(birthdate) Then
            If CDate(birthdate) < CDate("1/1/1900") Then
                birthdate = "1/1/1900"
            End If
        End If

        If trReasons.Visible Then
            ReasonID = ddlReasons.SelectedItem.Value
            If ddlReasons.SelectedItem.Text = "Other" Then
                ReasonOther = txtReasonOther.Text.Trim
            End If
        End If

        'Changed by Chuck 2/4/2014
        'If ddlProduct.Items.Count > 0 AndAlso ddlProduct.SelectedItem.Value > 0 Then
        If ddlProduct.SelectedItem.Value > 0 Then
            hdnProductId.Value = ddlProduct.SelectedItem.Value
        ElseIf a AndAlso hdnProductId.Value.Trim.Length = 0 Then
            divMsg.Style("display") = ""
            divMsg.InnerText = "Product Code is required to save a new applicant."
            Exit Sub
        End If

        If ddlLeadSource.SelectedItem.Value <= 0 Then
            divMsg.Style("display") = ""
            divMsg.InnerText = "Lead Source Code is required to save a new applicant."
            Exit Sub
        End If

        If ddlStatus.SelectedItem.Value = 0 Then
            divMsg.Style("display") = ""
            divMsg.InnerText = "A Lead Status is required to save a new applicant."
            Exit Sub
        End If

        CurrentStatus = CStr(Val(DataHelper.FieldTop1("tblLeadRoadmap", "LeadStatusID", "LeadApplicantID = " & aID, "Created DESC")))

        Try
            If Loading = False Then
                'Save the appliant demographic data
                If a Then
                    Assigned = True
                    strSQL = "INSERT INTO tblLeadApplicant (Prefix,FirstName, MiddleName, LastName, FullName, Address1, City, StateID, ZipCode, HomePhone, BusinessPhone, CellPhone, FaxNumber, Email, SSN, DOB, ConcernsID, BehindID, LeadSourceID, CompanyID, LanguageID, DeliveryID, RepID, StatusID, ReasonID, ReasonOther, PaperLeadCode, Created, CreatedByID, LastModified, LastModifiedByID, LeadName, LeadPhone, LeadZip, FirstAppointmentDate, TimeZoneId, ProductId, Cost, CallIdKey, ProcessingPattern, LSAVersion) " _
                    & "VALUES ('" _
                    & ddlPrefix.SelectedItem.Text & "', '" _
                    & StrConv(txtFirstName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', '" _
                    & StrConv(txtMiddleName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', '" _
                    & StrConv(txtLastName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', '" _
                    & ConstructFullName(txtFirstName.Text.Replace("'", "''"), txtMiddleName.Text.Replace("'", "''"), txtLastName.Text.Replace("'", "''")) & "', '" _
                    & Me.txtAddress.Text.Replace("'", "''") & "', '" _
                    & StrConv(txtCity.Text, VbStrConv.ProperCase).Replace("'", "''") & "', " _
                    & Me.cboStateID.SelectedItem.Value & ", '" _
                    & Me.txtZip.Text.ToString & "', '" _
                    & FormatPhone(Me.txtHomePhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtBusPhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtCellPhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtFaxNo.Text.ToString) & "', '" _
                    & Me.txtEmailAddress.Text.ToString & "', '" _
                    & Me.txtSSN.Text.ToString & "', '" _
                    & birthdate & "', " _
                    & Me.ddlConcerns.SelectedValue & ", " _
                    & Me.ddlBehind.SelectedValue & ", " _
                    & Me.ddlLeadSource.SelectedValue & ", " _
                    & Me.ddlCompany.SelectedValue & ", " _
                    & Me.ddlLanguage.SelectedValue & ", " _
                    & Me.ddlDelivery.SelectedValue & ", " _
                    & Me.ddlAssignTo.SelectedValue & ", " _
                    & Me.ddlStatus.SelectedValue & ", " _
                    & ReasonID & ", '" _
                    & ReasonOther & "', '" _
                    & txtPaperLeadCode.Text.Trim & "', '" _
                    & Now & "', " _
                    & UserID & ", '" _
                    & Now & "', " _
                    & UserID & ", '" _
                    & ConstructFullName(txtFName.Text.Replace("'", "''"), txtMName.Text.Replace("'", "''"), txtLName.Text.Replace("'", "''")) & "', '" _
                    & txtPhone.Text & "', '" _
                    & txtSZip.Text & "', " _
                    & dFirstAppointment & ", " _
                    & TimeZone & ", " _
                    & IIf(hdnProductId.Value.Trim.Length = 0, "NULL", hdnProductId.Value.Trim) & ", " _
                    & GetProductCost(hdnProductId.Value) & ", " _
                    & IIf(hdnCallId.Value.Trim.Length = 0, "NULL", String.Format("'{0}'", hdnCallId.Value.Trim)) & ", '" _
                    & IIf(hdnProcessingPattern.Value.Trim.Length = 0, GetDefaultProcessingPattern(), hdnProcessingPattern.Value.Trim) & "', '" _
                    & GetLSAVersion(Me.ddlCompany.SelectedValue) & "') " _
                    & "SELECT SCOPE_IDENTITY()" 'jhope 4/17 down V

                    cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                    cmd.Connection.Open()
                    aID = cmd.ExecuteScalar()
                    Me.aID = aID
                    cmd.Connection.Close()

                    '7.22.09.ug.insert roadmap for each status change, initial applicant status
                    LeadRoadmapHelper.InsertRoadmap(aID, CInt(Me.ddlStatus.SelectedValue), 0, "Applicant Created.", UserID)

                    'Update tblLeadAudit for a beginning history jhope 9/28/2009
                    CurrentAssignment = DataHelper.FieldTop1("tblLeadAudit", "NewValue", "LeadApplicantID = " & aID & " AND ModificationType = 'Assign new Rep'", "ModificationDate DESC")
                    If CurrentAssignment = "" Then
                        CurrentAssignment = "0"
                    End If
                    If ddlAssignTo.SelectedValue <> CurrentAssignment Then
                        Dim OldAssignments(0) As LeadHelper.OldAssignments
                        OldAssignments(0).LeadApplicantID = aID
                        OldAssignments(0).OldValue = CurrentAssignment
                        OldAssignments(0).NewValue = ddlAssignTo.SelectedValue
                        OldAssignments(0).TableName = "tblLeadAppliant"
                        OldAssignments(0).FieldName = "RepID"
                        LeadHelper.LogAssignments(OldAssignments, UserID, CInt(Me.ddlAssignTo.SelectedValue))
                    End If

                End If 'jhope 4/17

                If Not a Then 'jhope 4/17
                    strSQL = "UPDATE tblLeadApplicant SET "
                    strSQL += "Prefix = '" & ddlPrefix.SelectedItem.Text & "', "
                    strSQL += "FirstName = '" & StrConv(txtFirstName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', "
                    strSQL += "MiddleName = '" & StrConv(txtMiddleName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', "
                    strSQL += "LastName = '" & StrConv(txtLastName.Text, VbStrConv.ProperCase).Replace("'", "''") & "', "
                    strSQL += "FullName = '" & ConstructFullName(txtFirstName.Text.Replace("'", "''"), txtMiddleName.Text.Replace("'", "''"), txtLastName.Text.Replace("'", "''")) & "', "
                    strSQL += "Address1 = '" & txtAddress.Text.Replace("'", "''") & "', "
                    strSQL += "City = '" & StrConv(txtCity.Text, VbStrConv.ProperCase).Replace("'", "''") & "', "
                    strSQL += "StateID = " & cboStateID.SelectedItem.Value & ", "
                    strSQL += "ZipCode = '" & txtZip.Text & "', "
                    strSQL += "HomePhone = '" & FormatPhone(txtHomePhone.Text) & "', "
                    strSQL += "BusinessPhone = '" & FormatPhone(txtBusPhone.Text) & "', "
                    strSQL += "CellPhone = '" & FormatPhone(txtCellPhone.Text) & "', "
                    strSQL += "FaxNumber = '" & FormatPhone(txtFaxNo.Text) & "', "
                    strSQL += "Email = '" & Me.txtEmailAddress.Text & "', "
                    strSQL += "SSN = '" & Me.txtSSN.Text & "', "
                    strSQL += "DOB = '" & birthdate & "', "
                    strSQL += "ConcernsID = " & Me.ddlConcerns.SelectedValue & ", "
                    strSQL += "BehindID = " & Me.ddlBehind.SelectedValue & ", "
                    strSQL += "LeadSourceID = " & Me.ddlLeadSource.SelectedValue & ", "
                    strSQL += "CompanyID = " & Me.ddlCompany.SelectedValue & ", "
                    strSQL += "LanguageID = " & Me.ddlLanguage.SelectedValue & ", "
                    strSQL += "DeliveryID = " & Me.ddlDelivery.SelectedValue & ", "
                    If ddlAssignTo.SelectedIndex > 0 Then
                        strSQL += "RepID = " & CInt(Val(Me.ddlAssignTo.SelectedValue)) & ", "
                        Assigned = True
                    End If
                    Select Case ddlStatus.SelectedValue
                        Case "10", "19" 'In Process, Return to Compliance
                            'Dont update the status just yet. Only after the transfer goes through.
                        Case Else
                            'Hotfix 8/2/10 - Only allow status change if the current status is not In Process
                            If CurrentStatus <> 10 Then
                                strSQL += "StatusID = " & CInt(Me.ddlStatus.SelectedValue) & ", "
                            End If
                    End Select
                    strSQL += "ReasonID = " & ReasonID & ", "
                    strSQL += "ReasonOther = '" & ReasonOther & "', "
                    strSQL += "PaperLeadCode = '" & txtPaperLeadCode.Text.Trim & "', "
                    strSQL += "LastModified = '" & Now & "', "
                    strSQL += "LastModifiedByID = " & UserID & ", "
                    strSQL += "LeadName = '" & ConstructFullName(txtFirstName.Text.Replace("'", "''"), txtMiddleName.Text.Replace("'", "''"), txtLastName.Text.Replace("'", "''")) & "', "
                    strSQL += "LeadPhone = '" & txtPhone.Text & "', "
                    strSQL += "LeadZip = '" & txtSZip.Text & "', "
                    strSQL += "FirstAppointmentDate = " & dFirstAppointment & ", "
                    strSQL += "TimeZoneId = " & TimeZone & " "
                    If IsNumeric(hdnProductId.Value) Then
                        strSQL += ", ProductID = " & hdnProductId.Value
                        strSQL += ", Cost = " & GetProductCost(hdnProductId.Value) & " "
                        strSQL += ", LSAVersion = '" & GetLSAVersion(ddlCompany.SelectedItem.Value) & "' "
                        strSQL += ", ProcessingPattern = '" & IIf(hdnProcessingPattern.Value.Trim.Length = 0, GetDefaultProcessingPattern(), hdnProcessingPattern.Value.Trim) & "' "
                    End If
                    strSQL += "WHERE LeadApplicantID = " & aID

                    cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery() 'jhope 04/17
                    cmd.Connection.Close()

                    Select Case ddlStatus.SelectedValue
                        Case "10", "19" 'In Process, Return to Compliance
                            'Dont update the status just yet. Only after the transfer goes through.
                        Case Else
                            '7.22.09.ug.insert roadmap for each status change, applicant status change
                            Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(aID)
                            '9/28/2009 jhope made it conditional so it will only write if the status is 0 or it has changed.
                            If Me.ddlStatus.SelectedValue <> CurrentStatus.ToString() And CurrentStatus <> 10 Then
                                If CInt(Me.ddlStatus.SelectedValue) <> parentID Then
                                    LeadRoadmapHelper.InsertRoadmap(aID, CInt(Me.ddlStatus.SelectedValue), parentID, "Applicant Status Changed.", UserID)
                                    'If current status is Returned and new status is No Sale, cancel the client
                                    If CurrentStatus = 18 AndAlso ddlStatus.SelectedItem.Value = "12" Then
                                        RoadmapHelper.InsertRoadmap(CInt(hdnClientID.Value), 17, Nothing, UserID) 'Cancelled
                                        bClose = True
                                    End If
                                End If


                            End If
                    End Select

                    'Update tblLeadAudit for a history of rep assignments jhope 9/28/2009
                    CurrentAssignment = DataHelper.FieldTop1("tblLeadAudit", "NewValue", "LeadApplicantID = " & aID & " AND ModificationType = 'Assign new Rep'", "ModificationDate DESC")
                    If CurrentAssignment.ToString = "" Then
                        CurrentAssignment = "0"
                    End If
                    If Me.ddlAssignTo.SelectedValue <> CurrentAssignment And Assigned Then
                        Dim OldAssignments(0) As LeadHelper.OldAssignments
                        OldAssignments(0).LeadApplicantID = aID
                        OldAssignments(0).OldValue = CurrentAssignment
                        OldAssignments(0).NewValue = ddlAssignTo.SelectedValue
                        OldAssignments(0).TableName = "tblLeadAppliant"
                        OldAssignments(0).FieldName = "RepID"
                        LeadHelper.LogAssignments(OldAssignments, UserID, CInt(Me.ddlAssignTo.SelectedValue))
                        OldAssignments = Nothing
                    End If

                    'Update Closer if re-assigned
                    If Not IsNothing(ddlCloser.SelectedItem) Then
                        If ddlCloser.SelectedItem.Value <> ddlCloser.Attributes("CloserID") Then
                            SqlHelper.ExecuteNonQuery(String.Format("update tblleadaudit set newvalue = {0}, modificationdate = getdate(), userid = {1} where leadauditid = {2}", ddlCloser.SelectedItem.Value, UserID, ddlCloser.Attributes("LeadAuditID")), CommandType.Text)
                        End If
                    End If
                End If

                UpdateCallInfo(aID)

                If Trim(txtQuickNote.Text) <> "" Then
                    SmartDebtorHelper.InsertLeadNote(txtQuickNote.Text, aID, UserID)
                End If

                SaveHardshipInfo(aID)
            End If
        Catch ex As Exception
            Throw New Exception(strSQL, ex)
        End Try

        SaveLeadCalculator()
        SaveCreditorAccountInfo()

        If wgbVerification.Visible AndAlso txtVerConfNum.Text.Trim.Length > 0 Then
            ThreePVHelper.SaveConfNum(aID, tdPVN.InnerText, txtVerConfNum.Text)
        End If

        'Dim client As New IdentSvc.IdentifyleSoapClient
        'Dim EnableIdenityfleWebService As Boolean = False
        Dim SourceLead As String = DataHelper.FieldTop1("tblLeadApplicant", "SourceLeadID", "LeadApplicantID = " & aID)
        Dim SourceContract As String = DataHelper.FieldTop1("tblLeadApplicant", "SourceContractID", "LeadApplicantID = " & aID)

        Dim SourceLeadID As Integer = 0
        Dim SourceContractID As Integer = 0

        If (SourceLead <> "" AndAlso SourceContract <> "") Then
            'EnableIdenityfleWebService = True
            SourceLeadID = CInt(SourceLead)
            SourceContractID = CInt(SourceContract)
        End If

        'Take action on In Process status change
        If CurrentStatus <> CInt(ddlStatus.SelectedItem.Value) AndAlso CInt(ddlStatus.SelectedItem.Value) = 10 Then 'In Process
            'Transfer lead to client
            If BeginTheTransfer() Then
                'If EnableIdenityfleWebService Then
                '    client.LockSubmittedOffer(SourceContractID, SourceLeadID)
                'End If
                bClose = True
            Else
                Exit Sub 'cancel redirect
            End If
        ElseIf CurrentStatus <> CInt(ddlStatus.SelectedItem.Value) AndAlso CInt(ddlStatus.SelectedItem.Value) = 19 Then 'Return to Compliance
            'Update lead and client status so it gets kicked back to Compliance
            If UpdateTheTransfer() Then
                'If EnableIdenityfleWebService Then
                '    client.LockSubmittedOffer(SourceContractID, SourceLeadID)
                'End If
                bClose = True
            Else
                Exit Sub 'cancel redirect
            End If
        ElseIf CurrentStatus <> CInt(ddlStatus.SelectedItem.Value) AndAlso ddlStatus.SelectedItem.Value = "22" Then 'Return to Attorney
            ReturnToAttorney()
            'If EnableIdenityfleWebService Then
            '    client.LockSubmittedOffer(SourceContractID, SourceLeadID)
            'End If
        ElseIf CurrentStatus <> CInt(ddlStatus.SelectedItem.Value) AndAlso CInt(ddlStatus.SelectedItem.Value) = 17 Then 'Recycled
            'DialerHelper.UpdateLeadApplicant(aID, Nothing, Now)
            'client.UnlockSubmittedOffer(SourceContractID, SourceLeadID)
        ElseIf CurrentStatus <> CInt(ddlStatus.SelectedItem.Value) Then
            'If EnableIdenityfleWebService Then
            '    Select Case CInt(ddlStatus.SelectedItem.Value)
            '        Case 2 'Awaiting Info
            '            client.LockSubmittedOffer(SourceContractID, SourceLeadID)
            '        Case 23 'Return to Identifyle
            '            client.ReturnSubmittedOffer(SourceContractID, SourceLeadID)
            '        Case Else
            '            client.UnlockSubmittedOffer(SourceContractID, SourceLeadID)
            '    End Select
            'End If
        End If

        Dim urlredirect As String

        If bClose Then
            urlredirect = String.Format("Default.aspx?p1={0}&p2={1}&s={2}", Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s")))
        Else
            If hdnRedirectTo.Value.Trim.Length > 0 Then
                urlredirect = hdnRedirectTo.Value.Trim
                hdnRedirectTo.Value = ""
            ElseIf hdnCallIdKey.Value = "" Then
                If cboStateID.SelectedValue.ToLower <> "ca" Then
                    urlredirect = String.Format("newenrollment3.aspx?id={0}&a=saved&p1={1}&p2={2}&s={3}", aID, Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s")))
                Else
                    urlredirect = String.Format("newenrollment2.aspx?id={0}&a=saved&p1={1}&p2={2}&s={3}", aID, Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s")))
                End If
                If Not FromWhere Is Nothing AndAlso FromWhere.Trim.Length > 0 Then urlredirect = String.Format("{0}&pg={1}&fxid={2}", urlredirect, FromWhere, ExportDtl)
            Else
                urlredirect = String.Format("newenrollment2.aspx?callidkey={0}&ani={1}", hdnCallIdKey.Value, hdnAni.Value)
            End If
        End If

        Response.Redirect(urlredirect, EndPageRedirect)
    End Sub

    Private Sub SaveCreditorAccountInfo()
        Dim intLeadCreditorInstance As Integer
        Dim txtAccountNo As TextBox
        Dim txtBalance As TextBox
        Dim txtIntRate As TextBox
        Dim txtMinPymt As TextBox
        Dim col As TemplatedColumn
        Dim item As CellItem
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim balance, apr, minpay As Double

        For i As Integer = 0 To wGrdCreditors.Rows.Count - 1
            intLeadCreditorInstance = CInt(wGrdCreditors.Rows(i).Cells(4).Text)

            col = wGrdCreditors.Columns(2)
            item = col.CellItems(i)
            txtAccountNo = CType(item.FindControl("txtAccountNo"), TextBox)

            col = wGrdCreditors.Columns(3)
            item = col.CellItems(i)
            txtBalance = CType(item.FindControl("txtBalance"), TextBox)
            balance = Val(txtBalance.Text.Replace("$", "").Replace(",", ""))

            col = wGrdCreditors.Columns(5)
            item = col.CellItems(i)
            txtIntRate = CType(item.FindControl("txtIntRate"), TextBox)
            apr = Val(txtIntRate.Text.Replace("%", ""))

            col = wGrdCreditors.Columns(6)
            item = col.CellItems(i)
            txtMinPymt = CType(item.FindControl("txtMinPayment"), TextBox)
            minpay = Val(txtMinPymt.Text.Replace("$", "").Replace(",", ""))

            If apr = 0 Then
                apr = 15.5 'default
            End If

            If balance > 0 And minpay = 0 Then
                minpay = balance * 0.025 'default
                If minpay < 10 Then
                    minpay = 10
                End If
            End If

            strSQL = "update tblLeadCreditorInstance set "
            strSQL += "AccountNumber = '" & txtAccountNo.Text & "', "
            strSQL += "Balance = " & balance & ", "
            strSQL += "IntRate = " & apr & ", "
            strSQL += "MinPayment = " & minpay & " "
            strSQL += "where LeadCreditorInstance = " & intLeadCreditorInstance

            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
        Next
    End Sub

    Private Sub SaveHardshipInfo(ByVal leadApplicantID As Integer)
        Dim cmd As SqlCommand
        Dim sql As New StringBuilder

        'Dim hIncomeTypes As New List(Of String)
        'For Each li As ListItem In cblHardshipIncome.Items
        '    If li.Selected Then
        '        hIncomeTypes.Add(li.Value)
        '    End If
        'Next
        'If hIncomeTypes.Count = 0 Then
        '    hIncomeTypes.Add("-1")
        'End If

        If DataHelper.RecordExists("tblLeadHardship", String.Format("LeadApplicantID={0}", leadApplicantID)) Then
            sql.Append("update tblLeadHardship set ")
            sql.AppendFormat("hardship='{0}',", ddlHardship.SelectedItem.Text)
            sql.AppendFormat("HardshipOther='{0}',", txtHardshipOther.Text.Replace("'", "''"))
            sql.AppendFormat("ownrent='{0}',", ddlOwnRent.SelectedItem.Text)
            sql.AppendFormat("HomePrinciple='{0}',", Val(txtHomePrinciple.Text))
            sql.AppendFormat("HomeValue='{0}',", Val(txtHomeValue.Text))
            sql.AppendFormat("[401k]={0},", Val(txt401K.Text))
            sql.AppendFormat("SavingsChecking={0},", Val(txtSavChecking.Text))
            sql.AppendFormat("OtherAssets={0},", Val(txtOtherAssets.Text))
            sql.AppendFormat("OtherDebts={0},", Val(txtOtherDebts.Text))
            sql.AppendFormat("MonthlyIncome={0},", Val(txtIncome.Text))
            'sql.AppendFormat("MonthlyIncomeTypes='{0}',", Join(hIncomeTypes.ToArray, ","))
            sql.AppendFormat("Groceries={0},", Val(txtGroceries.Text))
            sql.AppendFormat("CarIns={0},", Val(txtCarIns.Text))
            sql.AppendFormat("HealthIns={0},", Val(txtHealthIns.Text))
            sql.AppendFormat("Utilities={0},", Val(txtUtilities.Text))
            sql.AppendFormat("PhoneBill={0},", Val(txtPhoneBill.Text))
            sql.AppendFormat("HomeIns={0},", Val(txtHomeIns.Text))
            sql.AppendFormat("CarPayments={0},", Val(txtCarPymt.Text))
            sql.AppendFormat("AutoFuel={0},", Val(txtAutoFuel.Text))
            sql.AppendFormat("DiningOut={0},", Val(txtDiningOut.Text))
            sql.AppendFormat("Entertainment={0},", Val(txtEntertainment.Text))
            sql.AppendFormat("HouseRent={0},", Val(txtHousePymt.Text))
            sql.AppendFormat("Other={0},", Val(txtOtherMthly.Text))
            sql.AppendFormat("Occupation='{0}',", txtOccupation.Text.Replace("'", "''"))
            sql.AppendFormat("NumOfKidsInHouse={0},", Val(txtKids.Text))
            sql.AppendFormat("NumOfGrandKidsInHouse={0},", Val(txtGrandKids.Text))
            sql.AppendFormat("Work_Income={0},", Val(txtWorkIncome.Text))
            sql.AppendFormat("SocialSecurity_Income={0},", Val(txtSSIncome.Text))
            sql.AppendFormat("Disability_Income={0},", Val(txtDisability.Text))
            sql.AppendFormat("Retirement_Income={0},", Val(txtRetirePen.Text))
            sql.AppendFormat("Unemployment_Income={0},", Val(txtUnemployment.Text))
            sql.AppendFormat("SelfEmployed_Income={0}", Val(txtSelfEmployed.Text))
            sql.AppendFormat("where LeadApplicantID={0}", leadApplicantID)
        Else
            sql.Append("insert tblLeadHardship (LeadApplicantID,hardship,HardshipOther,OwnRent,HomePrinciple,HomeValue,[401K],SavingsChecking,OtherAssets,OtherDebts,MonthlyIncome,Groceries,CarIns,HealthIns,Utilities,PhoneBill,HomeIns,CarPayments,AutoFuel,DiningOut,Entertainment,HouseRent,Other,Occupation,NumOfKidsInHouse,NumOfGrandKidsInHouse,Work_Income,SocialSecurity_Income,Disability_Income,Retirement_Income,Unemployment_Income,SelfEmployed_Income) values ( ")
            sql.AppendFormat("{0},", leadApplicantID)
            sql.AppendFormat("'{0}',", ddlHardship.SelectedItem.Text)
            sql.AppendFormat("'{0}',", txtHardshipOther.Text.Replace("'", "''"))
            sql.AppendFormat("'{0}',", ddlOwnRent.SelectedItem.Text)
            sql.AppendFormat("{0},", Val(txtHomePrinciple.Text))
            sql.AppendFormat("{0},", Val(txtHomeValue.Text))
            sql.AppendFormat("{0},", Val(txt401K.Text))
            sql.AppendFormat("{0},", Val(txtSavChecking.Text))
            sql.AppendFormat("{0},", Val(txtOtherAssets.Text))
            sql.AppendFormat("{0},", Val(txtOtherDebts.Text))
            sql.AppendFormat("{0},", Val(txtIncome.Text))
            'sql.AppendFormat("'{0}',", Join(hIncomeTypes.ToArray, ","))
            sql.AppendFormat("{0},", Val(txtGroceries.Text))
            sql.AppendFormat("{0},", Val(txtCarIns.Text))
            sql.AppendFormat("{0},", Val(txtHealthIns.Text))
            sql.AppendFormat("{0},", Val(txtUtilities.Text))
            sql.AppendFormat("{0},", Val(txtPhoneBill.Text))
            sql.AppendFormat("{0},", Val(txtHomeIns.Text))
            sql.AppendFormat("{0},", Val(txtCarPymt.Text))
            sql.AppendFormat("{0},", Val(txtAutoFuel.Text))
            sql.AppendFormat("{0},", Val(txtDiningOut.Text))
            sql.AppendFormat("{0},", Val(txtEntertainment.Text))
            sql.AppendFormat("{0},", Val(txtHousePymt.Text))
            sql.AppendFormat("{0},", Val(txtOtherMthly.Text))
            sql.AppendFormat("'{0}',", txtOccupation.Text.Replace("'", "''"))
            sql.AppendFormat("{0},", Val(txtKids.Text))
            sql.AppendFormat("{0},", Val(txtGrandKids.Text))
            sql.AppendFormat("{0},", Val(txtWorkIncome.Text))
            sql.AppendFormat("{0},", Val(txtSSIncome.Text))
            sql.AppendFormat("{0},", Val(txtDisability.Text))
            sql.AppendFormat("{0},", Val(txtRetirePen.Text))
            sql.AppendFormat("{0},", Val(txtUnemployment.Text))
            sql.AppendFormat("{0})", Val(txtSelfEmployed.Text))
        End If

        cmd = New SqlCommand(sql.ToString, ConnectionFactory.Create())
        cmd.Connection.Open()
        cmd.ExecuteNonQuery()
        cmd.Connection.Close()
    End Sub

    Private Sub SaveLeadCalculator()
        Dim cmd As SqlCommand
        Dim strSQL As String

        'Save the Calculator data for the applicant
        'The Retainer fee is the SubMaintenanceFee stuff
        If a Then
            strSQL = "INSERT INTO tblLeadCalculator (LeadApplicantID, TotalDebt, MaintenanceFeeCap, ServiceFeePerAcct, SettlementFeePct, InitialDeposit, DepositCommittment, DateOfFirstDeposit, ReOccurringDepositDay, NoAccts, EstGrowth, PBMIntRate, PBMMinAmt, PBMMinPct, SubMaintenanceFee,FixedFeePercentage) "
            strSQL += "VALUES ("
            strSQL += aID & ", "
            strSQL += CalculatorModelControl1.TotalDebt & ", "
            strSQL += CalculatorModelControl1.ServiceFeeCap & ", "
            strSQL += CalculatorModelControl1.MonthlyFeePerAcct & ", "
            strSQL += CalculatorModelControl1.SettlementFeePct & ", "
            strSQL += CalculatorModelControl1.InitialDeposit & ", "
            strSQL += CalculatorModelControl1.DepositCommittment & ", '"
            strSQL += txtFirstDepositDate.Text & "', "
            strSQL += ddlDepositDay.SelectedItem.Text & ", "
            strSQL += CalculatorModelControl1.TotalNumberOfAccts & ", "
            strSQL += CalculatorModelControl1.EstimateGrowthPct & ", "
            strSQL += CalculatorModelControl1.InterestRate & ", "
            strSQL += CalculatorModelControl1.MinPaymentAmt & ", "
            strSQL += CalculatorModelControl1.MinPaymentPct & ", 0,"
            strSQL += CalculatorModelControl1.FixedFeePercentage & ")"
        Else
            strSQL = "SELECT LeadApplicantID FROM tblLeadCalculator WHERE LeadApplicantID = " & aID 'jhope 4/17 added test and insert if test fails
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            Dim GotIt As Integer = cmd.ExecuteScalar
            cmd.Connection.Close()
            If GotIt > 0 Then
                strSQL = "UPDATE tblLeadCalculator SET "
                strSQL += "TotalDebt =	" & CalculatorModelControl1.TotalDebt & ", "
                strSQL += "MaintenanceFeeCap = " & CalculatorModelControl1.MonthlyFeePerAcct & ", "
                strSQL += "ServiceFeePerAcct = " & CalculatorModelControl1.MonthlyFeePerAcct & ", "
                strSQL += "SettlementFeePct = " & CalculatorModelControl1.SettlementFeePct & ", "
                strSQL += "InitialDeposit = " & CalculatorModelControl1.InitialDeposit & ", "
                strSQL += "DepositCommittment = " & CalculatorModelControl1.DepositCommittment & ", "
                strSQL += "DateOfFirstDeposit = '" & txtFirstDepositDate.Text & "', "
                strSQL += "ReOccurringDepositDay = " & ddlDepositDay.SelectedItem.Text & ", "
                strSQL += "NoAccts = " & CalculatorModelControl1.TotalNumberOfAccts & ", "
                strSQL += "EstGrowth = " & CalculatorModelControl1.EstimateGrowthPct & ", "
                strSQL += "PBMIntRate = " & CalculatorModelControl1.InterestRate & ", "
                strSQL += "PBMMinAmt = " & CalculatorModelControl1.MinPaymentAmt & ", "
                strSQL += "FixedFeePercentage = " & CalculatorModelControl1.FixedFeePercentage & ", "
                strSQL += "PBMMinPct = " & CalculatorModelControl1.MinPaymentPct
                strSQL += " where LeadApplicantID = " & aID
            Else
                strSQL = "INSERT INTO tblLeadCalculator (LeadApplicantID, TotalDebt, MaintenanceFeeCap, ServiceFeePerAcct,  SettlementFeePct, InitialDeposit, DepositCommittment, DateOfFirstDeposit, ReOccurringDepositDay, NoAccts, EstGrowth, PBMIntRate, PBMMinAmt, PBMMinPct, SubMaintenanceFee,FixedFeePercentage) " 'jhope 04/17
                strSQL += "VALUES ("
                strSQL += aID & ", "
                strSQL += CalculatorModelControl1.TotalDebt & ", "
                strSQL += CalculatorModelControl1.ServiceFeeCap & ", "
                strSQL += CalculatorModelControl1.MonthlyFeePerAcct & ", "
                strSQL += CalculatorModelControl1.SettlementFeePct & ", "
                strSQL += CalculatorModelControl1.InitialDeposit & ", "
                strSQL += CalculatorModelControl1.DepositCommittment & ", '"
                strSQL += txtFirstDepositDate.Text & "', "
                strSQL += ddlDepositDay.SelectedItem.Text & ", "
                strSQL += CalculatorModelControl1.TotalNumberOfAccts & ", "
                strSQL += CalculatorModelControl1.EstimateGrowthPct & ", "
                strSQL += CalculatorModelControl1.InterestRate & ", "
                strSQL += CalculatorModelControl1.MinPaymentAmt & ", "
                strSQL += CalculatorModelControl1.MinPaymentPct & ", 0,"
                strSQL += CalculatorModelControl1.FixedFeePercentage & ")"
            End If
        End If

        cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
        cmd.Connection.Open()
        cmd.ExecuteNonQuery()
        cmd.Connection.Close()
    End Sub

    Private Sub SetProperties()
        'CalculatorModelControl1.EstimateGrowthPct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentInflation")) * 100, "#.##")
        CalculatorModelControl1.InterestRate = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMAPR")) * 100, "#.##")
        CalculatorModelControl1.MinPaymentAmt = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMMinimum")), "0.00")
        CalculatorModelControl1.MinPaymentPct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMPercentage")) * 100, "#.##")
        'CalculatorModelControl1.ServiceFeeCap = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentMaintenanceFeeCap")), "0.00")
        CalculatorModelControl1.MonthlyFeePerAcct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentMonthlyFee")), "0.00")
        CalculatorModelControl1.ServiceFeeCap = CalculatorModelControl1.MonthlyFeePerAcct
        CalculatorModelControl1.SettlementFeePct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentSettlementPercentage")) * 100, "#.##")
    End Sub

    Private Sub SetupEmailComm()
        Dim tbl As DataTable = SqlHelper.GetDataTable("select count(*) [all], isnull(sum(case when dateunsubscribed is not null then 1 else 0 end),0) [unsub] from tblleademails where [type] in ('Followup #2','Followup #1','Initial') and leadapplicantid = " & aID)
        Dim count As Integer
        Dim unsub As Integer

        btnSendFollowup.Visible = False

        If tbl.Rows.Count = 1 Then
            count = CInt(tbl.Rows(0)("all"))
            unsub = CInt(tbl.Rows(0)("unsub"))

            If unsub = 0 Then
                Select Case count
                    Case 1
                        lblFollowup.Text = "Send Follow Up"
                        btnSendFollowup.Visible = True
                    Case 2
                        lblFollowup.Text = "Send Follow Up #2"
                        btnSendFollowup.Visible = True
                End Select
            End If
        End If
    End Sub

    Private Sub ShowGrid(ByVal sqlDS_ToUse As SqlDataSource, ByVal gridToShow As Infragistics.WebUI.UltraWebGrid.UltraWebGrid)
        Try

            Dim dv As DataView
            Dim recordCount As Integer

            dv = CType(sqlDS_ToUse.Select(DataSourceSelectArguments.Empty), DataView)
            recordCount = dv.Table.Rows.Count
            If recordCount = 0 Then
                gridToShow.Visible = False
            Else
                gridToShow.Visible = True
            End If
        Catch ex As Exception
            gridToShow.Visible = False
        End Try
    End Sub

    Private Sub SubmitVerification()
        Dim Name As String = ConstructFullName(txtFName.Text, txtMName.Text, txtLName.Text)
        Dim Phone As String = txtPhone.Text.Trim
        Dim AccessNum As String = ""
        Dim Msgs As String = ""

        If Name.Length = 0 Then
            Name = ConstructFullName(txtFirstName.Text, txtMiddleName.Text, txtLastName.Text)
            If Name.Length = 0 Then
                Msgs &= "Client's full name is required to submit a verification. "
            End If
        End If

        If Phone.Length <> 14 Then
            Phone = txtHomePhone.Text.Trim
            If Phone.Length <> 14 Then
                Msgs &= "A valid phone number is required to submit a verification. "
            End If
        End If

        If Not IsDate(txtFirstDepositDate.Text) Then
            Msgs &= "A valid First Deposit date is required. "
        Else
            If Not CDate(txtFirstDepositDate.Text) > Now Then
                Msgs &= "First Deposit date must be a future date. "
            End If
        End If

        If Not Val(CalculatorModelControl1.InitialDeposit) > 0 Then
            Msgs &= "Initial Deposit amount required. "
        End If

        If Len(Msgs) > 0 Then
            wgbVerification.Visible = False
            divMsg.Style("display") = ""
            divMsg.InnerText = Msgs
        Else
            lblLastSave.Text = ""
            divMsg.Style("display") = "none"
            divMsg.InnerText = ""
            wgbVerification.Visible = True

            ThreePVHelper.SendRequest(aID, CInt(ddlCompany.SelectedItem.Value), CInt(cboStateID.SelectedItem.Value), ConstructFullName(txtFirstName.Text, txtMiddleName.Text, txtLastName.Text), txtPhone.Text, UserID, AccessNum, tdPVN.InnerHtml, txtFirstDepositDate.Text, CalculatorModelControl1.InitialDeposit)

            If AccessNum.Length = 10 Then
                tdAccessNum.InnerHtml = Left(AccessNum, 3) & "-" & Mid(AccessNum, 4, 3) & "-" & Right(AccessNum, 4)
                ImgMakeCall3PV.Attributes.Add("onclick", String.Format("parent.make_call('{0}');", AccessNum))
                ImgDialVerification.Attributes.Add("onclick", String.Format("parent.dialpad('{0}');", tdPVN.InnerText.Trim))
                ImgAddClient.Attributes.Add("onclick", "parent.createConference();")
                ImgDialStar.Attributes.Add("onclick", "parent.dialpad('*');")
            End If

            gvVerification.DataBind()
        End If
    End Sub

    Private Sub UpdateCallInfo(ByVal LeadId As Integer)
        Dim callId As String = hdnCallId.Value.Trim
        Dim dnis As String

        If callId.Length > 0 AndAlso LeadId > 0 Then
            Dim sb As New System.Text.StringBuilder
            dnis = CallControlsHelper.GetDnis(callId)
            sb.Append("Update tblLeadCall Set ")
            sb.AppendFormat(" LeadApplicantId = {0} ", LeadId)
            sb.AppendFormat(", Dnis = '{0}' ", dnis)
            sb.Append(", LastModified = GetDate() ")
            sb.AppendFormat(", LastModifiedBy = {0} ", UserID)
            sb.AppendFormat(" Where CallIdKey = '{0}' ", callId)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                hdnCallId.Value = ""
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try
        End If
    End Sub

    Private Function UpdateTheTransfer() As Boolean
        Dim r As Boolean = True

        'For now all we're going to do is update the lead's status back to In Process. In the future we may need
        'to push some changes made to the lead record over to the client.

        Try
            divMsg.Style("display") = "none"
            divMsg.InnerText = ""

            SqlHelper.ExecuteNonQuery(String.Format("update tblleadapplicant set statusid = {0} where leadapplicantid = {1}", ddlStatus.SelectedItem.Value, aID), CommandType.Text)
            Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(aID)
            LeadRoadmapHelper.InsertRoadmap(aID, ddlStatus.SelectedItem.Value, parentID, "Applicant Status Changed.", UserID)

            If Trim(txtQuickNote.Text) <> "" Then
                Drg.Util.DataHelpers.NoteHelper.InsertNote(txtQuickNote.Text.Trim, UserID, CInt(hdnClientID.Value))
            End If

            RoadmapHelper.InsertRoadmap(CInt(hdnClientID.Value), 24, Nothing, UserID) 'Return to Compliance
        Catch ex As Exception
            divMsg.Style("display") = ""
            divMsg.InnerText = "Unable to set status to <i>In Process</i>. " & ex.Message
            r = False
        End Try

        Return r
    End Function

    Private Sub assignTXT(ByVal UserID As Integer, Optional ByVal LeadApplicantID As Integer = 0)
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr As SqlDataReader

        If LeadApplicantID <> 0 Then
            strSQL = "SELECT l.*, convert(varchar(10), FirstAppointmentDate, 101) as FirstAppDate, convert(varchar(8), FirstAppointmentDate, 108) as FirstAppTime, s.Description [Status], r.CreditReportId, r.ReportID, src.name [source], rep.firstname + ' ' + rep.lastname [rep] FROM tblLeadApplicant l left join tblLeadStatus s on s.StatusID = l.StatusID left join tblcreditreport r on r.reportid = l.lastreportid left join tblleadsources src on src.leadsourceid = l.leadsourceid left join tbluser rep on rep.userid = l.repid WHERE l.LeadApplicantID = " & LeadApplicantID
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheApplicantData(rdr)
            rdr.Close()
            cmd.Dispose()

            strSQL = "SELECT * FROM tblLeadHardship WHERE LeadApplicantID = " & LeadApplicantID
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignHardshipData(rdr)
            rdr.Close()
            cmd.Dispose()

            strSQL = "SELECT * FROM tblLeadCalculator WHERE LeadApplicantID = " & LeadApplicantID
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheApplicantCalculatorData(rdr)
            rdr.Close()
            cmd.Dispose()

            SetupEmailComm()
        Else 'we're inserting a new client blank all the fields and clear all the grids and their rows
            ClearAllEntryData()
            GetProductIdFromDNIS()
            SetProperties()

            LoadVendors()
            SelectDefaultVendor()

        End If

        If (Me.txtPhone.Text.Trim = "" OrElse Me.txtPhone.Text.Trim = "(   )    -") AndAlso hdnAni.Value.Trim.Length > 0 Then
            Me.txtPhone.RawText = hdnAni.Value.Trim
        End If

        'If (Me.txtPhone.Text.Trim <> "" AndAlso Me.txtPhone.Text.Trim <> "(   )    -") Then
        'If (Me.txtPhone.Text.Trim.Length = 14) Then
        '    Me.txtPhone.ReadOnly = True
        'End If
    End Sub

    Private Sub SelectDefaultVendor()

        Dim query As String = String.Format("select isnull(VendorId,0) from tblVendorDefault where AgencyId = {0}", AgencyID)
        Dim DefaultVendorId As Integer = CInt(SqlHelper.ExecuteScalar(query, CommandType.Text))

        If DefaultVendorId <> 0 Then
            ddlVendor.SelectedValue = DefaultVendorId
            ddlVendor_SelectedIndexChanged(Nothing, Nothing)
        End If

    End Sub

    Private Sub bShowGridLinks(ByVal applicantID As Integer)
        Select Case applicantID
            Case 0
                lnkAddNotes.Visible = False
                lnkAddBanks.Visible = False
                lnkAddCreditors.Visible = False
                lnkAddCoApps.Visible = False
            Case Else
                If CInt(hdnClientID.Value) > 0 Then
                    'Lead is already a client
                    lnkAddNotes.Visible = False
                    lnkAddBanks.Visible = False
                    lnkAddCreditors.Visible = False
                    lnkAddCoApps.Visible = False
                    lnkCreditReport.Visible = True 'False
                    btnSendFollowup.Visible = False
                    aImportCreditors.Visible = False
                    spanCredSep.Visible = False
                    spanCredSep2.Visible = False
                Else
                    lnkAddNotes.Visible = True
                    lnkAddBanks.Visible = True
                    lnkAddCreditors.Visible = True
                    lnkAddCoApps.Visible = True
                End If
        End Select
    End Sub

    Private Sub bindCBL(ByVal cblToBind As CheckBoxList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String)
        Try
            cblToBind.AppendDataBoundItems = True

            Dim cmd As New SqlCommand(sqlSelect, ConnectionFactory.Create())
            Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            cblToBind.DataTextField = TextField
            cblToBind.DataValueField = ValueField
            cblToBind.DataSource = rdr
            cblToBind.DataBind()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub bindDDL(ByVal ddlToBind As DropDownList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String, Optional ByVal blnAddEmptyRow As Boolean = True)
        Try
            If blnAddEmptyRow Then
                Dim blankItem As New ListItem(String.Empty, 0)
                blankItem.Selected = False
                ddlToBind.Items.Add(blankItem)
            End If

            ddlToBind.AppendDataBoundItems = True

            Dim cmd As New SqlCommand(sqlSelect, ConnectionFactory.Create())
            Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            ddlToBind.DataTextField = TextField
            ddlToBind.DataValueField = ValueField
            ddlToBind.DataSource = rdr
            ddlToBind.DataBind()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Function customCertificateValidation(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As Security.SslPolicyErrors) As Boolean
        Return True
    End Function

    Private Sub ddlTimeZone_SelectedIndexChanged(ByVal sender As Object, ByVal args As System.EventArgs) Handles ddlTimeZone.SelectedIndexChanged
        CalculateTime(True)
    End Sub

    Private Sub generateLSA(Optional ByVal bElectronic As Boolean = False, Optional ByVal bUseLexxEsign As Boolean = False)
        Dim sBankName As String = ""
        Dim sBankRoutingNum As String = ""
        Dim sBankAcctNum As String = ""
        Dim typeOfAccount As String = ""
        Dim sParalegalName As String = ""
        Dim sParaLegalTitle As String = ""
        Dim sParalegalExt As String = ""

        If Not RequiredLSAFieldsValid(bElectronic) Then
            Exit Sub
        End If

        SaveLeadCalculator()
        SaveCreditorAccountInfo()

        'get productid
        Dim bShowFeeAddendum As Boolean
        Select Case CalculatorModelControl1.MonthlyFeePerAcct
            Case 90
                bShowFeeAddendum = False
            Case Else
                bShowFeeAddendum = True
        End Select

        'get banking info
        If wGrdBanking.Rows.Count > 0 Then
            Dim sqlBank As String = String.Format("stp_enrollment_getBanks {0}", aID)
            Using dtBanks As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlBank, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each bank As DataRow In dtBanks.Rows
                    sBankName = bank("bankname").ToString
                    sBankRoutingNum = bank("routingnumber").ToString
                    sBankAcctNum = bank("accountnumber").ToString
                    If Boolean.Parse(bank("checking").ToString) = True Then
                        typeOfAccount = "Checking"
                    Else
                        typeOfAccount = "Savings"
                    End If

                    Exit For
                Next
            End Using
        Else
            sBankName = ""
            sBankRoutingNum = ""
            sBankAcctNum = ""
            typeOfAccount = "Checking"
        End If

        Dim CompanyID As Integer = ddlCompany.SelectedItem.Value
        Dim StateID As Integer = 0

        If cboStateID.SelectedIndex <> 0 Then
            StateID = cboStateID.SelectedValue
        Else
            Throw New Exception("Client State is needed for LSA Agreement!")
        End If

        Dim ContingencyFeePercent = CDbl(CalculatorModelControl1.SettlementFeePct)
        Dim MaintFeeCap As String = Val(CalculatorModelControl1.ServiceFeeCap)
        Dim MaintFeePerAcct As String = Val(CalculatorModelControl1.MonthlyFeePerAcct)
        Dim BankName As String = sBankName
        Dim BankRoutingNum As String = sBankRoutingNum
        Dim BankAcctNum As String = sBankAcctNum
        Dim InitialDepositAmount As String = CalculatorModelControl1.InitialDeposit
        Dim noAccts As Integer = Val(CalculatorModelControl1.TotalNumberOfAccts)

        Dim InitialDepositDate As String = Now.AddDays(3)
        If IsDate(txtFirstDepositDate.Text) Then
            InitialDepositDate = FormatDateTime(txtFirstDepositDate.Text, DateFormat.ShortDate)
        End If

        Dim DepositDay As String = getNth(ddlDepositDay.Text)
        Dim DepositCommitmentAmount As String = CalculatorModelControl1.DepositCommittment

        '***********************************
        'get agent info from I3 db
        Dim sqlParalegal As String = String.Format("stp_SmartDebtor_GetAgentInfoFromUserID {0}", UserID)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlParalegal.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)

            For Each row As DataRow In dt.Rows
                sParalegalName = row("ParaLegalName").ToString
                sParaLegalTitle = "Law Firm Representative"
                sParalegalExt = row("ParaLegalExt").ToString
            Next

        End Using
        '***********************************
        '*********show optional form letter****************
        Dim bShowFormLetter As Boolean = True
        If Me.ddlStatus.SelectedItem.Value <> 2 Then
            bShowFormLetter = False
        End If

        bShowFormLetter = chkFormLetter.Checked

        Dim bIncludeVoid As Boolean = False
        Dim bOnlySchA As Boolean = False
        Dim bOnlyVoid As Boolean = False
        Dim bOnlyTruth As Boolean = False
        Dim bSpanish As Boolean = False
        Dim iLang As Integer = ddlLanguage.SelectedValue
        If iLang > 1 Then
            bSpanish = True
        End If

        bIncludeVoid = chkVoidedCheck.Checked
        bOnlySchA = chkOnlyScheduleA.Checked
        bOnlyVoid = chkOnlyVoidedCheck.Checked
        bOnlyTruth = chkOnlyTruthInServicesCheck.Checked

        Dim tblBorrowers As DataTable = CredStarHelper.GetBorrowers(aID)
        Dim bHasCoApplicant As Boolean = (tblBorrowers.Rows.Count > 1)

        Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)

        If bElectronic Then
            Select Case bUseLexxEsign
                Case True
                    'holds returned documents to process
                    Dim docList As List(Of LetterTemplates.BatchTemplate)

                    'generate documents
                    docList = rpt.Generate_LSA_Mossler_20150427_LexxiomEsign(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent,
                      MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=BankName,
                      BankRoutingNum:=BankRoutingNum, BankAcctNum:=BankAcctNum, InitialDepositDate:=InitialDepositDate, InitialDepositAmount:=InitialDepositAmount,
                      DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2),
                      TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text,
                      ClientAddr1:=txtAddress.Text, ClientAddr2:="", ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZip.Text,
                      ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt,
                      NumberOfAccounts:=noAccts, bShowFormLetter:=bShowFormLetter,
                      LeadApplicantID:=aID, bShowVoidedCheck:=bIncludeVoid, bOnlyShowScheduleA:=bOnlySchA, bOnlyShowVoidedCheck:=bOnlyVoid, bOnlyShowTruthInService:=bOnlyTruth,
                      LoggedInUserID:=UserID, bElectronic:=bElectronic, HasCoApps:=bHasCoApplicant, bSpanishVersion:=bSpanish, bShowFeeAddendum:=bShowFeeAddendum,
                      bIsCIDClient:=True,
                      bAreWeSigningDocuments:=True,
                      SSN:=txtSSN.Text,
                      DOB:=txtDOB.Text)

                    'get new unique signing batch id
                    Dim signingBatchId As String = Guid.NewGuid.ToString

                    'stores the names of the reports
                    Dim dNames As New List(Of String)

                    'needed to check for duplicate documents
                    Dim docIDs As New Hashtable

                    'only get documents that need signatures
                    Dim nosign = From doc As LetterTemplates.BatchTemplate In docList Where Not doc.TemplateName.StartsWith("Signing") Select doc
                    For Each doc As LetterTemplates.BatchTemplate In nosign

                        'assign new doc  id
                        Dim documentId As String = Guid.NewGuid.ToString
                        Try
                            docIDs.Add(doc.TemplateName.Replace("Signing_", ""), documentId)
                        Catch ex As Exception
                            Continue For
                        End Try

                        'export html docs for gui navigation
                        Dim path As String = "C:\lsasigning\tmp\temp" & String.Format("\{0}.html", documentId)
                        Using finalHTML As New GrapeCity.ActiveReports.Export.Html.Section.HtmlExport
                            finalHTML.OutputType = GrapeCity.ActiveReports.Export.Html.Section.HtmlOutputType.DynamicHtml
                            finalHTML.IncludeHtmlHeader = False
                            finalHTML.IncludePageMargins = False
                            finalHTML.Export(doc.TemplateRpt.Document, path)
                        End Using

                        'need matching pdf for final signing process
                        If Not doc.NeedSignature Then
                            path = "C:\lsasigning\tmp\temp" & String.Format("\{0}.pdf", documentId)
                            Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                                finalPDF.Export(doc.TemplateRpt.Document, path)
                            End Using
                        End If

                        'save document to db
                        SmartDebtorHelper.SaveLeadDocument(aID, documentId, UserID, doc.TemplateType, signingBatchId, txtEmailAddress.Text)
                        dNames.Add(doc.TemplateName)
                    Next

                    Dim needsign = From doc As LetterTemplates.BatchTemplate In docList Where doc.TemplateName.StartsWith("Signing") Select doc
                    For Each doc As LetterTemplates.BatchTemplate In needsign
                        Dim templateName As String = doc.TemplateName.Replace("Signing_", "")
                        If docIDs.Contains(templateName) Then
                            Dim path As String = "C:\lsasigning\tmp\" & String.Format("temp\{0}.pdf", docIDs(templateName))
                            Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                                finalPDF.Export(doc.TemplateRpt.Document, path.Replace(".html", ".pdf"))
                            End Using
                        End If
                    Next

                    'send notification to client    UPDATED with privica
                    SmartDebtorHelper.SendEsignNotificationWithPrivica(txtEmailAddress.Text, dNames.ToArray, signingBatchId, UserID, aID, bSpanish)

                Case Else
                    Dim rDocs As Collections.Generic.Dictionary(Of String, GrapeCity.ActiveReports.SectionReport) = rpt.Generate_SM_LSA_v3_EchoSign(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent,
                         MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=BankName,
                         BankRoutingNum:=BankRoutingNum, BankAcctNum:=BankAcctNum, InitialDepositAmount:=InitialDepositAmount,
                         DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2),
                         TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text,
                         ClientAddr1:=txtAddress.Text, ClientAddr2:="", ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZip.Text,
                         ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt,
                         NumberOfAccounts:=noAccts, bShowFormLetter:=bShowFormLetter, InitialDepositDate:=InitialDepositDate,
                         LeadApplicantID:=aID, bShowVoidedCheck:=bIncludeVoid, bOnlyShowScheduleA:=bOnlySchA, bOnlyShowVoidedCheck:=bOnlyVoid,
                         bElectronic:=bElectronic, bHasCoApplicant:=bHasCoApplicant, bOnlyShowTruthInService:=bOnlyTruth, bSpanishVersion:=bSpanish,
                         LoggedInUserID:=UserID, bShowFeeAddendum:=bShowFeeAddendum)

                    Dim recipients As String = txtEmailAddress.Text

                    If Not bOnlyVoid Then
                        For i As Integer = 1 To tblBorrowers.Rows.Count - 1
                            recipients &= "," & tblBorrowers.Rows(i)("email")
                        Next
                    End If

                    'Dim documentId As String = EchoSignHelper.SendDocuments(rDocs, "Legal Service Agreement", recipients)
                    'SmartDebtorHelper.SaveLeadDocument(aID, documentId, UserID, SmartDebtorHelper.DocType.LSA, txtEmailAddress.Text)
            End Select
            ds_leaddocuments.DataBind()
            gvDocuments.DataBind()
        Else
            Dim rDoc As GrapeCity.ActiveReports.Document.SectionDocument = rpt.Generate_SM_LSA_20201101(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent,
              MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=BankName,
              BankRoutingNum:=BankRoutingNum, BankAcctNum:=BankAcctNum, InitialDepositAmount:=InitialDepositAmount,
              DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2),
              TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text,
              ClientAddr1:=txtAddress.Text, ClientAddr2:="", ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZip.Text,
              ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt,
              NumberOfAccounts:=noAccts, bShowFormLetter:=bShowFormLetter, InitialDepositDate:=InitialDepositDate,
              LeadApplicantID:=aID, bShowVoidedCheck:=bIncludeVoid, bOnlyShowScheduleA:=bOnlySchA,
              bOnlyShowVoidedCheck:=bOnlyVoid, bOnlyShowTruthInService:=bOnlyTruth, bSpanishVersion:=bSpanish, LoggedInUserID:=UserID,
              bShowFeeAddendum:=bShowFeeAddendum,
              bIsCIDClient:=True,
              SSN:=txtSSN.Text,
              DOB:=txtDOB.Text)

            Dim memStream As New System.IO.MemoryStream()
            Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport

            pdf.Export(rDoc, memStream)
            memStream.Seek(0, IO.SeekOrigin.Begin)

            Session("LSAAgreement") = memStream.ToArray

            Dim _sb As New System.Text.StringBuilder()
            _sb.Append("window.open('viewLSA.aspx?type=lsa','',")
            _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)
        End If

        divMsg.Style("display") = "none"
        divMsg.InnerText = ""

        Dim TrustID As Integer = SmartDebtorHelper.GetTrustID(CompanyID)
        SmartDebtorHelper.InsertTrustID(TrustID, aID)
    End Sub

    Private Function getNth(ByVal numberToFormat As String) As String
        Dim lastNumber As String = Right(numberToFormat, 1)
        Select Case Val(lastNumber)
            Case 1
                Return numberToFormat & "st"
            Case 2
                Return numberToFormat & "nd"
            Case 3
                Return numberToFormat & "rd"
            Case Else
                Return numberToFormat & "th"
        End Select
    End Function

    Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
        If Loading = False Then
            Select Case e.Button.Text
                Case "Home"
                    If FromWhere = "fix" Then
                        Response.Redirect("ExportDetail.aspx?id=" & ExportDtl)
                    Else
                        Response.Redirect(String.Format("Default.aspx?p1={0}&p2={1}&s={2}", Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
                    End If
                Case "New Applicant"
                    Response.Redirect(String.Format("NewEnrollment2.aspx?p1={0}&p2={1}&s={2}", Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
                Case "Generate LSA"
                    generateLSA()
                Case "Generate e-LSA"
                    generateLSA(True)
                Case "Print Form"
                    PrintInfoSheet()
                Case "Switch Model"
                    SDModelHelper.ConvertToModel("newenrollment.aspx", aID, UserID)
                    Me.Response.Redirect(String.Format("newenrollment.aspx?id={0}", aID))
                Case "Submit Verification"
                    SubmitVerification()
                Case "Get Signed Docs"
                    'If EchoSignHelper.GetPendingLeadDocuments(aID) > 0 Then
                    '    lblLastSave.Text = ""
                    'Else
                    '    lblLastSave.Text = "No signed docs available. " & Now
                    'End If
                    gvDocuments.DataBind()
                Case "Send Verification Email"
                    If RequiredLSAFieldsValid(True) Then
                        Dim path As String = Request.PhysicalApplicationPath & "\email\templates\LeadVerification.txt"
                        LeadHelper.SendVerificationEmail(aID, path, ConstructFullName(txtFirstName.Text, txtMiddleName.Text, txtLastName.Text), txtEmailAddress.Text, CInt(ddlCompany.SelectedItem.Value), ddlCompany.SelectedItem.Text, UserID)
                        gvLeadEmails.DataBind()
                        lblLastSave.Text = "Verification email sent."
                    End If
            End Select
        End If
    End Sub

    Private Sub ReloadReasons(ByVal ReasonId As Integer)
        ddlReasons.Items.Clear()
        bindDDL(ddlReasons, String.Format("select LeadReasonsID, Description from tblLeadReasons where StatusID={0} and (Show = 1 or LeadReasonsId={1}) order by DisplayOrder", ddlStatus.SelectedItem.Value, ReasonId), "Description", "LeadReasonsID", False)
        trReasons.Visible = (ddlReasons.Items.Count > 0)
        'trProcessor.Visible = (ddlStatus.SelectedItem.Text = "In Process")
    End Sub

    Protected Sub btnDocsRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDocsRefresh.Click
        gvDocuments.DataBind()
    End Sub

    Public Function ValidateEPackage() As String

        Dim response As String = ""
        If Not isValidLead() Then
            response += "Please create a lead.\n"
        End If
        If Not hasValidEmail() Then
            response += "Please provide a valid email address."
        End If

        Return response
    End Function

    Public Sub CreatePrivUser() 'CHOLT 7/24/2020
        ' NOTE: Privica ID in this context refers to the ID gained by creating an account at AET, NOT the ID sent to us by privica. The ID sent to us by 
        ' Privica is called the Processor ID.


        Dim isTest As Boolean = True 'using false SSN for dev environment and email to prevent error

        Try
            Dim debug As Boolean = True 'This will change when live. Live URL will be needed.
            Dim password As String
            Dim confirmPassword As String
            Dim PrivUserID As String
            Dim email As String
            Dim firstName As String
            Dim lastName As String
            Dim city As String
            Dim state As String
            Dim zip As String
            Dim SSN As String
            Dim DOB As String
            Dim address As String
            Dim privicaResponseID As String
            Dim phone As String
            Dim stateAB As String
            'Dim address2 As String

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("LeadApplicantId", aID))
            Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoForPrivica", CommandType.StoredProcedure, params.ToArray)


            'import current user's ID
            If Not IsDBNull(dt.Rows(0)("ProcessorID")) Then
                If Not dt.Rows(0)("ProcessorID") = 0 Then
                    PrivUserID = dt.Rows(0)("ProcessorID")
                Else
                    PrivUserID = String.Empty
                End If
            Else
                PrivUserID = String.Empty
            End If

            'fill info based on LeadApplicantID
            If Not IsDBNull(dt.Rows(0)("email")) Then
                email = dt.Rows(0)("email")
            Else
                email = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("firstname")) Then
                firstName = dt.Rows(0)("firstname")
            Else
                firstName = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("lastname")) Then
                lastName = dt.Rows(0)("lastname")
            Else
                lastName = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("city")) Then
                city = dt.Rows(0)("city")
            Else
                city = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("state")) Then
                state = dt.Rows(0)("state")
            Else
                state = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("Abbreviation")) Then
                stateAB = dt.Rows(0)("Abbreviation")
            Else
                stateAB = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("zipcode")) Then
                zip = dt.Rows(0)("zipcode")
            Else
                zip = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("ssn")) Then
                SSN = dt.Rows(0)("ssn")
            Else
                SSN = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("dob")) Then
                DOB = dt.Rows(0)("dob")
            Else
                DOB = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("address1")) Then
                address = dt.Rows(0)("address1")
            Else
                address = String.Empty
            End If
            If Not IsDBNull(dt.Rows(0)("leadphone")) Then
                phone = dt.Rows(0)("leadphone")
            Else
                phone = String.Empty
            End If

            'converts long date/time to short date mm/dd/yyyy
            Dim dtshort As Date = Date.Parse(DOB)
            Dim dateString As String = dtshort.ToShortDateString()
            Dim trimPhone = phone.Trim().Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "")

            'creates a temp password to use for account creation. upper case first letter of first name + Lead ID + last 4 SSN + First lower case letter of last name
            password = firstName.Substring(0, 1).ToUpper & aID & SSN.Replace("-", "").Substring(5, 4) & lastName.Substring(0, 1).ToLower
            confirmPassword = firstName.Substring(0, 1).ToUpper & aID & SSN.Replace("-", "").Substring(5, 4) & lastName.Substring(0, 1).ToLower

            'creates object
            Dim privUser As New PrivicaResults
            Dim result As String

            If String.IsNullOrEmpty(PrivUserID) Then
                'creates user and assigns results to string
                result = PrivicaHelper.CreateUser(debug, email, password, confirmPassword, isTest, aID)

                'parses JSON string into object
                privUser = parsePrivUserCreate(result)

                'assign AET returned user ID
                PrivUserID = privUser.userID

                'update database with values
                Dim cmd As SqlCommand
                Dim sql As New StringBuilder
                sql.Append("update tblLeadApplicant set ")
                sql.AppendFormat("ProcessorID={0} ", PrivUserID)
                sql.AppendFormat(",AccountID={0} ", privUser.iraLoginsUserID)
                sql.AppendFormat("where LeadApplicantID={0}", aID)
                cmd = New SqlCommand(sql.ToString, ConnectionFactory.Create())
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                cmd.Connection.Close()
                Try
                    'Send create user info to privica
                    privicaResponseID = PrivicaHelper.PostToPrivica(email, PrivUserID, privUser.iraLoginsUserID, password)

                    'update database with values
                    Dim cmd1 As SqlCommand
                    Dim sql1 As New StringBuilder
                    sql1.Append("update tblLeadApplicant set ")
                    sql1.AppendFormat("PrivicaID={0} ", privicaResponseID)
                    sql1.AppendFormat("where LeadApplicantID={0}", aID)
                    cmd1 = New SqlCommand(sql1.ToString, ConnectionFactory.Create())
                    cmd1.Connection.Open()
                    cmd1.ExecuteNonQuery()
                    cmd1.Connection.Close()

                Catch ex As Exception
                    'try to send privica information
                End Try

                Try
                    'update Privica xREF with values
                    Dim myparams As New List(Of SqlParameter)
                    myparams.Add(New SqlParameter("PrivicaID", privicaResponseID)) 'Id given to us from privica
                    myparams.Add(New SqlParameter("AETAccountID", privUser.iraLoginsUserID))
                    myparams.Add(New SqlParameter("LeadID", aID))
                    myparams.Add(New SqlParameter("AETID", PrivUserID)) 'also known as processor id
                    SqlHelper.ExecuteNonQuery("stp_InsertPrivicaXREF", CommandType.StoredProcedure, myparams.ToArray)

                Catch ex As Exception
                    'try to send privica information
                End Try

            End If

            'sleep for 2 seconds to catch response
            Threading.Thread.Sleep(2000)

            Try
                'updates user info in order to create questions
                PrivicaHelper.UpdateUser(debug, PrivUserID, firstName, lastName, city, state, SSN, dateString, address, "", zip, isTest, aID)
            Catch ex As Exception
                'if user info already updated, continue to ask questions
            End Try

            Try
                'send update user info to privica site via post
                PrivicaHelper.PostToPrivicaUpdate(privicaResponseID, firstName, lastName, trimPhone, address, city, stateAB, zip, dateString, SSN.Replace("-", ""))
            Catch ex As Exception
                'update to privica
            End Try

            'sleep for 2 seconds to catch response
            Threading.Thread.Sleep(2000)

            Try
                'creates questions
                result = PrivicaHelper.CreateQuestion(debug, PrivUserID)
                privUser = parsePrivQuestionCreate(result)

            Catch ex As Exception
                divMsg.Style("display") = ""
                divMsg.InnerText = "Failed to create questions, If you failed questions once before, please submit ID's to Privica"
                Exit Sub
            End Try

            'fills in questions and answers on div newenrollment page
            PrivQ1.InnerText = privUser.question1
            PrivQ1A1.InnerText = privUser.Q1answer1
            PrivQ1A2.InnerText = privUser.Q1answer2
            PrivQ1A3.InnerText = privUser.Q1answer3
            PrivQ1A4.InnerText = privUser.Q1answer4
            PrivQ1A5.InnerText = privUser.Q1answer5
            PrivQ2.InnerText = privUser.question2
            PrivQ2A1.InnerText = privUser.Q2answer1
            PrivQ2A2.InnerText = privUser.Q2answer2
            PrivQ2A3.InnerText = privUser.Q2answer3
            PrivQ2A4.InnerText = privUser.Q2answer4
            PrivQ2A5.InnerText = privUser.Q2answer5
            PrivQ3.InnerText = privUser.question3
            PrivQ3A1.InnerText = privUser.Q3answer1
            PrivQ3A2.InnerText = privUser.Q3answer2
            PrivQ3A3.InnerText = privUser.Q3answer3
            PrivQ3A4.InnerText = privUser.Q3answer4
            PrivQ3A5.InnerText = privUser.Q3answer5
            PrivQ4.InnerText = privUser.question4
            PrivQ4A1.InnerText = privUser.Q4answer1
            PrivQ4A2.InnerText = privUser.Q4answer2
            PrivQ4A3.InnerText = privUser.Q4answer3
            PrivQ4A4.InnerText = privUser.Q4answer4
            PrivQ4A5.InnerText = privUser.Q4answer5
            PrivQ5.InnerText = privUser.question5
            PrivQ5A1.InnerText = privUser.Q5answer1
            PrivQ5A2.InnerText = privUser.Q5answer2
            PrivQ5A3.InnerText = privUser.Q5answer3
            PrivQ5A4.InnerText = privUser.Q5answer4
            PrivQ5A5.InnerText = privUser.Q5answer5

            'makes questions visible
            privicaQApop.Visible = True

            ScriptManager.RegisterStartupScript(Me, GetType(Page), "startCounter", "privCounter();", True)
        Catch ex As Exception
            divMsg.Style("display") = ""
            divMsg.InnerText = "Error has Occurred: " & ex.Message
        End Try
    End Sub

    Public Function parsePrivUserCreate(ByVal result As String) As PrivicaResults
        Dim privUser As New PrivicaResults

        Dim obj As JObject = JObject.Parse(result)

        privUser.userID = CInt(obj.SelectToken("data").SelectToken("id").ToString)
        privUser.iraLoginsUserID = CInt(obj.SelectToken("data").SelectToken("relationships").SelectToken("masterRegistration").SelectToken("data").SelectToken("id").ToString)

        Return privUser
    End Function
    Public Function parsePrivQuestionCreate(ByVal result As String) As PrivicaResults
        'creates new results object
        Dim privUser As New PrivicaResults

        'parses the JSON string
        Dim o As JObject = JObject.Parse(result)

        privUser.question1 = o("data")("attributes")("questions")(0)("question")

        privUser.Q1answer1 = o("data")("attributes")("questions")(0)("answers")(0)("answer")
        privUser.Q1answer2 = o("data")("attributes")("questions")(0)("answers")(1)("answer")
        privUser.Q1answer3 = o("data")("attributes")("questions")(0)("answers")(2)("answer")
        privUser.Q1answer4 = o("data")("attributes")("questions")(0)("answers")(3)("answer")
        privUser.Q1answer5 = o("data")("attributes")("questions")(0)("answers")(4)("answer")

        privUser.question2 = o("data")("attributes")("questions")(1)("question")

        privUser.Q2answer1 = o("data")("attributes")("questions")(1)("answers")(0)("answer")
        privUser.Q2answer2 = o("data")("attributes")("questions")(1)("answers")(1)("answer")
        privUser.Q2answer3 = o("data")("attributes")("questions")(1)("answers")(2)("answer")
        privUser.Q2answer4 = o("data")("attributes")("questions")(1)("answers")(3)("answer")
        privUser.Q2answer5 = o("data")("attributes")("questions")(1)("answers")(4)("answer")

        privUser.question3 = o("data")("attributes")("questions")(2)("question")

        privUser.Q3answer1 = o("data")("attributes")("questions")(2)("answers")(0)("answer")
        privUser.Q3answer2 = o("data")("attributes")("questions")(2)("answers")(1)("answer")
        privUser.Q3answer3 = o("data")("attributes")("questions")(2)("answers")(2)("answer")
        privUser.Q3answer4 = o("data")("attributes")("questions")(2)("answers")(3)("answer")
        privUser.Q3answer5 = o("data")("attributes")("questions")(2)("answers")(4)("answer")

        privUser.question4 = o("data")("attributes")("questions")(3)("question")

        privUser.Q4answer1 = o("data")("attributes")("questions")(3)("answers")(0)("answer")
        privUser.Q4answer2 = o("data")("attributes")("questions")(3)("answers")(1)("answer")
        privUser.Q4answer3 = o("data")("attributes")("questions")(3)("answers")(2)("answer")
        privUser.Q4answer4 = o("data")("attributes")("questions")(3)("answers")(3)("answer")
        privUser.Q4answer5 = o("data")("attributes")("questions")(3)("answers")(4)("answer")

        privUser.question5 = o("data")("attributes")("questions")(4)("question")

        privUser.Q5answer1 = o("data")("attributes")("questions")(4)("answers")(0)("answer")
        privUser.Q5answer2 = o("data")("attributes")("questions")(4)("answers")(1)("answer")
        privUser.Q5answer3 = o("data")("attributes")("questions")(4)("answers")(2)("answer")
        privUser.Q5answer4 = o("data")("attributes")("questions")(4)("answers")(3)("answer")
        privUser.Q5answer5 = o("data")("attributes")("questions")(4)("answers")(4)("answer")

        Return privUser
    End Function

    Public Sub PrivQASubmit2() 'cholt 7/24/2020
        Dim bSpanish As Boolean = False
        Dim iLang As Integer = ddlLanguage.SelectedValue
        If iLang > 1 Then
            bSpanish = True
        End If

        Try
            Dim PrivUserID As String
            Dim debug As String = True 'using dev environment for AET
            Dim response As Boolean

            'import current user's ID
            PrivUserID = DataHelper.FieldTop1("tblLeadApplicant", "ProcessorID", "LeadApplicantID = " & aID)

            'hides div
            privicaQApop.Visible = False

            'gets answers from user and assigns to variable
            Dim PrivQ1A As Integer = Request.Form.Item("PrivQ1A")
            Dim privQ2A As Integer = Request.Form.Item("PrivQ2A")
            Dim privQ3A As Integer = Request.Form.Item("PrivQ3A")
            Dim privQ4A As Integer = Request.Form.Item("PrivQ4A")
            Dim privQ5A As Integer = Request.Form.Item("PrivQ5A")

            'sends answers to AET
            Dim questionResponse As Boolean = PrivicaHelper.AnswerQuestions(debug, PrivUserID, PrivQ1A, privQ2A, privQ3A, privQ4A, privQ5A)

            If questionResponse = True Then
                divMsg.Style("display") = ""
                divMsg.InnerText = "Questions were successfully answered!"

                'sleep for 2 seconds to catch response
                Threading.Thread.Sleep(2000)

                'After answering questions, submits for review by AET
                response = PrivicaHelper.RequestReview(debug, PrivUserID)

                If response = True Then
                    'update database with values
                    Dim cmd1 As SqlCommand
                    Dim sql1 As New StringBuilder
                    sql1.Append("update tblLeadApplicant set ")
                    sql1.AppendFormat("LSALocked={0} ", 0)
                    sql1.AppendFormat("where LeadApplicantID={0}", aID)
                    cmd1 = New SqlCommand(sql1.ToString, ConnectionFactory.Create())
                    cmd1.Connection.Open()
                    cmd1.ExecuteNonQuery()
                    cmd1.Connection.Close()

                    'email client login information
                    PrivicaHelper.EmailClientPrivicaAccountInfo(aID, bSpanish)
                Else
                    divMsg.Style("display") = ""
                    divMsg.InnerText = "ERROR: Please screenshot this response and send to IT: RequestReview: " + response.ToString + ", QuestionResponse: " + questionResponse.ToString + ", ProcessorID: " + PrivUserID.ToString + ", function: PrivQASubmit2"
                    Exit Sub
                End If
            Else
                divMsg.Style("display") = ""
                divMsg.InnerText = "Questions failed! Please send identification documents to Privica."
            End If


        Catch ex As Exception
            divMsg.Style("display") = ""
            divMsg.InnerText = "Error has Occurred: " & ex.Message
        End Try
    End Sub



    Public Function ValidateLeadPackage() As String

        Dim response As String = ""
        If Not isValidLead() Then
            response += "Please create a lead.\n"
        End If
        If Not hasValidEmail() Then
            response += "Please provide a valid email address.\n"
        End If
        If Not HasCreditors() Then
            response += "Please provide at least a single creditor.\n"
        End If
        If GetUserCreditReportID(aID) = "" Then
            response += "Please pull a credit report for this lead."
        End If

        Return response
    End Function

    Protected Sub lnkEmailEPackage_Click(sender As Object, e As System.EventArgs) Handles lnkEmailEPackage.Click

        Dim attachments As New List(Of String)
        attachments.Add("\\dc02\leadDocuments\CreditPackage\EBook.pdf")
        EmailHelper.SendMessage("noreply@lawfirmcs.com", txtEmailAddress.Text, "E-Package - ""Budgeting Made Fun""", getEmailBody(), attachments)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantId", aID))
        params.Add(New SqlParameter("PackageSent", "Generic"))
        SqlHelper.ExecuteNonQuery("stp_insertLeadPackageEmailSent", CommandType.StoredProcedure, params.ToArray)

    End Sub

    Protected Sub lnkEmailLeadPackage_Click(sender As Object, e As System.EventArgs) Handles lnkEmailLeadPackage.Click

        Dim remoteUri As String = String.Format("http://service.lexxiom.com/clients/Enrollment/creditpackage/coverpage.aspx?aid={0}", aID)
        Dim remoteUri2 As String = String.Format("http://service.lexxiom.com/clients/Enrollment/creditPackage/termsInService.aspx?aid={0}", aID)
        Dim remoteUri3 As String = "http://service.lexxiom.com/clients/Enrollment/creditPackage/termsInService2.aspx"

        Dim myStringWebResource As String = String.Format("\\dc02\leadDocuments\CreditPackage\coverPage_{0}.html", aID)
        Dim myStringWebResource2 As String = String.Format("\\dc02\leadDocuments\CreditPackage\termsInService_{0}.html", aID)
        Dim myStringWebResource3 As String = String.Format("\\dc02\leadDocuments\CreditPackage\termsInService2_{0}.html", aID)

        Dim Client As New WebClient
        Client.DownloadFile(remoteUri, myStringWebResource)
        Client.DownloadFile(remoteUri2, myStringWebResource2)
        Client.DownloadFile(remoteUri3, myStringWebResource3)
        Client.Dispose()

        Dim pdf1 As String = String.Format("\\dc02\leadDocuments\CreditPackage\coverPage_{0}.pdf", aID)
        Dim pdf2 As String = String.Format("\\dc02\leadDocuments\CreditPackage\termsInService_{0}.pdf", aID)
        Dim pdf3 As String = String.Format("\\dc02\leadDocuments\CreditPackage\termsInService2_{0}.pdf", aID)
        Dim pdf4 As String = "\\dc02\leadDocuments\CreditPackage\TKM-GRAPHS1.pdf"
        Dim pdf5 As String = "\\dc02\leadDocuments\CreditPackage\TKM-GRAPHS2.pdf"
        Dim pdf6 As String = "\\dc02\leadDocuments\CreditPackage\TKM-GRAPHS3.pdf"
        Dim pdf7 As String = String.Format("\\dc02\leadDocuments\{0}.pdf", GetUserCreditReportID(aID))
        Dim pdf8 As String = "\\dc02\leadDocuments\CreditPackage\EBook.pdf"

        'CredStarHelper2.ConvertHtmlLocationToPDF(myStringWebResource, pdf1, Now.ToString)
        'CredStarHelper2.ConvertHtmlLocationToPDF(myStringWebResource2, pdf2, Now.ToString)
        'CredStarHelper2.ConvertHtmlLocationToPDF(myStringWebResource3, pdf3, Now.ToString)

        'Delete html file
        If System.IO.File.Exists(myStringWebResource) Then System.IO.File.Delete(myStringWebResource)
        If System.IO.File.Exists(myStringWebResource2) Then System.IO.File.Delete(myStringWebResource2)
        If System.IO.File.Exists(myStringWebResource3) Then System.IO.File.Delete(myStringWebResource3)

        Dim collectionOfpdfs(7) As String
        collectionOfpdfs(0) = pdf1
        collectionOfpdfs(1) = pdf4
        collectionOfpdfs(2) = pdf5
        collectionOfpdfs(3) = pdf6
        collectionOfpdfs(4) = pdf2
        collectionOfpdfs(5) = pdf3
        collectionOfpdfs(6) = pdf7
        collectionOfpdfs(7) = pdf8

        Dim completePDF As String = String.Format("\\dc02\leadDocuments\CreditPackage\collection_{0}.pdf", aID)
        'PdfManipulation.MergePdfFilesWithBookmarks(collectionOfpdfs, completePDF)

        'Delete pdf file
        If System.IO.File.Exists(pdf1) Then System.IO.File.Delete(pdf1)
        If System.IO.File.Exists(pdf2) Then System.IO.File.Delete(pdf2)
        If System.IO.File.Exists(pdf3) Then System.IO.File.Delete(pdf3)

        Dim attachments As New List(Of String)
        attachments.Add(String.Format("\\dc02\leadDocuments\CreditPackage\collection_{0}.pdf", aID))
        EmailHelper.SendMessage("noreply@lawfirmcs.com", txtEmailAddress.Text, "Custom Package", getEmailBody(), attachments)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantId", aID))
        params.Add(New SqlParameter("PackageSent", "Custom"))
        SqlHelper.ExecuteNonQuery("stp_insertLeadPackageEmailSent", CommandType.StoredProcedure, params.ToArray)

        'If System.IO.File.Exists(completePDF) Then System.IO.File.Delete(completePDF)

    End Sub

    Public Function getEmailBody() As String
        Dim LeadsName As String = txtFirstName.Text
        Dim UserName As String = GetUserName(UserID)

        Dim body As String = ""
        If ddlLanguage.SelectedValue = "2" Then
            body += String.Format("Estimado {0},<br/><br/>", LeadsName)
            body += "Fue un placer hablar con usted hoy sobre su interés en nuestros servicios de resolución de la deuda. "
            body += ". Para su revisión, yo le he incluido su guía personalisada  de deuda incluyendo un approximado de los costos "
            body += "totales y la duración de nuestros servicios basados en sus actuales circunstancias individuales. Recuerde, "
            body += "como una firma de abogados de servicio completo, tenemos varias opciones para ayudarle a resolver "
            body += "sus deudas pendientes y estamos listos para comentarlos con usted cuando usted este disponible.<br/><br/>"

            body += "Si usted esta serio de salir de deudas, nosotros estamos serios en ayudarle. "
            body += "Para empezar es rápido y fácil. Por favor, llámame al 1-800-219-0504. "
            body += "Estoy disponible de 8:00 a 5:00 PM de lunes a viernes y varios de los dias festivos más importantes.<br/><br/>"

            body += "Todos los miembros de la empresa  trabajaran duro para resolver sus deudas en términos aceptables para usted. "
            body += "Espero poder servirle.<br/><br/>"

            body += "Atentamente,<br/>"
            body += String.Format("{0}<br/>", UserName)
            body += "Client Enrollment Specialist<br/>"
            body += "The Law Offices of Thomas Kerns McKnight<br/>"
        Else
            body += String.Format("Dear {0},<br/><br/>", LeadsName)
            body += "It was a pleasure speaking with you today regarding your interest in our Debt Resolution Services. "
            body += "For your review, I have enclosed your personalized debt guide including an outline of the potential total costs "
            body += "and duration of our services based upon your current individual circumstances. Remember, "
            body += "as a full service law firm we have multiple avenues for assisting you in resolving your "
            body += "outstanding debts and are ready to discuss them with you whenever you’d like.<br/><br/>"

            body += "If you are serious about getting out debt, we are serious about helping you. "
            body += "Getting started is fast and easy. Please call me back at 1-800-219-0504. "
            body += "I am available from 8:00 AM to 5:00 PM Monday through Friday and most major holidays.<br/><br/>"

            body += "Every member of the Firm will work hard to resolve your debts on terms acceptable to you. "
            body += "I look forward to serving you.<br/><br/>"

            body += "Very truly yours,<br/>"
            body += String.Format("{0}<br/>", UserName)
            body += "Client Enrollment Specialist<br/>"
            body += "The Law Offices of Thomas Kerns McKnight<br/>"
        End If

        Return body

    End Function

    Public Shared Function GetUserName(ByVal UserID As Integer) As String
        Dim sSQL As String
        Dim UserName As String = ""
        sSQL = "SELECT FirstName, LastName FROM tblUser WHERE UserID = " & UserID
        Using dtUser As DataTable = SqlHelper.GetDataTable(sSQL, CommandType.Text)
            For Each user As DataRow In dtUser.Rows
                UserName = String.Format("{0} {1}", user("firstname").ToString, user("lastname").ToString)
                Exit For
            Next
        End Using
        Return UserName
    End Function

    Public Shared Function GetUserEmail(ByVal UserID As Integer) As String
        Dim sSQL As String
        Dim Email As String = ""
        sSQL = "SELECT EmailAddress FROM tblUser WHERE UserID = " & UserID
        Using dtUser As DataTable = SqlHelper.GetDataTable(sSQL, CommandType.Text)
            For Each user As DataRow In dtUser.Rows
                Email = user("EmailAddress").ToString
                Exit For
            Next
        End Using
        Return Email
    End Function

    Public Shared Function GetUserCreditReportID(ByVal LeadApplicantID As Integer) As String
        Dim sSQL As String
        Dim docid As String = ""
        sSQL = String.Format("SELECT DocumentID FROM tblLeadDocuments WHERE LeadApplicantId = {0} and DocumentTypeID = 9", LeadApplicantID)
        Using dtCreditReport As DataTable = SqlHelper.GetDataTable(sSQL, CommandType.Text)
            For Each doc As DataRow In dtCreditReport.Rows
                docid = doc("DocumentID").ToString
                Exit For
            Next
        End Using
        Return docid
    End Function

    Private Function isValidLead() As Boolean
        If aID = 0 Then
            Return False
        End If
        Return True
    End Function

    Private Function hasValidEmail() As Boolean
        Dim sSQL As String
        Dim Email As String = ""
        sSQL = "SELECT Email FROM tblLeadApplicant WHERE LeadApplicantId = " & aID
        Using dtEmail As DataTable = SqlHelper.GetDataTable(sSQL, CommandType.Text)
            For Each record As DataRow In dtEmail.Rows
                Email = record("Email").ToString
                Exit For
            Next
        End Using
        If Email = "" Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function ConstructFullName(ByVal FirstName As String, ByVal MiddleName As String, ByVal LastName As String) As String
        Dim fullname As String = ""

        fullname += StrConv(FirstName.Trim, VbStrConv.ProperCase) + " "
        If MiddleName <> "" Then
            fullname += StrConv(MiddleName.Trim, VbStrConv.ProperCase) + " "
        End If
        fullname += StrConv(LastName.Trim, VbStrConv.ProperCase)

        Return fullname
    End Function

    Private Function GetLSAVersion(CompanyId As Integer) As String
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CompanyId", CompanyId))
        params.Add(New SqlParameter("AgencyId", AgencyID))
        Return CStr(SqlHelper.ExecuteScalar("stp_GetLSAVersionPerCompany", CommandType.StoredProcedure, params.ToArray))
    End Function

    Private Function GetDefaultProcessingPattern() As String
        Return CStr(SqlHelper.ExecuteScalar("stp_GetDefaultProcessingPattern", CommandType.StoredProcedure))
    End Function

    Private Function ChangeProcessingPattern(productId As String) As String
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("ProductId", productId))
        Return CStr(SqlHelper.ExecuteScalar("stp_GetProductProcessingPattern", CommandType.StoredProcedure, params.ToArray))
    End Function

#End Region

    Protected Sub cboStateID_Load(sender As Object, e As System.EventArgs) Handles cboStateID.Load
        CheckState()
    End Sub

    Protected Sub cboStateID_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles cboStateID.SelectedIndexChanged
        CheckState()
    End Sub 'Methods

    Protected Sub CheckState()
        If Not cboStateID.SelectedItem.Text = "" Then
            If Not SmartDebtorHelper.ValidLawFirmState(cboStateID.SelectedItem.Text, ddlCompany.SelectedValue) Then
                divMsg.Style("display") = ""
                divMsg.InnerHtml &= String.Format("We don't accept clients from {0} anymore", cboStateID.SelectedItem.Text)
            Else
                divMsg.Style("display") = "none"
                divMsg.InnerHtml &= ""
            End If
        End If
    End Sub

    Private Sub lnkPrivicaQA_Click(sender As Object, e As EventArgs) Handles lnkPrivicaQA.Click 'cholt 7/24/2020
        CreatePrivUser()
    End Sub

    Private Sub lnkPrivQASubmit_Click(sender As Object, e As EventArgs) Handles PrivQASubmit.Click 'cholt 7/24/2020
        PrivQASubmit2()
    End Sub

    Private Sub lnkPrivicaResendEmail_Click(sender As Object, e As EventArgs) Handles lnkPrivicaResendEmail.Click 'cholt 9/24/2020
        Dim bSpanish As Boolean = False
        Dim iLang As Integer = ddlLanguage.SelectedValue
        If iLang > 1 Then
            bSpanish = True
        End If

        PrivicaHelper.EmailClientPrivicaAccountInfo(aID, bSpanish)

        divMsg.Style("display") = ""
        divMsg.InnerText = "Email Sent"
    End Sub

    Private Sub lnkPrivicaSendBankVerification_Click(sender As Object, e As EventArgs) Handles lnkPrivicaSendBankVerification.Click

        'get dt for document info
        Dim myparams As New List(Of SqlParameter)
        myparams.Add(New SqlParameter("leadApplicantID", aID))
        Dim dt As New DataTable

        'get document id
        dt = SqlHelper.GetDataTable("stp_enrollment_leaddocuments_bankverification", CommandType.StoredProcedure, myparams.ToArray())
        Dim documentId = dt.Rows(0)("documentid")

        Dim path As String = "C:\lsasigning\tmp\" & String.Format("{0}.pdf", documentId)

        'get privica account id
        Dim accID = DataHelper.FieldLookup("tblleadapplicant", "accountID", "leadapplicantid =" & aID)
        Dim processorid = DataHelper.FieldLookup("tblleadapplicant", "ProcessorID", "leadapplicantid =" & aID)

        'report if upload was success
        Dim success = PrivicaHelper.UploadBankDocument(processorid, accID, path, "TruthInStatement", "Bank Verification", "Truth In Statement")

        If success Then
            divMsg.Style("display") = ""
            divMsg.InnerText = "Document Sent"
        Else
            divMsg.Style("display") = ""
            divMsg.InnerText = "Document Failed."
        End If
    End Sub
End Class
