Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Text
Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_workflows_26
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private TaskID As Integer
    Private qs As QueryStringCollection
    Private UserID As Integer
    Public ClientID As Int64
    Private MatterID As Int64
    Private AccountID As Int64
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        cmbAssets.Attributes.Add("onchange", "javascript: ShowAssets()")
        cmbWorking.Attributes.Add("onchange", "javascript: ShowIncome()")
        cmbWage.Attributes.Add("onchange", "javascript: ShowWages()")
        cmbAid.Attributes.Add("onchange", "javascript: ShowAid()")
        ' cmbRealEstatePre.Attributes.Add("onchange", "javascript: ShowRealEstate()")
        cmbBankAcc.Attributes.Add("onchange", "javascript: ShowBankAcc()")
        chkLegalServices.Attributes.Add("onClick", "javascript: ShowVerified()")
        chkLocalCounsel.Attributes.Add("onClick", "javascript: ShowLocalCouncel()")
        cmbAid.Attributes.Add("onchange", "javascript: ShowIR()")
        chkr1.Attributes.Add("onClick", "javascript: ShowAmount(1)")
        chkr2.Attributes.Add("onClick", "javascript: ShowAmount(2)")
        chkr3.Attributes.Add("onClick", "javascript: ShowAmount(3)")
        chkr4.Attributes.Add("onClick", "javascript: ShowAmount(4)")

        txtOwnyears.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtMarketVal.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtEquity.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtPayoff.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtOwnyears2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtMarketVal2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtPayoff2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtEquity2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtExpAtEmployer.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtTakeHome.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtExpAtEmployerMonths.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtAmmount.Attributes("onkeypress") = "AllowOnlyNumbers(this);"


        cmbResidence.Attributes.Add("onchange", "javascript: ShowResidence1()")
        cmbRental1.Attributes.Add("onchange", "javascript: ShowRental1()")

        cmbResidence2.Attributes.Add("onchange", "javascript: ShowResidence2()")
        cmbRental2.Attributes.Add("onchange", "javascript: ShowRental2()")

        txtRent1.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtRent2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        '  txtIR.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtr1.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtr2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtr3.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtr4.Attributes("onkeypress") = "AllowOnlyNumbers(this);"

        txtTotalPeople.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtTotalPeople2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"

        ' txtSource.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtBalance.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        ' txtSource2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtBalance2.Attributes("onkeypress") = "AllowOnlyNumbers(this);"


        qs = LoadQueryString()
        If Not qs Is Nothing Then
            TaskID = DataHelper.Nz_int(qs("id"), 0)
            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "select ci.accountid, m.matterid, m.clientid from tblmattertask mt, tblmatter m, tblcreditorinstance ci" & _
            " Where mt.matterid=m.matterid and m.creditorinstanceid=ci.creditorinstanceid and mt.taskid=@TaskID "
            DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then
                    MatterID = DatabaseHelper.Peel_int(rd, "matterid")
                    AccountID = DatabaseHelper.Peel_int(rd, "accountid")
                    ClientID = DatabaseHelper.Peel_int(rd, "clientid")
                End If
                rd.Close()
            Catch
            End Try

            If Not IsPostBack Then
                LoadClients()
                Me.txtDateClientReceivedDocument.Value = Now
                LoadAssignedTo(cmbVerifiedBy, 0)
                LoadCompanies(cmbFeepaidtype, 0)
                LoadRecord(ClientID)
            End If
        End If

    End Sub
    Private Sub LoadClients()

        cmbClients.Items.Clear()
        cmbClients.Items.Add(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "stp_GetPersonsForClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") + " " + DatabaseHelper.Peel_string(rd, "LastName")
                        Dim Email As String = DatabaseHelper.Peel_string(rd, "EmailAddress")

                        cmbClients.Items.Add(New ListItem(Name, Name))
                    End While
                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadRecord(ByVal iClientID As Int64)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()


        cmd.CommandText = "select tp.firstname,tp.lastname,  tcm.name,tp.EmailAddress, " & _
      " tpn.areacode , tpn.number , tpn.extension, tc.primarypersonid," & _
      " tp.street, tp.city as webcity,   tblstate.name statename , tp.zipcode as webzipcode, tc.SDABalance " & _
       " from  tblcompany tcm, tblperson tp   left outer join tblstate on  tp.webstateid=tblstate.stateid , tblClient tc  left outer join" & _
      " tblPersonPhone tpp on tc.primarypersonid=tpp.personid left outer join" & _
      " tblphone tpn on tpp.phoneid=tpn.phoneid   " & _
       "  where(tc.clientid = @ClientID And tc.primarypersonid = tp.personid)" & _
      " and tc.companyid=tcm.companyid "
        DatabaseHelper.AddParameter(cmd, "ClientID", iClientID)
        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                txtFirm.Text = DatabaseHelper.Peel_string(rd, "name")

                cmbClients.SelectedIndex = cmbClients.Items.IndexOf(cmbClients.Items.FindByValue(DatabaseHelper.Peel_string(rd, "firstname") & " " & DatabaseHelper.Peel_string(rd, "lastname")))
                ' txtClientName.Text = DatabaseHelper.Peel_string(rd, "firstname") & " " & DatabaseHelper.Peel_string(rd, "lastname")
                txtAddress1.Text = DatabaseHelper.Peel_string(rd, "street")
                txtAddress2.Text = DatabaseHelper.Peel_string(rd, "webcity") & IIf(DatabaseHelper.Peel_string(rd, "statename").Trim() <> "", ",", "") & DatabaseHelper.Peel_string(rd, "statename") & IIf(DatabaseHelper.Peel_string(rd, "webzipcode").Trim() <> "", ",", "") & DatabaseHelper.Peel_string(rd, "webzipcode")
                txtEmail.Text = DatabaseHelper.Peel_string(rd, "EmailAddress")
                txtPhone.Text = DatabaseHelper.Peel_string(rd, "areacode") + "-" + DatabaseHelper.Peel_string(rd, "number")
                'txtSDA.Text = DatabaseHelper.Peel_double(rd, "SDABalance").ToString("$#,##0.00")
                txtSDA.Text = DatabaseHelper.Peel_double(rd, "SDABalance")

                'txtDateOfBirth.Text = DatabaseHelper.Peel_datestring(rd, "DateOfBirth")
                'ListHelper.SetSelected(cboGender, DatabaseHelper.Peel_string(rd, "Gender"))
                'ListHelper.SetSelected(cboLanguageID, DatabaseHelper.Peel_int(rd, "LanguageID"))
            End If
            rd.Close()
            'cmd.CommandText = "select * from tblmatter where matterid=@MatterID"
            cmd.CommandText = "select m.MatterId, c.ClientId, c.AccountNumber,m.CreditorInstanceId, m.matternumber from tblMatter m left join  tblClient c on c.ClientId=m.ClientId" + _
                              " where MatterID=@MatterId"
            DatabaseHelper.AddParameter(cmd, "MatterID", MatterID)
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
            If rd.Read() Then
                txtAccNo.Text = DatabaseHelper.Peel_string(rd, "MatterNumber")
            End If
            rd.Close()
            ' This one does not display account number    
            'cmd.CommandText = "select tc.AccountNumber, tc.Amount from tblMatter tm, tblCreditorInstance tc " & _
            '                    " where tm.matterid=@MatterId and tm.CreditorInstanceID=tc.CreditorInstanceID"
            'DatabaseHelper.AddParameter(cmd, "MatterId", MatterID)

            ' checking the account number by referencing the current creditor instance Id US 12/21/2009
            cmd.CommandText = "select a.AccountId,a.ClientId,ci.CreditorInstanceId,ci.AccountNumber,a.CurrentAmount,*  from " & _
                              "tblAccount a left join tblCreditorInstance ci on ci.CreditorInstanceId=a.CurrentCreditorInstanceId  " & _
                              "where a.ClientId=@ClientId and a.AccountId=@AccountId"
            DatabaseHelper.AddParameter(cmd, "AccountId", AccountID)

            'cmd.CommandText = "select tc.AccountNumber, tc.Amount from tblCreditorInstance tc " & _
            '                  " where tc.CreditorInstanceID=@CreditorInstanceID"
            'DatabaseHelper.AddParameter(cmd, "CreditorInstanceID", CreditorInstanceID)

            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
            If rd.Read() Then
                'txtAccNo.Text = DatabaseHelper.Peel_string(rd, "accountnumber")
                'txtAmmount.Text = DatabaseHelper.Peel_double(rd, "Amount").ToString("$#,##0.00")
                'txtAmmount.Text = DatabaseHelper.Peel_double(rd, "Amount")
            End If
            rd.Close()
            cmd.CommandText = "select  * from tblclientintakeform where accountid = @Accountid"
            'DatabaseHelper.AddParameter(cmd, "Accountid", AccountID)
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
            If rd.Read() Then
                txtplantiff.Text = DatabaseHelper.Peel_string(rd, "whoisplantiff")
                If Not IsDBNull(rd("ClientName")) Then
                    'If Not IsDBNull(rd("ClientName")) Then
                    cmbClients.SelectedIndex = cmbClients.Items.IndexOf(cmbClients.Items.FindByValue(DatabaseHelper.Peel_string(rd, "ClientName")))
                    'End If
                End If

                If IsDBNull(rd("LastModifiedDatetime")) Then
                    If Not IsDBNull(rd("CreatedDatetime")) Then
                        lbLastModifiedDate.Text = rd("CreatedDatetime")
                    End If
                Else
                    lbLastModifiedDate.Text = DatabaseHelper.Peel_ndate(rd, "LastModifiedDatetime")
                End If


                If IsDBNull(rd("LastModifiedBy")) Then
                    If Not IsDBNull(rd("CreatedBy")) Then
                        lbLastModified.Text = DataHelper.FieldLookup("tblUser", "FirstName", "UserId=" & DatabaseHelper.Peel_int(rd, "CreatedBy")) & _
                                              " " + DataHelper.FieldLookup("tblUser", "LastName", "UserId=" & DatabaseHelper.Peel_int(rd, "CreatedBy"))
                    End If
                Else
                    lbLastModified.Text = DataHelper.FieldLookup("tblUser", "FirstName", "UserId=" & DatabaseHelper.Peel_int(rd, "LastModifiedBy")) & _
                                          " " + DataHelper.FieldLookup("tblUser", "LastName", "UserId=" & DatabaseHelper.Peel_int(rd, "LastModifiedBy"))
                End If

                If DatabaseHelper.Peel_bool(rd, "IsVerified") Then
                    ChkFormVeirified.Checked = True
                Else
                    ChkFormVeirified.Checked = False
                End If

                txtAmmount.Text = DatabaseHelper.Peel_double(rd, "Amount")
                txtPhone.Text = DatabaseHelper.Peel_string(rd, "Phone")
                ddlLDocument.SelectedIndex = ddlLDocument.Items.IndexOf(ddlLDocument.Items.FindByValue(DatabaseHelper.Peel_string(rd, "LitigationDocument")))
                txtDateClientReceivedDocument.Value = DatabaseHelper.Peel_ndate(rd, "ClientDocReceivedDate")
                cmbRecType.SelectedIndex = cmbRecType.Items.IndexOf(cmbRecType.Items.FindByValue(DatabaseHelper.Peel_string(rd, "HowDocReceived")))
                If DatabaseHelper.Peel_bool(rd, "IsPlaintiffCompany") Then
                    cmbplaintiff.SelectedIndex = 1
                Else
                    cmbplaintiff.SelectedIndex = 2
                End If
                If DatabaseHelper.Peel_bool(rd, "IsAmountDispute") Then
                    cmbAmtDispute.SelectedIndex = 1
                Else
                    cmbAmtDispute.SelectedIndex = 2
                End If
                'If DatabaseHelper.Peel_bool(rd, "IsRealestateOwner") Then
                '    cmbRealEstatePre.SelectedIndex = 1
                tabREstate.Style.Add("display", "block")

                If DatabaseHelper.Peel_bool(rd, "IsresidenceofPropertyOne") Then
                    ' tabREstate.Style.Add("display", "block")
                    tabPro1.Style.Add("display", "block")

                    cmbResidence.SelectedIndex = 1

                    txtOwnyears.Text = DatabaseHelper.Peel_int(rd, "DurationOwnerdPropertyOne")

                    If DatabaseHelper.Peel_decimal(rd, "AppMarketvalPropertyOne") >= 0 Then
                        txtMarketVal.Text = DatabaseHelper.Peel_decimal(rd, "AppMarketvalPropertyOne")
                        chkMarketVal.Checked = False
                    Else
                        chkMarketVal.Checked = True
                        txtMarketVal.Text = ""
                        txtMarketVal.Enabled = False
                    End If

                    txtPayoff.Text = DatabaseHelper.Peel_double(rd, "PayoffPropertyOne")
                    If DatabaseHelper.Peel_bool(rd, "LiensOnPropertyOne") Then
                        cmbLiens.SelectedIndex = 1
                    Else
                        cmbLiens.SelectedIndex = 2
                    End If
                    txtEquity.Text = DatabaseHelper.Peel_double(rd, "TotalEquityPropertyOne")
                    cmbPayments.SelectedIndex = cmbPayments.Items.IndexOf(cmbPayments.Items.FindByValue(DatabaseHelper.Peel_string(rd, "HousePaymentsPropertyOne")))
                    'txtPayments.Text = DatabaseHelper.Peel_string(rd, "HousePaymentsPropertyOne")

                    txtTotalPeople.Text = DatabaseHelper.Peel_string(rd, "PeopleLivePropertyOne")
                Else
                    cmbResidence.SelectedIndex = 2

                    tabPro1No.Style.Add("display", "block")

                    If DatabaseHelper.Peel_bool(rd, "IsRentalPropertyOne") Then
                        dv1p1.Style.Add("display", "block")
                        dv2p1.Style.Add("display", "block")
                        cmbRental1.SelectedIndex = 1
                        txtRent1.Text = DatabaseHelper.Peel_double(rd, "RentOnPropertyOne")
                    Else
                        cmbRental1.SelectedIndex = 2
                    End If
                End If


                If DatabaseHelper.Peel_bool(rd, "IsresidenceofPropertyTwo") Then
                    cmbResidence2.SelectedIndex = 1

                    tabPro2No.Style.Add("display", "block")
                    If DatabaseHelper.Peel_bool(rd, "IsRentalPropertyTwo") Then

                        dv1p2.Style.Add("display", "block")
                        dv2p2.Style.Add("display", "block")
                        cmbRental2.SelectedIndex = 1
                        txtRent2.Text = DatabaseHelper.Peel_double(rd, "RentOnPropertyTwo")
                    Else
                        tabPro2.Style.Add("display", "block")
                        cmbRental2.SelectedIndex = 2
                        txtOwnyears2.Text = DatabaseHelper.Peel_int(rd, "DurationOwnerdPropertyTwo")

                        If DatabaseHelper.Peel_decimal(rd, "AppMarketvalPropertyTwo") >= 0 Then
                            txtMarketVal2.Text = DatabaseHelper.Peel_decimal(rd, "AppMarketvalPropertyTwo")
                            chkMarketVal2.Checked = False
                        Else
                            chkMarketVal2.Checked = True
                            txtMarketVal2.Text = ""
                            txtMarketVal2.Enabled = False
                        End If

                        txtPayoff2.Text = DatabaseHelper.Peel_double(rd, "PayoffPropertyTwo")

                        If DatabaseHelper.Peel_bool(rd, "LiensOnPropertyTwo") Then
                            cmbLiens2.SelectedIndex = 1
                        Else
                            cmbLiens2.SelectedIndex = 2
                        End If
                        txtEquity2.Text = DatabaseHelper.Peel_double(rd, "TotalEquityPropertyTwo")

                        ' txtPayments2.Text = DatabaseHelper.Peel_string(rd, "HousePaymentsPropertyTwo")
                        cmbPayments2.SelectedIndex = cmbPayments2.Items.IndexOf(cmbPayments2.Items.FindByValue(DatabaseHelper.Peel_string(rd, "HousePaymentsPropertyTwo")))


                        txtTotalPeople2.Text = DatabaseHelper.Peel_string(rd, "PeopleLivePropertyTwo")


                    End If

                Else
                    cmbResidence2.SelectedIndex = 2
                    ' tabPro2No.Style.Add("display", "block")
                    'If DatabaseHelper.Peel_bool(rd, "IsRentalPropertyTwo") Then
                    '    dv1p2.Style.Add("display", "block")
                    '    dv2p2.Style.Add("display", "block")
                    '    cmbRental2.SelectedIndex = 1
                    '    txtRent2.Text = DatabaseHelper.Peel_double(rd, "RentOnPropertyTwo")
                    'Else
                    '    cmbRental2.SelectedIndex = 2
                    'End If
                End If
                'Else
                '    cmbRealEstatePre.SelectedIndex = 2
                'End If

                If DatabaseHelper.Peel_bool(rd, "IsCurrentlyWorking") Then
                    cmbWorking.SelectedIndex = 1
                    tabIncome.Style.Add("display", "block")

                    If Not IsDBNull(rd("IsSelfEmployed")) Then
                        If DatabaseHelper.Peel_bool(rd, "IsSelfEmployed") Then
                            cmbSelfEmp.SelectedIndex = 1
                        Else
                            cmbSelfEmp.SelectedIndex = 2
                        End If
                    End If

                    txtEmployer.Text = DatabaseHelper.Peel_string(rd, "EmployerName")

                    txtExpAtEmployer.Text = System.Math.Round(DatabaseHelper.Peel_int(rd, "CurrentEmployerDuration") / 12)
                    Dim irem As Int32 = 0
                    System.Math.DivRem(DatabaseHelper.Peel_int(rd, "CurrentEmployerDuration"), 12, irem)
                    txtExpAtEmployerMonths.Text = irem
                    txtTakeHome.Text = System.Math.Round(DatabaseHelper.Peel_decimal(rd, "Takehomepay"), 2)
                    cmbPer.SelectedIndex = cmbPer.Items.IndexOf(cmbPer.Items.FindByValue(DatabaseHelper.Peel_string(rd, "Per")))
                    'txtWage.Text = DatabaseHelper.Peel_string(rd, "Otherwage")
                    cmbWage.Text = DatabaseHelper.Peel_string(rd, "Otherwage")
                    If cmbWage.Text = "Yes" Then
                        txtGarnishmentVal.Text = DatabaseHelper.Peel_string(rd, "WageVal")
                    Else
                        txtGarnishmentVal.Text = ""
                    End If
                    txtOtherIncome.Text = DatabaseHelper.Peel_string(rd, "OtherIncomeSource")
                Else
                    cmbWorking.SelectedIndex = 2
                    tabNoIncome.Style.Add("display", "block")

                    If DatabaseHelper.Peel_bool(rd, "IsReceivingAid") Then
                        cmbAid.SelectedIndex = 1
                        ' dvAidType.Style.Add("display", "block")
                        'dvIR.Style.Add("display", "block")
                        'Dim strAidTypes As String() = DatabaseHelper.Peel_string(rd, "TypeOfAid").Split(",")
                        'Dim itemindex As Int32 = 0
                        'For itemindex = 0 To cmbAidType.Items.Count - 1
                        '    Dim iteminnerindex As Int32 = 0
                        '    For iteminnerindex = 0 To strAidTypes.Length - 1
                        '        If cmbAidType.Items(itemindex).Text.Trim() = strAidTypes(iteminnerindex) Then
                        '            cmbAidType.Items(itemindex).Selected = True
                        '            Exit For
                        '        End If
                        '    Next
                        'Next itemindex
                        If DatabaseHelper.Peel_string(rd, "TypeOfAid") = "Yes" Then
                            chkr1.Checked = True
                        End If
                        If chkr1.Checked Then
                            txtr1.Text = DatabaseHelper.Peel_double(rd, "IReceived")
                        End If

                        If DatabaseHelper.Peel_string(rd, "TypeOfAidPension") = "Yes" Then
                            chkr2.Checked = True
                        End If
                        If chkr2.Checked Then
                            txtr2.Text = DatabaseHelper.Peel_double(rd, "AmtReceivedPension")
                        End If

                        If DatabaseHelper.Peel_string(rd, "TypeOfAidUnemp") = "Yes" Then
                            chkr3.Checked = True
                        End If
                        If chkr3.Checked Then
                            txtr3.Text = DatabaseHelper.Peel_double(rd, "AmtReceivedUnemp")
                        End If

                        If DatabaseHelper.Peel_string(rd, "TypeOfAidRetire") = "Yes" Then
                            chkr4.Checked = True
                        End If
                        If chkr4.Checked Then
                            txtr4.Text = DatabaseHelper.Peel_double(rd, "AmtReceivedRetire")
                        End If
                        'cmbAidType.SelectedIndex = cmbAidType.Items.IndexOf(cmbAidType.Items.FindByValue(DatabaseHelper.Peel_string(rd, "TypeOfAid")))
                        'If cmbAidType.SelectedValue = "Retirement" Then
                        '    txtIR.Text = DatabaseHelper.Peel_string(rd, "IReceived")
                        '    dvIR.Style.Add("display", "block")
                        'End If
                    Else
                        cmbAid.SelectedIndex = 2
                        '  dvAidType.Style.Add("display", "none")
                        ' dvIR.Style.Add("display", "none")
                    End If


                End If
                'If DatabaseHelper.Peel_bool(rd, "AnyAccount") Then
                '    cmbAccount.SelectedIndex = 1
                'Else
                '    cmbAccount.SelectedIndex = 2
                'End If

                If DatabaseHelper.Peel_bool(rd, "HaveBankAccs") Then
                    cmbBankAcc.SelectedIndex = 1
                    tabBankAcc.Style.Add("display", "block")
                    txtBankName.Text = DatabaseHelper.Peel_string(rd, "BankAccOne")
                    txtSource.Text = DatabaseHelper.Peel_string(rd, "BankAmtSourceAccOne")
                    txtBalance.Text = DatabaseHelper.Peel_double(rd, "AppBalanceAccOne")
                    If Not IsDBNull(rd("AccTypeOne")) Then
                        radAccountType.SelectedIndex = radAccountType.Items.IndexOf(radAccountType.Items.FindByValue(rd("AccTypeOne")))
                    End If

                    txtBankName2.Text = DatabaseHelper.Peel_string(rd, "BankAccTwo")
                    txtSource2.Text = DatabaseHelper.Peel_string(rd, "BankAmtSourceAccTwo")
                    txtBalance2.Text = DatabaseHelper.Peel_double(rd, "AppBalanceAccTwo")
                    If Not IsDBNull(rd("AccTypeTwo")) Then
                        radAccountType2.SelectedIndex = radAccountType2.Items.IndexOf(radAccountType2.Items.FindByValue(rd("AccTypeTwo")))
                    End If
                    txtLevies1.Text = DatabaseHelper.Peel_string(rd, "levies1")
                    txtLevies2.Text = DatabaseHelper.Peel_string(rd, "levies2")
                    'txtBankName3.Text = DatabaseHelper.Peel_string(rd, "BankAccThree")
                    'txtSource3.Text = DatabaseHelper.Peel_string(rd, "BankAmtSourceAccThree")
                    'txtBalance3.Text = DatabaseHelper.Peel_string(rd, "AppBalanceAccThree")
                Else
                    cmbBankAcc.SelectedIndex = 2
                End If
                If DatabaseHelper.Peel_bool(rd, "HaveOtherAssets") Then
                    cmbAssets.SelectedIndex = 1
                    txtAssets.Text = DatabaseHelper.Peel_string(rd, "Assets")
                    dvAssets.Style.Add("display", "block")
                    dvAssets1.Style.Add("display", "block")
                Else
                    cmbAssets.SelectedIndex = 2
                End If

                If DatabaseHelper.Peel_bool(rd, "DeclinedLegalServices") Then
                    chkLegalServices.Checked = True
                    dvVerifiedBy1.Style.Add("display", "block")
                    cmbVerifiedBy.SelectedIndex = cmbVerifiedBy.Items.IndexOf(cmbVerifiedBy.Items.FindByValue(DatabaseHelper.Peel_int(rd, "LegalServicesClientID")))
                Else
                    chkLegalServices.Checked = False
                End If
                If DatabaseHelper.Peel_bool(rd, "SentLocalCounsel") Then
                    chkLocalCounsel.Checked = True
                    dvLocalCounsel1.Style.Add("display", "block")
                    cmbFeepaidtype.SelectedIndex = cmbFeepaidtype.Items.IndexOf(cmbFeepaidtype.Items.FindByValue(DatabaseHelper.Peel_int(rd, "FeePaidBy")))
                Else
                    chkLocalCounsel.Checked = False
                End If

                txtSDADesc.Text = DatabaseHelper.Peel_string(rd, "Notes")


            End If
            rd.Close()
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Private Sub Close()
        'Response.Redirect("~/tasks/task/?id=" & ClientID)
        Response.Redirect("~/default.aspx")
    End Sub
    Private Sub InsertOrUpdate()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_InsertClientIntake"
                cmd.CommandType = CommandType.StoredProcedure
                'DatabaseHelper.AddParameter(cmd, "CreditorInstanceID", CreditorInstanceID)
                DatabaseHelper.AddParameter(cmd, "Amount", txtAmmount.Text)

                DatabaseHelper.AddParameter(cmd, "Phone", txtPhone.Text)

                DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                DatabaseHelper.AddParameter(cmd, "MatterID", MatterID)

                DatabaseHelper.AddParameter(cmd, "IntakeFormDate", System.DateTime.Now)
                DatabaseHelper.AddParameter(cmd, "LitigationDocument", ddlLDocument.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "ClientDocReceivedDate", DateTime.Parse(txtDateClientReceivedDocument.Value))
                DatabaseHelper.AddParameter(cmd, "HowDocReceived", cmbRecType.SelectedValue)

                If cmbplaintiff.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "IsPlaintiffCompany", 1)
                Else
                    DatabaseHelper.AddParameter(cmd, "IsPlaintiffCompany", 0)
                End If

                If cmbAmtDispute.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "IsAmountDispute", 1)
                Else
                    DatabaseHelper.AddParameter(cmd, "IsAmountDispute", 0)
                End If
                'If cmbRealEstatePre.SelectedIndex = 1 Then
                DatabaseHelper.AddParameter(cmd, "IsRealestateOwner", 1)

                If cmbResidence.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyOne", 1)

                    DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyOne", txtOwnyears.Text)

                    'DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", txtMarketVal.Text)
                    If chkMarketVal.Checked = False Then
                        If txtMarketVal.Text.Trim() = "" Then
                            DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", 0)
                        Else
                            DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", txtMarketVal.Text)
                        End If
                    Else
                        DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", -1)
                    End If

                    DatabaseHelper.AddParameter(cmd, "PayoffPropertyOne", txtPayoff.Text)
                    If cmbLiens.SelectedIndex = 1 Then
                        DatabaseHelper.AddParameter(cmd, "LiensOnPropertyOne", 1)
                    Else
                        DatabaseHelper.AddParameter(cmd, "LiensOnPropertyOne", 0)
                    End If
                    DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyOne", txtEquity.Text)
                    'DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyOne", txtPayments.Text)
                    DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyOne", cmbPayments.SelectedValue)
                    DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyOne", txtTotalPeople.Text)




                Else
                    DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyOne", 0)
                    DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyOne", 0)
                    DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", 0)
                    DatabaseHelper.AddParameter(cmd, "PayoffPropertyOne", "")
                    DatabaseHelper.AddParameter(cmd, "LiensOnPropertyOne", 0)
                    DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyOne", "")
                    DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyOne", "")
                    DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyOne", "")

                    If cmbRental1.SelectedIndex = 1 Then
                        DatabaseHelper.AddParameter(cmd, "IsRentalPropertyOne", 1)
                        DatabaseHelper.AddParameter(cmd, "RentOnPropertyOne", txtRent1.Text)

                    Else
                        DatabaseHelper.AddParameter(cmd, "IsRentalPropertyOne", 0)
                    End If

                End If

                If cmbResidence2.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyTwo", 1)


                    If cmbRental2.SelectedIndex = 1 Then
                        DatabaseHelper.AddParameter(cmd, "IsRentalPropertyTwo", 1)
                        If txtRent2.Text.Trim() = "" Then
                            DatabaseHelper.AddParameter(cmd, "RentOnPropertyTwo", 0)

                        Else
                            DatabaseHelper.AddParameter(cmd, "RentOnPropertyTwo", txtRent2.Text)

                        End If
                        DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyTwo", 0)
                        DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", 0)
                        DatabaseHelper.AddParameter(cmd, "PayoffPropertyTwo", "")
                        DatabaseHelper.AddParameter(cmd, "LiensOnPropertyTwo", 0)
                        DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyTwo", "")
                        DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyTwo", "")
                        DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyTwo", "")

                    Else
                        DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyTwo", txtOwnyears2.Text)
                        If chkMarketVal2.Checked = False Then
                            If txtMarketVal2.Text.Trim() = "" Then
                                DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", 0)
                            Else
                                DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", txtMarketVal2.Text)
                            End If
                        Else
                            DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", -1)
                        End If

                        DatabaseHelper.AddParameter(cmd, "PayoffPropertyTwo", txtPayoff2.Text)
                        If cmbLiens2.SelectedIndex = 1 Then
                            DatabaseHelper.AddParameter(cmd, "LiensOnPropertyTwo", 1)
                        Else
                            DatabaseHelper.AddParameter(cmd, "LiensOnPropertyTwo", 0)
                        End If
                        DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyTwo", txtEquity2.Text)
                        'DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyTwo", txtPayments2.Text)
                        DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyTwo", cmbPayments2.SelectedValue)

                        DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyTwo", txtTotalPeople2.Text)


                        DatabaseHelper.AddParameter(cmd, "IsRentalPropertyTwo", 0)
                        'DatabaseHelper.AddParameter(cmd, "RentOnPropertyTwo", 0)
                    End If

                Else
                    DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyTwo", 0)
                    DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyTwo", 0)
                    DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", 0)
                    DatabaseHelper.AddParameter(cmd, "PayoffPropertyTwo", "")
                    DatabaseHelper.AddParameter(cmd, "LiensOnPropertyTwo", 0)
                    DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyTwo", "")
                    DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyTwo", "")
                    DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyTwo", "")

                    DatabaseHelper.AddParameter(cmd, "IsRentalPropertyTwo", 0)
                    DatabaseHelper.AddParameter(cmd, "RentOnPropertyTwo", 0)

                    'If cmbRental2.SelectedIndex = 1 Then
                    '    DatabaseHelper.AddParameter(cmd, "IsRentalPropertyTwo", 1)
                    '    DatabaseHelper.AddParameter(cmd, "RentOnPropertyTwo", txtRent2.Text)

                    'Else
                    '    DatabaseHelper.AddParameter(cmd, "IsRentalPropertyTwo", 0)
                    'End If

                End If
                'Else
                'DatabaseHelper.AddParameter(cmd, "IsRealestateOwner", 0)

                'DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyOne", 0)
                'DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyOne", 0)
                'DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyOne", 0)
                'DatabaseHelper.AddParameter(cmd, "PayoffPropertyOne", "")
                'DatabaseHelper.AddParameter(cmd, "LiensOnPropertyOne", 0)
                'DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyOne", "")
                'DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyOne", "")
                'DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyOne", "")

                'DatabaseHelper.AddParameter(cmd, "IsresidenceofPropertyTwo", 0)
                'DatabaseHelper.AddParameter(cmd, "DurationOwnerdPropertyTwo", 0)
                'DatabaseHelper.AddParameter(cmd, "AppMarketvalPropertyTwo", 0)
                'DatabaseHelper.AddParameter(cmd, "PayoffPropertyTwo", "")
                'DatabaseHelper.AddParameter(cmd, "LiensOnPropertyTwo", 0)
                'DatabaseHelper.AddParameter(cmd, "TotalEquityPropertyTwo", "")
                'DatabaseHelper.AddParameter(cmd, "HousePaymentsPropertyTwo", "")
                'DatabaseHelper.AddParameter(cmd, "PeopleLivePropertyTwo", "")
                'End If
                If cmbWorking.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "IsCurrentlyWorking", 1)
                    If cmbSelfEmp.SelectedValue = "Yes" Then
                        DatabaseHelper.AddParameter(cmd, "IsSelfEmployed", 1)
                    Else
                        DatabaseHelper.AddParameter(cmd, "IsSelfEmployed", 0)
                    End If
                    DatabaseHelper.AddParameter(cmd, "EmployerName", txtEmployer.Text)
                    Dim iTotalDurationInMonths As Int32 = 0
                    If txtExpAtEmployer.Text <> "" Then
                        iTotalDurationInMonths = iTotalDurationInMonths + (txtExpAtEmployer.Text * 12)
                    End If
                    If txtExpAtEmployerMonths.Text <> "" Then
                        iTotalDurationInMonths = iTotalDurationInMonths + txtExpAtEmployerMonths.Text
                    End If
                    'DatabaseHelper.AddParameter(cmd, "CurrentEmployerDuration", txtExpAtEmployer.Text)
                    DatabaseHelper.AddParameter(cmd, "CurrentEmployerDuration", iTotalDurationInMonths)

                    DatabaseHelper.AddParameter(cmd, "Takehomepay", txtTakeHome.Text)
                    DatabaseHelper.AddParameter(cmd, "Per", cmbPer.Text)
                    'DatabaseHelper.AddParameter(cmd, "Otherwage", txtWage.Text)
                    DatabaseHelper.AddParameter(cmd, "Otherwage", cmbWage.Text)
                    If cmbWage.Text = "Yes" Then
                        DatabaseHelper.AddParameter(cmd, "WageVal", txtGarnishmentVal.Text)

                    Else
                        DatabaseHelper.AddParameter(cmd, "WageVal", "")

                    End If
                    DatabaseHelper.AddParameter(cmd, "OtherIncomeSource", txtOtherIncome.Text)

                    DatabaseHelper.AddParameter(cmd, "IsReceivingAid", 0)
                    DatabaseHelper.AddParameter(cmd, "TypeOfAid", "")
                Else
                    DatabaseHelper.AddParameter(cmd, "IsCurrentlyWorking", 0)
                    DatabaseHelper.AddParameter(cmd, "EmployerName", "")
                    DatabaseHelper.AddParameter(cmd, "CurrentEmployerDuration", 0)
                    DatabaseHelper.AddParameter(cmd, "Takehomepay", 0)
                    DatabaseHelper.AddParameter(cmd, "Per", "")
                    DatabaseHelper.AddParameter(cmd, "Otherwage", "")
                    DatabaseHelper.AddParameter(cmd, "OtherIncomeSource", "")

                    If cmbAid.SelectedIndex = 1 Then
                        DatabaseHelper.AddParameter(cmd, "IsReceivingAid", 1)

                        ''Dim strAidType As String = String.Empty
                        ''Dim itemindex As Int32 = 0
                        ''For itemindex = 0 To cmbAidType.Items.Count - 1
                        ''    If cmbAidType.Items(itemindex).Selected Then
                        ''        If strAidType = String.Empty Then
                        ''            strAidType = cmbAidType.Items(itemindex).Text
                        ''        Else
                        ''            strAidType = strAidType & "," & cmbAidType.Items(itemindex).Text
                        ''        End If
                        ''    End If
                        ''Next itemindex
                        ' ''DatabaseHelper.AddParameter(cmd, "TypeOfAid", cmbAidType.SelectedValue)
                        ''DatabaseHelper.AddParameter(cmd, "TypeOfAid", strAidType)



                        ' '' If cmbAidType.SelectedValue = "SSI" Then
                        ''DatabaseHelper.AddParameter(cmd, "IReceived", txtIR.Text)
                        'Else
                        '    DatabaseHelper.AddParameter(cmd, "IReceived", "")

                        'End If

                        If chkr1.Checked = True Then
                            DatabaseHelper.AddParameter(cmd, "TypeOfAid", "Yes")
                            DatabaseHelper.AddParameter(cmd, "IReceived", txtr1.Text)
                        Else
                            DatabaseHelper.AddParameter(cmd, "TypeOfAid", "No")
                        End If

                        If chkr2.Checked = True Then
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidPension", "Yes")
                            DatabaseHelper.AddParameter(cmd, "AmtReceivedPension", txtr2.Text)
                        Else
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidPension", "No")
                        End If

                        If chkr3.Checked = True Then
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidUnemp", "Yes")
                            DatabaseHelper.AddParameter(cmd, "AmtReceivedUnemp", txtr3.Text)
                        Else
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidUnemp", "No")
                        End If

                        If chkr4.Checked = True Then
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidRetire", "Yes")
                            DatabaseHelper.AddParameter(cmd, "AmtReceivedRetire", txtr4.Text)
                        Else
                            DatabaseHelper.AddParameter(cmd, "TypeOfAidRetire", "No")
                        End If

                    Else
                        DatabaseHelper.AddParameter(cmd, "IsReceivingAid", 0)
                        DatabaseHelper.AddParameter(cmd, "TypeOfAid", "")
                        DatabaseHelper.AddParameter(cmd, "IReceived", "")
                    End If
                End If
                'If cmbAccount.SelectedIndex = 1 Then
                '    DatabaseHelper.AddParameter(cmd, "AnyAccount", 1)
                'Else
                DatabaseHelper.AddParameter(cmd, "AnyAccount", 0)
                'End If

                If cmbBankAcc.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "HaveBankAccs", 1)

                    DatabaseHelper.AddParameter(cmd, "BankAccOne", txtBankName.Text)
                    DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccOne", txtSource.Text)
                    DatabaseHelper.AddParameter(cmd, "AppBalanceAccOne", txtBalance.Text)
                    If radAccountType.SelectedIndex > -1 Then
                        DatabaseHelper.AddParameter(cmd, "AccTypeOne", radAccountType.SelectedValue)
                    Else
                        DatabaseHelper.AddParameter(cmd, "AccTypeOne", 0)
                    End If
                    DatabaseHelper.AddParameter(cmd, "Levies1", txtLevies1.Text)

                    DatabaseHelper.AddParameter(cmd, "BankAccTwo", txtBankName2.Text)
                    DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccTwo", txtSource2.Text)
                    DatabaseHelper.AddParameter(cmd, "AppBalanceAccTwo", txtBalance2.Text)
                    If radAccountType2.SelectedIndex > -1 Then
                        DatabaseHelper.AddParameter(cmd, "AccTypeTwo", radAccountType2.SelectedValue)
                    Else
                        DatabaseHelper.AddParameter(cmd, "AccTypeTwo", 0)
                    End If

                    DatabaseHelper.AddParameter(cmd, "Levies2", txtLevies2.Text)


                    'DatabaseHelper.AddParameter(cmd, "BankAccThree", txtBankName3.Text)
                    'DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccThree", txtSource3.Text)
                    'DatabaseHelper.AddParameter(cmd, "AppBalanceAccThree", txtBalance3.Text)
                Else
                    DatabaseHelper.AddParameter(cmd, "HaveBankAccs", 0)
                    DatabaseHelper.AddParameter(cmd, "BankAccOne", "")
                    DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccOne", "")
                    DatabaseHelper.AddParameter(cmd, "AppBalanceAccOne", "")

                    DatabaseHelper.AddParameter(cmd, "BankAccTwo", "")
                    DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccTwo", "")
                    DatabaseHelper.AddParameter(cmd, "AppBalanceAccTwo", "")

                    DatabaseHelper.AddParameter(cmd, "BankAccThree", "")
                    DatabaseHelper.AddParameter(cmd, "BankAmtSourceAccThree", "")
                    DatabaseHelper.AddParameter(cmd, "AppBalanceAccThree", "")

                    DatabaseHelper.AddParameter(cmd, "Levies1", "")
                    DatabaseHelper.AddParameter(cmd, "Levies2", "")

                End If

                If cmbAssets.SelectedIndex = 1 Then
                    DatabaseHelper.AddParameter(cmd, "HaveOtherAssets", 1)
                    DatabaseHelper.AddParameter(cmd, "Assets", txtAssets.Text)
                Else
                    DatabaseHelper.AddParameter(cmd, "HaveOtherAssets", 0)
                End If

                If chkLegalServices.Checked Then
                    DatabaseHelper.AddParameter(cmd, "DeclinedLegalServices", 1)
                    DatabaseHelper.AddParameter(cmd, "LegalServicesClientID", cmbVerifiedBy.SelectedValue)
                Else
                    DatabaseHelper.AddParameter(cmd, "DeclinedLegalServices", 0)
                    DatabaseHelper.AddParameter(cmd, "LegalServicesClientID", 0)
                End If

                If chkLocalCounsel.Checked Then
                    DatabaseHelper.AddParameter(cmd, "SentLocalCounsel", 1)
                    DatabaseHelper.AddParameter(cmd, "FeePaidBy", cmbFeepaidtype.SelectedValue)
                Else
                    DatabaseHelper.AddParameter(cmd, "SentLocalCounsel", 0)
                    DatabaseHelper.AddParameter(cmd, "FeePaidBy", 0)
                End If

                DatabaseHelper.AddParameter(cmd, "Notes", txtSDADesc.Text)

                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "CreatedDatetime", System.DateTime.Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedDatetime", System.DateTime.Now)

                If ChkFormVeirified.Checked Then
                    DatabaseHelper.AddParameter(cmd, "IsVerified", 1)
                    DatabaseHelper.AddParameter(cmd, "VerifiedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "VerifiedDate", System.DateTime.Now)
                Else
                    DatabaseHelper.AddParameter(cmd, "IsVerified", 0)
                    DatabaseHelper.AddParameter(cmd, "VerifiedBy", 0)
                    DatabaseHelper.AddParameter(cmd, "VerifiedDate", Nothing)
                End If

                DatabaseHelper.AddParameter(cmd, "ClientName", cmbClients.SelectedItem.Text)
                DatabaseHelper.AddParameter(cmd, "whoisplantiff", txtplantiff.Text)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                cmd.Connection.Close()
            End Using
        End Using



    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        InsertOrUpdate()
        Dim strNotes As String() = {}
        Dim strPropagations As String() = {}
        TaskHelper.Resolve(TaskID, txtResolved.Value, hdnTaskResolutionID.Value, UserID, strNotes, strPropagations)
        Close()
    End Sub
    Private Sub LoadAssignedTo(ByRef cboAssignedTo As DropDownList, ByVal SelectedAssignedToId As Integer)
        ' UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        ' 1.25.10 List only valid user in the same group 
        'cmd.CommandText = " select * from tblUser u2 where u2.UserTypeId=(Select UserTypeId from tblUser where UserId ='" + UserID.ToString() _
        '                  + "') and u2.UserGroupId = (Select UserGroupId from tblUser where UserId ='" + UserID.ToString() + "') and u2.Locked = 0 and u2.Temporary =0"

        ' 3.22.2010 List only East and West Litigation Users
        cmd.CommandText = "select * from tblUser u where u.UserGroupId IN(30,37) and u.Locked = 0 and u.Temporary =0 order by FirstName, LastName"



        cboAssignedTo.Items.Clear()
        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboAssignedTo.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "FirstName") + " " + DatabaseHelper.Peel_string(rd, "LastName"), DatabaseHelper.Peel_int(rd, "UserId")))
            End While
            cboAssignedTo.Items.Insert(0, New ListItem("Select", "0"))
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        ListHelper.SetSelected(cboAssignedTo, SelectedAssignedToId)
    End Sub
    Private Sub LoadCompanies(ByRef cboCompanies As DropDownList, ByVal SelectedAssignedToId As Integer)
        ' UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "select distinct tcm.companyid, tcm.name from tblCompany tcm "

        cboCompanies.Items.Clear()
        cboCompanies.Items.Insert(0, New ListItem("Select Company", "0"))
        cboCompanies.Items.Add(New ListItem("By Client", "-1"))
        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader()
            While rd.Read()
                cboCompanies.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "companyid")))
            End While
            
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        ListHelper.SetSelected(cboCompanies, SelectedAssignedToId)
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
End Class