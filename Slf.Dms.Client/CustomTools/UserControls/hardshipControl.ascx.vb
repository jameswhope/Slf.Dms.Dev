Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataHelpers

Imports SharedFunctions

Partial Class hardshipControl
    Inherits System.Web.UI.UserControl

#Region "Properties"

    Public Property CreatedBy() As Integer
        Get
            Return ViewState("createdby")
        End Get
        Set(ByVal value As Integer)
            ViewState("createdby") = value
        End Set
    End Property

    Public Property DataClientID() As Integer
        Get
            Return ViewState("DataClientID")
        End Get
        Set(ByVal value As Integer)
            ViewState("DataClientID") = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Public Shared Shadows Function FindControl(ByVal startingControl As Control, ByVal id As String) As Control
        If id = startingControl.ID Then Return startingControl
        For Each ctl As Control In startingControl.Controls
            Dim found = FindControl(ctl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function

    ''' <summary>
    ''' deletes clients hardship data
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub DeleteHardshipData()
        Dim sqlDel As String = String.Format("stp_Hardship_deleteHardshipData {0}", DataClientID)

        Using cmd As New SqlCommand(sqlDel, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
            cmd.Connection.Open()
            Dim intRows As Integer = cmd.ExecuteNonQuery()
            If intRows > 0 Then
                ''attach documents to note
                Dim intNoteID As Integer = NoteHelper.InsertNote("Hardship Form Deleted.", CreatedBy, DataClientID)
                'relate
                NoteHelper.RelateNote(intNoteID, 1, DataClientID)

            End If

        End Using
        LoadHardshipData()
    End Sub

    Public Shadows Function FindControl(ByVal id As String) As Control
        Return FindControl(Page, id)
    End Function

    ''' <summary>
    ''' load clients current hardship data
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub LoadHardshipData()
        Dim sqlLoad As String = String.Format("stp_Hardship_getHardshipDataNew {0}", DataClientID)
        Dim dt As DataTable = Nothing
        Try
            dt = SharedFunctions.AsyncDB.executeDataTableAsync(sqlLoad, ConfigurationManager.AppSettings("connectionstring").ToString)
            If dt.Rows.Count > 0 Then
                For Each hard As DataRow In dt.Rows
                    If Not IsDBNull(hard("Married").ToString) AndAlso Not String.IsNullOrEmpty(hard("Married").ToString) Then
                        MarriedCheckBox.Checked = hard("Married").ToString
                    Else
                        MarriedCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("Single").ToString) AndAlso Not String.IsNullOrEmpty(hard("Single").ToString) Then
                        SingleCheckBox.Checked = hard("Single").ToString
                    Else
                        SingleCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("Divorced").ToString) AndAlso Not String.IsNullOrEmpty(hard("Divorced").ToString) Then
                        DivorcedCheckBox.Checked = hard("Divorced").ToString
                    Else
                        DivorcedCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("Widowed").ToString) AndAlso Not String.IsNullOrEmpty(hard("Widowed").ToString) Then
                        WidowedCheckBox.Checked = hard("Widowed").ToString
                    Else
                        WidowedCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("Hardship")) AndAlso Not String.IsNullOrEmpty(hard("Hardship").ToString) Then
                        If hard("Hardship") = "Divorce" Then
                            ddlHardship.SelectedValue = 1
                        ElseIf hard("Hardship") = "Death of spouse" Then
                            ddlHardship.SelectedValue = 2
                        ElseIf hard("Hardship") = "Loss of job" Then
                            ddlHardship.SelectedValue = 3
                        ElseIf hard("Hardship") = "Unable to keep up" Then
                            ddlHardship.SelectedValue = 4
                        ElseIf hard("Hardship") = "Raised Int/Mthly pymt" Then
                            ddlHardship.SelectedValue = 5
                        ElseIf hard("Hardship") = "Cut in hours" Then
                            ddlHardship.SelectedValue = 6
                        ElseIf hard("Hardship") = "Medical Hardship" Then
                            ddlHardship.SelectedValue = 7
                        ElseIf hard("Hardship") = "Other" Then
                            ddlHardship.SelectedValue = 8
                        Else
                            ddlHardship.SelectedValue = 0
                        End If
                    Else
                        ddlHardship.SelectedValue = 0
                    End If
                    If Not IsDBNull(hard("OwnRent")) AndAlso Not String.IsNullOrEmpty(hard("OwnRent").ToString) Then
                        If hard("OwnRent") = "Own" Then
                            ddlOwnRent.SelectedValue = 1
                        ElseIf hard("OwnRent") = "Rent" Then
                            ddlOwnRent.SelectedValue = 2
                        Else
                            ddlOwnRent.SelectedValue = 0
                        End If
                    Else
                        ddlOwnRent.SelectedValue = 0
                    End If
                    If Not IsDBNull(hard("ConcernsID")) AndAlso Not String.IsNullOrEmpty(hard("ConcernsID").ToString) Then
                        ddlConcerns.SelectedValue = hard("ConcernsID")
                    Else
                        ddlConcerns.SelectedValue = 0
                    End If
                    If Not IsDBNull(hard("BehindID")) AndAlso Not String.IsNullOrEmpty(hard("BehindID").ToString) Then
                        ddlBehind.SelectedValue = hard("BehindID")
                    Else
                        ddlBehind.SelectedValue = 0
                    End If
                    If Not IsDBNull(hard("NumChildren")) AndAlso Not String.IsNullOrEmpty(hard("NumChildren").ToString) Then
                        NumChildrenTextBox.Text = hard("NumChildren").ToString
                    Else
                        NumChildrenTextBox.Text = 0
                    End If
                    If Not IsDBNull(hard("NumGrandChildren")) AndAlso Not String.IsNullOrEmpty(hard("NumGrandChildren").ToString) Then
                        NumGrandChildrenTextBox.Text = hard("NumGrandChildren").ToString
                    Else
                        NumGrandChildrenTextBox.Text = 0
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_Work")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Work").ToString) Then
                        MonthlyIncome_Client_WorkTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Work").ToString, 2)
                    Else
                        MonthlyIncome_Client_WorkTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_SocialSecurity")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_SocialSecurity").ToString) Then
                        MonthlyIncome_Client_SocialSecurityTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_SocialSecurity").ToString, 2)
                    Else
                        MonthlyIncome_Client_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_Disability")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Disability").ToString) Then
                        MonthlyIncome_Client_DisabilityTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Disability").ToString, 2)
                    Else
                        MonthlyIncome_Client_DisabilityTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_RetirementPension")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_RetirementPension").ToString) Then
                        MonthlyIncome_Client_RetirementPensionTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_RetirementPension").ToString, 2)
                    Else
                        MonthlyIncome_Client_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_401k")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_401k").ToString) Then
                        MonthlyIncome_Client_Retirement401kTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_401k").ToString, 2)
                    Else
                        MonthlyIncome_Client_Retirement401kTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_Savings")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Savings").ToString) Then
                        MonthlyIncome_Client_SavingsCheckingsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Savings").ToString, 2)
                    Else
                        MonthlyIncome_Client_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Other").ToString) Then
                        MonthlyIncome_Client_OtherAssetsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Other").ToString, 2)
                    Else
                        MonthlyIncome_Client_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_OtherDebts")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_OtherDebts").ToString) Then
                        MonthlyIncome_Client_OtherDebtsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_OtherDebts").ToString, 2)
                    Else
                        MonthlyIncome_Client_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_SelfEmployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_SelfEmployed").ToString) Then
                        MonthlyIncome_Client_SelfEmployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_SelfEmployed").ToString, 2)
                    Else
                        MonthlyIncome_Client_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_Unemployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Unemployed").ToString) Then
                        MonthlyIncome_Client_UnemployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Unemployed").ToString, 2)
                    Else
                        MonthlyIncome_Client_UnemployedTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_JobDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_JobDescription").ToString) Then
                        MonthlyIncome_Client_JobDescriptionTextBox.Text = hard("MonthlyIncome_Client_JobDescription").ToString
                    Else
                        MonthlyIncome_Client_JobDescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_FullTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_FullTime").ToString) Then
                        MonthlyIncome_Client_FullTimeCheckBox.Checked = hard("MonthlyIncome_Client_FullTime").ToString
                    Else
                        MonthlyIncome_Client_FullTimeCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_PartTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_PartTime").ToString) Then
                        MonthlyIncome_Client_PartTimeCheckBox.Checked = hard("MonthlyIncome_Client_PartTime").ToString
                    Else
                        MonthlyIncome_Client_PartTimeCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_Work")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Work").ToString) Then
                        MonthlyIncome_Spouse_WorkTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Work").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_WorkTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_SocialSecurity")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_SocialSecurity").ToString) Then
                        MonthlyIncome_Spouse_SocialSecurityTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_SocialSecurity").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_Disability")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Disability").ToString) Then
                        MonthlyIncome_Spouse_DisabilityTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Disability").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_DisabilityTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_RetirementPension")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_RetirementPension").ToString) Then
                        MonthlyIncome_Spouse_RetirementPensionTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_RetirementPension").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_401k")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_401k").ToString) Then
                        MonthlyIncome_Spouse_Retirement401kTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_401k").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_Retirement401kTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_Savings")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Savings").ToString) Then
                        MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Savings").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Other").ToString) Then
                        MonthlyIncome_Spouse_OtherAssetsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Other").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_OtherDebts")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_OtherDebts").ToString) Then
                        MonthlyIncome_Spouse_OtherDebtsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_OtherDebts").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_SelfEmployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_SelfEmployed").ToString) Then
                        MonthlyIncome_Spouse_SelfEmployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_SelfEmployed").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_Unemployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Unemployed").ToString) Then
                        MonthlyIncome_Spouse_UnemployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Unemployed").ToString, 2)
                    Else
                        MonthlyIncome_Spouse_UnemployedTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_JobDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_JobDescription").ToString) Then
                        MonthlyIncome_Spouse_JobDescriptionTextBox.Text = hard("MonthlyIncome_Spouse_JobDescription").ToString
                    Else
                        MonthlyIncome_Spouse_JobDescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_FullTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_FullTime").ToString) Then
                        MonthlyIncome_Spouse_FullTimeCheckBox.Checked = hard("MonthlyIncome_Spouse_FullTime").ToString
                    Else
                        MonthlyIncome_Spouse_FullTimeCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_PartTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_PartTime").ToString) Then
                        MonthlyIncome_Spouse_PartTimeCheckBox.Checked = hard("MonthlyIncome_Spouse_PartTime").ToString
                    Else
                        MonthlyIncome_Spouse_PartTimeCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_IsRecievingStateAssistance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_IsRecievingStateAssistance").ToString) Then
                        MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked = hard("MonthlyIncome_IsRecievingStateAssistance").ToString
                    Else
                        MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_IsRecievingStateAssistanceDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_IsRecievingStateAssistanceDescription").ToString) Then
                        MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text = hard("MonthlyIncome_IsRecievingStateAssistanceDescription").ToString
                    Else
                        MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Rent")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Rent").ToString) Then
                        MonthlyExpenses_RentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Rent").ToString, 2)
                    Else
                        MonthlyExpenses_RentTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Mortgage")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Mortgage").ToString) Then
                        MonthlyExpenses_MortgageTextBox.Text = FormatNumber(hard("MonthlyExpenses_Mortgage").ToString, 2)
                    Else
                        MonthlyExpenses_MortgageTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_2ndMortgage")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_2ndMortgage").ToString) Then
                        MonthlyExpenses_2ndMortgageCheckBox.Checked = hard("MonthlyExpenses_2ndMortgage").ToString
                    Else
                        MonthlyExpenses_2ndMortgageCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_2ndMortgageAmt")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_2ndMortgageAmt").ToString) Then
                        MonthlyExpenses_2ndMortgageAmtTextBox.Text = FormatNumber(hard("MonthlyExpenses_2ndMortgageAmt").ToString, 2)
                    Else
                        MonthlyExpenses_2ndMortgageAmtTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_HasClientRefinanced")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_HasClientRefinanced").ToString) Then
                        MonthlyExpenses_HasClientRefinancedCheckBox.Checked = hard("MonthlyExpenses_HasClientRefinanced").ToString
                    Else
                        MonthlyExpenses_HasClientRefinancedCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_EquityValueOfHome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_EquityValueOfHome").ToString) Then
                        MonthlyExpenses_EquityValueOfHomeTextBox.Text = FormatNumber(hard("MonthlyExpenses_EquityValueOfHome").ToString, 2)
                    Else
                        MonthlyExpenses_EquityValueOfHomeTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_ReasonForDebt")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_ReasonForDebt").ToString) Then
                        MonthlyExpenses_ReasonForDebtTextBox.Text = hard("MonthlyExpenses_ReasonForDebt").ToString
                    Else
                        MonthlyExpenses_ReasonForDebtTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_DoesClientHaveAssets")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_DoesClientHaveAssets").ToString) Then
                        MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked = hard("MonthlyExpenses_DoesClientHaveAssets").ToString
                    Else
                        MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Carpayment")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Carpayment").ToString) Then
                        MonthlyExpenses_CarpaymentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Carpayment").ToString, 2)
                    Else
                        MonthlyExpenses_CarpaymentTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_CarInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_CarInsurance").ToString) Then
                        MonthlyExpenses_CarInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_CarInsurance").ToString, 2)
                    Else
                        MonthlyExpenses_CarInsuranceTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_OweOnHome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OweOnHome").ToString) Then
                        MonthlyExpenses_OweOnHomeTextBox.Text = FormatNumber(hard("MonthlyExpenses_OweOnHome").ToString, 2)
                    Else
                        MonthlyExpenses_OweOnHomeTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_DiningOut")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_DiningOut").ToString) Then
                        MonthlyExpenses_DiningOutTextBox.Text = FormatNumber(hard("MonthlyExpenses_DiningOut").ToString, 2)
                    Else
                        MonthlyExpenses_DiningOutTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Entertainment")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Entertainment").ToString) Then
                        MonthlyExpenses_EntertainmentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Entertainment").ToString, 2)
                    Else
                        MonthlyExpenses_EntertainmentTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_PhoneCell")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_PhoneCell").ToString) Then
                        MonthlyExpenses_PhoneTextBox.Text = FormatNumber(hard("MonthlyExpenses_PhoneCell").ToString, 2)
                    Else
                        MonthlyExpenses_PhoneTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_HomeInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_HomeInsurance").ToString) Then
                        MonthlyExpenses_HomeInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_HomeInsurance").ToString, 2)
                    Else
                        MonthlyExpenses_HomeInsuranceTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Utilities")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Utilities").ToString) Then
                        MonthlyExpenses_UtilitiesTextBox.Text = FormatNumber(hard("MonthlyExpenses_Utilities").ToString, 2)
                    Else
                        MonthlyExpenses_UtilitiesTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Groceries")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Groceries").ToString) Then
                        MonthlyExpenses_GroceriesTextBox.Text = FormatNumber(hard("MonthlyExpenses_Groceries").ToString, 2)
                    Else
                        MonthlyExpenses_GroceriesTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_MedicalInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_MedicalInsurance").ToString) Then
                        MonthlyExpenses_MedicalInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_MedicalInsurance").ToString, 2)
                    Else
                        MonthlyExpenses_MedicalInsuranceTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Medications")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Medications").ToString) Then
                        MonthlyExpenses_MedicationsTextBox.Text = FormatNumber(hard("MonthlyExpenses_Medications").ToString, 2)
                    Else
                        MonthlyExpenses_MedicationsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Gasoline")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Gasoline").ToString) Then
                        MonthlyExpenses_GasolineTextBox.Text = FormatNumber(hard("MonthlyExpenses_Gasoline").ToString, 2)
                    Else
                        MonthlyExpenses_GasolineTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_SchoolLoans")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_SchoolLoans").ToString) Then
                        MonthlyExpenses_SchoolLoansTextBox.Text = FormatNumber(hard("MonthlyExpenses_SchoolLoans").ToString, 2)
                    Else
                        MonthlyExpenses_SchoolLoansTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other").ToString) Then
                        MonthlyExpenses_OtherTextBox.Text = FormatNumber(hard("MonthlyExpenses_Other").ToString, 2)
                    Else
                        MonthlyExpenses_OtherTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_OtherDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription").ToString) Then
                        MonthlyExpenses_OtherDescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription").ToString
                    Else
                        MonthlyExpenses_OtherDescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_Diabetes")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Diabetes").ToString) Then
                        MedicalCondtions_Client_DiabetesCheckBox.Checked = hard("MedicalCondtions_Client_Diabetes").ToString
                    Else
                        MedicalCondtions_Client_DiabetesCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_Arthritis")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Arthritis").ToString) Then
                        MedicalCondtions_Client_ArthritisCheckBox.Checked = hard("MedicalCondtions_Client_Arthritis").ToString
                    Else
                        MedicalCondtions_Client_ArthritisCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_Asthma")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Asthma").ToString) Then
                        MedicalCondtions_Client_AsthmaCheckBox.Checked = hard("MedicalCondtions_Client_Asthma").ToString
                    Else
                        MedicalCondtions_Client_AsthmaCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_HighBloodPressure")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_HighBloodPressure").ToString) Then
                        MedicalCondtions_Client_HighBloodPressureCheckBox.Checked = hard("MedicalCondtions_Client_HighBloodPressure").ToString
                    Else
                        MedicalCondtions_Client_HighBloodPressureCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalConditions_Client_AnxietyDepression")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Client_AnxietyDepression").ToString) Then
                        MedicalConditions_Client_AnxietyDepressionCheckBox.Checked = hard("MedicalConditions_Client_AnxietyDepression").ToString
                    Else
                        MedicalConditions_Client_AnxietyDepressionCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalConditions_Client_HeartCondition")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Client_HeartCondition").ToString) Then
                        MedicalConditions_Client_HeartConditionCheckBox.Checked = hard("MedicalConditions_Client_HeartCondition").ToString
                    Else
                        MedicalConditions_Client_HeartConditionCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_HighCholesterol")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_HighCholesterol").ToString) Then
                        MedicalCondtions_Client_HighCholesterolCheckBox.Checked = hard("MedicalCondtions_Client_HighCholesterol").ToString
                    Else
                        MedicalCondtions_Client_HighCholesterolCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_Other")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Other").ToString) Then
                        MedicalCondtions_Client_OtherTextBox.Text = hard("MedicalCondtions_Client_Other").ToString
                    Else
                        MedicalCondtions_Client_OtherTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_NumPillsTaken")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_NumPillsTaken").ToString) Then
                        MedicalCondtions_Client_NumPillsTakenTextBox.Text = hard("MedicalCondtions_Client_NumPillsTaken").ToString
                    Else
                        MedicalCondtions_Client_NumPillsTakenTextBox.Text = "0"
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Client_History")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_History").ToString) Then
                        MedicalCondtions_Client_HistoryTextBox.Text = hard("MedicalCondtions_Client_History").ToString
                    Else
                        MedicalCondtions_Client_HistoryTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_Diabetes")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Diabetes").ToString) Then
                        MedicalCondtions_Spouse_DiabetesCheckBox.Checked = hard("MedicalCondtions_Spouse_Diabetes").ToString
                    Else
                        MedicalCondtions_Spouse_DiabetesCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_Arthritis")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Arthritis").ToString) Then
                        MedicalCondtions_Spouse_ArthritisCheckBox.Checked = hard("MedicalCondtions_Spouse_Arthritis").ToString
                    Else
                        MedicalCondtions_Spouse_ArthritisCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_Asthma")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Asthma").ToString) Then
                        MedicalCondtions_Spouse_AsthmaCheckBox.Checked = hard("MedicalCondtions_Spouse_Asthma").ToString
                    Else
                        MedicalCondtions_Spouse_AsthmaCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_HighBloodPressure")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_HighBloodPressure").ToString) Then
                        MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked = hard("MedicalCondtions_Spouse_HighBloodPressure").ToString
                    Else
                        MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalConditions_Spouse_AnxietyDepression")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Spouse_AnxietyDepression").ToString) Then
                        MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked = hard("MedicalConditions_Spouse_AnxietyDepression").ToString
                    Else
                        MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalConditions_Spouse_HeartCondition")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Spouse_HeartCondition").ToString) Then
                        MedicalConditions_Spouse_HeartConditionCheckBox.Checked = hard("MedicalConditions_Spouse_HeartCondition").ToString
                    Else
                        MedicalConditions_Spouse_HeartConditionCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_HighCholesterol")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_HighCholesterol").ToString) Then
                        MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked = hard("MedicalCondtions_Spouse_HighCholesterol").ToString
                    Else
                        MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked = False
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_Other")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Other").ToString) Then
                        MedicalCondtions_Spouse_OtherTextBox.Text = hard("MedicalCondtions_Spouse_Other").ToString
                    Else
                        MedicalCondtions_Spouse_OtherTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_NumPillsTaken")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_NumPillsTaken").ToString) Then
                        MedicalCondtions_Spouse_NumPillsTakenTextBox.Text = hard("MedicalCondtions_Spouse_NumPillsTaken").ToString
                    Else
                        MedicalCondtions_Spouse_NumPillsTakenTextBox.Text = "0"
                    End If
                    If Not IsDBNull(hard("MedicalCondtions_Spouse_History")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_History").ToString) Then
                        MedicalCondtions_Spouse_HistoryTextBox.Text = hard("MedicalCondtions_Spouse_History").ToString
                    Else
                        MedicalCondtions_Spouse_HistoryTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("AdditionalInformation")) AndAlso Not String.IsNullOrEmpty(hard("AdditionalInformation").ToString) Then
                        AdditionalInformationTextBox.Text = hard("AdditionalInformation").ToString
                    Else
                        AdditionalInformationTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Client_DescribeOther")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_DescribeOther").ToString) Then
                        MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text = hard("MonthlyIncome_Client_DescribeOther").ToString
                    Else
                        MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_Spouse_DescribeOther")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_DescribeOther").ToString) Then
                        MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text = hard("MonthlyIncome_Spouse_DescribeOther").ToString
                    Else
                        MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyIncome_TotalMonthlyIncome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_TotalMonthlyIncome").ToString) Then
                        MonthlyIncome_TotalMonthlyIncomeTextBox.Text = hard("MonthlyIncome_TotalMonthlyIncome").ToString
                    Else
                        MonthlyIncome_TotalMonthlyIncomeTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_SchoolExpenses")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_SchoolExpenses").ToString) Then
                        MonthlyExpenses_SchoolExpensesTextBox.Text = FormatNumber(hard("MonthlyExpenses_SchoolExpenses").ToString, 2)
                    Else
                        MonthlyExpenses_SchoolExpensesTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_lawfirm")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_lawfirm").ToString) Then
                        MonthlyExpenses_lawfirmTextBox.Text = FormatNumber(hard("MonthlyExpenses_lawfirm").ToString, 2)
                    Else
                        MonthlyExpenses_lawfirmTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_loans")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_loans").ToString) Then
                        MonthlyExpenses_loansTextBox.Text = FormatNumber(hard("MonthlyExpenses_loans").ToString, 2)
                    Else
                        MonthlyExpenses_loansTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_creditcards")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_creditcards").ToString) Then
                        MonthlyExpenses_creditcardsTextBox.Text = FormatNumber(hard("MonthlyExpenses_creditcards").ToString, 2)
                    Else
                        MonthlyExpenses_creditcardsTextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_OtherDescription2")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription2").ToString) Then
                        MonthlyExpenses_Other2DescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription2").ToString
                    Else
                        MonthlyExpenses_Other2DescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Other2")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other2").ToString) Then
                        MonthlyExpenses_Other2TextBox.Text = FormatNumber(hard("MonthlyExpenses_Other2").ToString, 2)
                    Else
                        MonthlyExpenses_Other2TextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_OtherDescription3")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription3").ToString) Then
                        MonthlyExpenses_Other3DescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription3").ToString
                    Else
                        MonthlyExpenses_Other3DescriptionTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("MonthlyExpenses_Other3")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other3").ToString) Then
                        MonthlyExpenses_Other3TextBox.Text = FormatNumber(hard("MonthlyExpenses_Other3").ToString, 2)
                    Else
                        MonthlyExpenses_Other3TextBox.Text = FormatNumber(0, 2)
                    End If
                    If Not IsDBNull(hard("IncomeAfterExpenses")) AndAlso Not String.IsNullOrEmpty(hard("IncomeAfterExpenses").ToString) Then
                        IncomeAfterExpensesTextBox.Text = hard("IncomeAfterExpenses").ToString
                    Else
                        IncomeAfterExpensesTextBox.Text = ""
                    End If
                    If Not IsDBNull(hard("Monthly_TotalExpenses")) AndAlso Not String.IsNullOrEmpty(hard("Monthly_TotalExpenses").ToString) Then
                        Monthly_TotalExpensesTextBox.Text = hard("Monthly_TotalExpenses").ToString
                    Else
                        Monthly_TotalExpensesTextBox.Text = ""
                    End If
                    Exit For
                Next
            Else
                MarriedCheckBox.Checked = False
                SingleCheckBox.Checked = False
                DivorcedCheckBox.Checked = False
                WidowedCheckBox.Checked = False

                ddlHardship.SelectedValue = 0
                ddlOwnRent.SelectedValue = 0
                ddlConcerns.SelectedValue = 0
                ddlBehind.SelectedValue = 0

                NumChildrenTextBox.Text = 0
                NumGrandChildrenTextBox.Text = 0

                MonthlyIncome_Client_WorkTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_DisabilityTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_Retirement401kTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_UnemployedTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Client_JobDescriptionTextBox.Text = ""
                MonthlyIncome_Client_FullTimeCheckBox.Checked = False
                MonthlyIncome_Client_PartTimeCheckBox.Checked = False
                MonthlyIncome_Spouse_WorkTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_DisabilityTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_Retirement401kTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_UnemployedTextBox.Text = FormatNumber(0, 2)
                MonthlyIncome_Spouse_JobDescriptionTextBox.Text = ""
                MonthlyIncome_Spouse_FullTimeCheckBox.Checked = False
                MonthlyIncome_Spouse_PartTimeCheckBox.Checked = False
                MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked = False
                MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text = ""
                MonthlyExpenses_RentTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_MortgageTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_2ndMortgageCheckBox.Checked = False
                MonthlyExpenses_2ndMortgageAmtTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_HasClientRefinancedCheckBox.Checked = False
                MonthlyExpenses_EquityValueOfHomeTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_ReasonForDebtTextBox.Text = ""
                MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked = False
                MonthlyExpenses_CarpaymentTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_CarInsuranceTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_OweOnHomeTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_UtilitiesTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_DiningOutTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_EntertainmentTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_PhoneTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_HomeInsuranceTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_GroceriesTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_MedicalInsuranceTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_MedicationsTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_GasolineTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_SchoolLoansTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_OtherTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_OtherDescriptionTextBox.Text = ""
                MedicalCondtions_Client_DiabetesCheckBox.Checked = False
                MedicalCondtions_Client_ArthritisCheckBox.Checked = False
                MedicalCondtions_Client_AsthmaCheckBox.Checked = False
                MedicalCondtions_Client_HighBloodPressureCheckBox.Checked = False
                MedicalConditions_Client_AnxietyDepressionCheckBox.Checked = False
                MedicalConditions_Client_HeartConditionCheckBox.Checked = False
                MedicalCondtions_Client_HighCholesterolCheckBox.Checked = False
                MedicalCondtions_Client_OtherTextBox.Text = ""
                MedicalCondtions_Client_NumPillsTakenTextBox.Text = "0"
                MedicalCondtions_Client_HistoryTextBox.Text = ""
                MedicalCondtions_Spouse_DiabetesCheckBox.Checked = False
                MedicalCondtions_Spouse_ArthritisCheckBox.Checked = False
                MedicalCondtions_Spouse_AsthmaCheckBox.Checked = False
                MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked = False
                MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked = False
                MedicalConditions_Spouse_HeartConditionCheckBox.Checked = False
                MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked = False
                MedicalCondtions_Spouse_OtherTextBox.Text = ""
                MedicalCondtions_Spouse_NumPillsTakenTextBox.Text = "0"
                MedicalCondtions_Spouse_HistoryTextBox.Text = ""
                AdditionalInformationTextBox.Text = ""
                MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text = ""
                MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text = ""
                MonthlyIncome_TotalMonthlyIncomeTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_SchoolExpensesTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_lawfirmTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_loansTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_creditcardsTextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_Other2DescriptionTextBox.Text = ""
                MonthlyExpenses_Other2TextBox.Text = FormatNumber(0, 2)
                MonthlyExpenses_Other3DescriptionTextBox.Text = ""
                MonthlyExpenses_Other3TextBox.Text = FormatNumber(0, 2)
                IncomeAfterExpensesTextBox.Text = FormatNumber(0, 2)
                Monthly_TotalExpensesTextBox.Text = FormatNumber(0, 2)
            End If

            gvHardshipHistory.DataBind()
        Finally
            dt.Dispose()
            dt = Nothing
        End Try
    End Sub

    Public Sub LoadHardshipDataByID(ByVal hardshipID As Integer)
        Dim sqlLoad As String = String.Format("stp_Hardship_getHardshipDataByIDnew {0}", hardshipID)

        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlLoad, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each hard As DataRow In dt.Rows
                If Not IsDBNull(hard("Married").ToString) AndAlso Not String.IsNullOrEmpty(hard("Married").ToString) Then
                    MarriedCheckBox.Checked = hard("Married").ToString
                Else
                    MarriedCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("Single").ToString) AndAlso Not String.IsNullOrEmpty(hard("Single").ToString) Then
                    SingleCheckBox.Checked = hard("Single").ToString
                Else
                    SingleCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("Divorced").ToString) AndAlso Not String.IsNullOrEmpty(hard("Divorced").ToString) Then
                    DivorcedCheckBox.Checked = hard("Divorced").ToString
                Else
                    DivorcedCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("Widowed").ToString) AndAlso Not String.IsNullOrEmpty(hard("Widowed").ToString) Then
                    WidowedCheckBox.Checked = hard("Widowed").ToString
                Else
                    WidowedCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("Hardship")) AndAlso Not String.IsNullOrEmpty(hard("Hardship").ToString) Then
                    If hard("Hardship") = "Divorce" Then
                        ddlHardship.SelectedValue = 1
                    ElseIf hard("Hardship") = "Death of spouse" Then
                        ddlHardship.SelectedValue = 2
                    ElseIf hard("Hardship") = "Loss of job" Then
                        ddlHardship.SelectedValue = 3
                    ElseIf hard("Hardship") = "Unable to keep up" Then
                        ddlHardship.SelectedValue = 4
                    ElseIf hard("Hardship") = "Raised Int/Mthly pymt" Then
                        ddlHardship.SelectedValue = 5
                    ElseIf hard("Hardship") = "Cut in hours" Then
                        ddlHardship.SelectedValue = 6
                    ElseIf hard("Hardship") = "Medical Hardship" Then
                        ddlHardship.SelectedValue = 7
                    ElseIf hard("Hardship") = "Other" Then
                        ddlHardship.SelectedValue = 8
                    Else
                        ddlHardship.SelectedValue = 0
                    End If
                Else
                    ddlHardship.SelectedValue = 0
                End If
                If Not IsDBNull(hard("OwnRent")) AndAlso Not String.IsNullOrEmpty(hard("OwnRent").ToString) Then
                    If hard("OwnRent") = "Own" Then
                        ddlOwnRent.SelectedValue = 1
                    ElseIf hard("OwnRent") = "Rent" Then
                        ddlOwnRent.SelectedValue = 2
                    Else
                        ddlOwnRent.SelectedValue = 0
                    End If
                Else
                    ddlOwnRent.SelectedValue = 0
                End If
                If Not IsDBNull(hard("ConcernsID")) AndAlso Not String.IsNullOrEmpty(hard("ConcernsID").ToString) Then
                    ddlConcerns.SelectedValue = hard("ConcernsID")
                Else
                    ddlConcerns.SelectedValue = 0
                End If
                If Not IsDBNull(hard("BehindID")) AndAlso Not String.IsNullOrEmpty(hard("BehindID").ToString) Then
                    ddlBehind.SelectedValue = hard("BehindID")
                Else
                    ddlBehind.SelectedValue = 0
                End If
                If Not IsDBNull(hard("NumChildren")) AndAlso Not String.IsNullOrEmpty(hard("NumChildren").ToString) Then
                    NumChildrenTextBox.Text = hard("NumChildren").ToString
                Else
                    NumChildrenTextBox.Text = 0
                End If
                If Not IsDBNull(hard("NumGrandChildren")) AndAlso Not String.IsNullOrEmpty(hard("NumGrandChildren").ToString) Then
                    NumGrandChildrenTextBox.Text = hard("NumGrandChildren").ToString
                Else
                    NumGrandChildrenTextBox.Text = 0
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_Work")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Work").ToString) Then
                    MonthlyIncome_Client_WorkTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Work").ToString, 2)
                Else
                    MonthlyIncome_Client_WorkTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_SocialSecurity")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_SocialSecurity").ToString) Then
                    MonthlyIncome_Client_SocialSecurityTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_SocialSecurity").ToString, 2)
                Else
                    MonthlyIncome_Client_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_Disability")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Disability").ToString) Then
                    MonthlyIncome_Client_DisabilityTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Disability").ToString, 2)
                Else
                    MonthlyIncome_Client_DisabilityTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_RetirementPension")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_RetirementPension").ToString) Then
                    MonthlyIncome_Client_RetirementPensionTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_RetirementPension").ToString, 2)
                Else
                    MonthlyIncome_Client_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_401k")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_401k").ToString) Then
                    MonthlyIncome_Client_Retirement401kTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_401k").ToString, 2)
                Else
                    MonthlyIncome_Client_Retirement401kTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_Savings")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Savings").ToString) Then
                    MonthlyIncome_Client_SavingsCheckingsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Savings").ToString, 2)
                Else
                    MonthlyIncome_Client_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Other").ToString) Then
                    MonthlyIncome_Client_OtherAssetsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Other").ToString, 2)
                Else
                    MonthlyIncome_Client_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_OtherDebts")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_OtherDebts").ToString) Then
                    MonthlyIncome_Client_OtherDebtsTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_OtherDebts").ToString, 2)
                Else
                    MonthlyIncome_Client_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_SelfEmployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_SelfEmployed").ToString) Then
                    MonthlyIncome_Client_SelfEmployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_SelfEmployed").ToString, 2)
                Else
                    MonthlyIncome_Client_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_Unemployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_Unemployed").ToString) Then
                    MonthlyIncome_Client_UnemployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Client_Unemployed").ToString, 2)
                Else
                    MonthlyIncome_Client_UnemployedTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_JobDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_JobDescription").ToString) Then
                    MonthlyIncome_Client_JobDescriptionTextBox.Text = hard("MonthlyIncome_Client_JobDescription").ToString
                Else
                    MonthlyIncome_Client_JobDescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_FullTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_FullTime").ToString) Then
                    MonthlyIncome_Client_FullTimeCheckBox.Checked = hard("MonthlyIncome_Client_FullTime").ToString
                Else
                    MonthlyIncome_Client_FullTimeCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_PartTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_PartTime").ToString) Then
                    MonthlyIncome_Client_PartTimeCheckBox.Checked = hard("MonthlyIncome_Client_PartTime").ToString
                Else
                    MonthlyIncome_Client_PartTimeCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_Work")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Work").ToString) Then
                    MonthlyIncome_Spouse_WorkTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Work").ToString, 2)
                Else
                    MonthlyIncome_Spouse_WorkTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_SocialSecurity")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_SocialSecurity").ToString) Then
                    MonthlyIncome_Spouse_SocialSecurityTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_SocialSecurity").ToString, 2)
                Else
                    MonthlyIncome_Spouse_SocialSecurityTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_Disability")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Disability").ToString) Then
                    MonthlyIncome_Spouse_DisabilityTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Disability").ToString, 2)
                Else
                    MonthlyIncome_Spouse_DisabilityTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_RetirementPension")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_RetirementPension").ToString) Then
                    MonthlyIncome_Spouse_RetirementPensionTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_RetirementPension").ToString, 2)
                Else
                    MonthlyIncome_Spouse_RetirementPensionTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_401k")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_401k").ToString) Then
                    MonthlyIncome_Spouse_Retirement401kTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_401k").ToString, 2)
                Else
                    MonthlyIncome_Spouse_Retirement401kTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_Savings")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Savings").ToString) Then
                    MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Savings").ToString, 2)
                Else
                    MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Other").ToString) Then
                    MonthlyIncome_Spouse_OtherAssetsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Other").ToString, 2)
                Else
                    MonthlyIncome_Spouse_OtherAssetsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_OtherDebts")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_OtherDebts").ToString) Then
                    MonthlyIncome_Spouse_OtherDebtsTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_OtherDebts").ToString, 2)
                Else
                    MonthlyIncome_Spouse_OtherDebtsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_SelfEmployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_SelfEmployed").ToString) Then
                    MonthlyIncome_Spouse_SelfEmployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_SelfEmployed").ToString, 2)
                Else
                    MonthlyIncome_Spouse_SelfEmployedTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_Unemployed")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_Unemployed").ToString) Then
                    MonthlyIncome_Spouse_UnemployedTextBox.Text = FormatNumber(hard("MonthlyIncome_Spouse_Unemployed").ToString, 2)
                Else
                    MonthlyIncome_Spouse_UnemployedTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_JobDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_JobDescription").ToString) Then
                    MonthlyIncome_Spouse_JobDescriptionTextBox.Text = hard("MonthlyIncome_Spouse_JobDescription").ToString
                Else
                    MonthlyIncome_Spouse_JobDescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_FullTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_FullTime").ToString) Then
                    MonthlyIncome_Spouse_FullTimeCheckBox.Checked = hard("MonthlyIncome_Spouse_FullTime").ToString
                Else
                    MonthlyIncome_Spouse_FullTimeCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_PartTime")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_PartTime").ToString) Then
                    MonthlyIncome_Spouse_PartTimeCheckBox.Checked = hard("MonthlyIncome_Spouse_PartTime").ToString
                Else
                    MonthlyIncome_Spouse_PartTimeCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyIncome_IsRecievingStateAssistance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_IsRecievingStateAssistance").ToString) Then
                    MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked = hard("MonthlyIncome_IsRecievingStateAssistance").ToString
                Else
                    MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyIncome_IsRecievingStateAssistanceDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_IsRecievingStateAssistanceDescription").ToString) Then
                    MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text = hard("MonthlyIncome_IsRecievingStateAssistanceDescription").ToString
                Else
                    MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Rent")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Rent").ToString) Then
                    MonthlyExpenses_RentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Rent").ToString, 2)
                Else
                    MonthlyExpenses_RentTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Mortgage")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Mortgage").ToString) Then
                    MonthlyExpenses_MortgageTextBox.Text = FormatNumber(hard("MonthlyExpenses_Mortgage").ToString, 2)
                Else
                    MonthlyExpenses_MortgageTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_2ndMortgage")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_2ndMortgage").ToString) Then
                    MonthlyExpenses_2ndMortgageCheckBox.Checked = hard("MonthlyExpenses_2ndMortgage").ToString
                Else
                    MonthlyExpenses_2ndMortgageCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyExpenses_2ndMortgageAmt")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_2ndMortgageAmt").ToString) Then
                    MonthlyExpenses_2ndMortgageAmtTextBox.Text = FormatNumber(hard("MonthlyExpenses_2ndMortgageAmt").ToString, 2)
                Else
                    MonthlyExpenses_2ndMortgageAmtTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_HasClientRefinanced")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_HasClientRefinanced").ToString) Then
                    MonthlyExpenses_HasClientRefinancedCheckBox.Checked = hard("MonthlyExpenses_HasClientRefinanced").ToString
                Else
                    MonthlyExpenses_HasClientRefinancedCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyExpenses_EquityValueOfHome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_EquityValueOfHome").ToString) Then
                    MonthlyExpenses_EquityValueOfHomeTextBox.Text = FormatNumber(hard("MonthlyExpenses_EquityValueOfHome").ToString, 2)
                Else
                    MonthlyExpenses_EquityValueOfHomeTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_ReasonForDebt")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_ReasonForDebt").ToString) Then
                    MonthlyExpenses_ReasonForDebtTextBox.Text = hard("MonthlyExpenses_ReasonForDebt").ToString
                Else
                    MonthlyExpenses_ReasonForDebtTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyExpenses_DoesClientHaveAssets")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_DoesClientHaveAssets").ToString) Then
                    MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked = hard("MonthlyExpenses_DoesClientHaveAssets").ToString
                Else
                    MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Carpayment")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Carpayment").ToString) Then
                    MonthlyExpenses_CarpaymentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Carpayment").ToString, 2)
                Else
                    MonthlyExpenses_CarpaymentTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_CarInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_CarInsurance").ToString) Then
                    MonthlyExpenses_CarInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_CarInsurance").ToString, 2)
                Else
                    MonthlyExpenses_CarInsuranceTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_OweOnHome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OweOnHome").ToString) Then
                    MonthlyExpenses_OweOnHomeTextBox.Text = FormatNumber(hard("MonthlyExpenses_OweOnHome").ToString, 2)
                Else
                    MonthlyExpenses_OweOnHomeTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_DiningOut")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_DiningOut").ToString) Then
                    MonthlyExpenses_DiningOutTextBox.Text = FormatNumber(hard("MonthlyExpenses_DiningOut").ToString, 2)
                Else
                    MonthlyExpenses_DiningOutTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Entertainment")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Entertainment").ToString) Then
                    MonthlyExpenses_EntertainmentTextBox.Text = FormatNumber(hard("MonthlyExpenses_Entertainment").ToString, 2)
                Else
                    MonthlyExpenses_EntertainmentTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_PhoneCell")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_PhoneCell").ToString) Then
                    MonthlyExpenses_PhoneTextBox.Text = FormatNumber(hard("MonthlyExpenses_PhoneCell").ToString, 2)
                Else
                    MonthlyExpenses_PhoneTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_HomeInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_HomeInsurance").ToString) Then
                    MonthlyExpenses_HomeInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_HomeInsurance").ToString, 2)
                Else
                    MonthlyExpenses_HomeInsuranceTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Utilities")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Utilities").ToString) Then
                    MonthlyExpenses_UtilitiesTextBox.Text = FormatNumber(hard("MonthlyExpenses_Utilities").ToString, 2)
                Else
                    MonthlyExpenses_UtilitiesTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Groceries")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Groceries").ToString) Then
                    MonthlyExpenses_GroceriesTextBox.Text = FormatNumber(hard("MonthlyExpenses_Groceries").ToString, 2)
                Else
                    MonthlyExpenses_GroceriesTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_MedicalInsurance")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_MedicalInsurance").ToString) Then
                    MonthlyExpenses_MedicalInsuranceTextBox.Text = FormatNumber(hard("MonthlyExpenses_MedicalInsurance").ToString, 2)
                Else
                    MonthlyExpenses_MedicalInsuranceTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Medications")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Medications").ToString) Then
                    MonthlyExpenses_MedicationsTextBox.Text = FormatNumber(hard("MonthlyExpenses_Medications").ToString, 2)
                Else
                    MonthlyExpenses_MedicationsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Gasoline")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Gasoline").ToString) Then
                    MonthlyExpenses_GasolineTextBox.Text = FormatNumber(hard("MonthlyExpenses_Gasoline").ToString, 2)
                Else
                    MonthlyExpenses_GasolineTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_SchoolLoans")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_SchoolLoans").ToString) Then
                    MonthlyExpenses_SchoolLoansTextBox.Text = FormatNumber(hard("MonthlyExpenses_SchoolLoans").ToString, 2)
                Else
                    MonthlyExpenses_SchoolLoansTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Other")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other").ToString) Then
                    MonthlyExpenses_OtherTextBox.Text = FormatNumber(hard("MonthlyExpenses_Other").ToString, 2)
                Else
                    MonthlyExpenses_OtherTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_OtherDescription")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription").ToString) Then
                    MonthlyExpenses_OtherDescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription").ToString
                Else
                    MonthlyExpenses_OtherDescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_Diabetes")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Diabetes").ToString) Then
                    MedicalCondtions_Client_DiabetesCheckBox.Checked = hard("MedicalCondtions_Client_Diabetes").ToString
                Else
                    MedicalCondtions_Client_DiabetesCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_Arthritis")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Arthritis").ToString) Then
                    MedicalCondtions_Client_ArthritisCheckBox.Checked = hard("MedicalCondtions_Client_Arthritis").ToString
                Else
                    MedicalCondtions_Client_ArthritisCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_Asthma")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Asthma").ToString) Then
                    MedicalCondtions_Client_AsthmaCheckBox.Checked = hard("MedicalCondtions_Client_Asthma").ToString
                Else
                    MedicalCondtions_Client_AsthmaCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_HighBloodPressure")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_HighBloodPressure").ToString) Then
                    MedicalCondtions_Client_HighBloodPressureCheckBox.Checked = hard("MedicalCondtions_Client_HighBloodPressure").ToString
                Else
                    MedicalCondtions_Client_HighBloodPressureCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_HighCholesterol")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_HighCholesterol").ToString) Then
                    MedicalCondtions_Client_HighCholesterolCheckBox.Checked = hard("MedicalCondtions_Client_HighCholesterol").ToString
                Else
                    MedicalCondtions_Client_HighCholesterolCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_Other")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_Other").ToString) Then
                    MedicalCondtions_Client_OtherTextBox.Text = hard("MedicalCondtions_Client_Other").ToString
                Else
                    MedicalCondtions_Client_OtherTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_NumPillsTaken")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_NumPillsTaken").ToString) Then
                    MedicalCondtions_Client_NumPillsTakenTextBox.Text = hard("MedicalCondtions_Client_NumPillsTaken").ToString
                Else
                    MedicalCondtions_Client_NumPillsTakenTextBox.Text = "0"
                End If
                If Not IsDBNull(hard("MedicalCondtions_Client_History")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Client_History").ToString) Then
                    MedicalCondtions_Client_HistoryTextBox.Text = hard("MedicalCondtions_Client_History").ToString
                Else
                    MedicalCondtions_Client_HistoryTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_Diabetes")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Diabetes").ToString) Then
                    MedicalCondtions_Spouse_DiabetesCheckBox.Checked = hard("MedicalCondtions_Spouse_Diabetes").ToString
                Else
                    MedicalCondtions_Spouse_DiabetesCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_Arthritis")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Arthritis").ToString) Then
                    MedicalCondtions_Spouse_ArthritisCheckBox.Checked = hard("MedicalCondtions_Spouse_Arthritis").ToString
                Else
                    MedicalCondtions_Spouse_ArthritisCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_Asthma")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Asthma").ToString) Then
                    MedicalCondtions_Spouse_AsthmaCheckBox.Checked = hard("MedicalCondtions_Spouse_Asthma").ToString
                Else
                    MedicalCondtions_Spouse_AsthmaCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_HighBloodPressure")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_HighBloodPressure").ToString) Then
                    MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked = hard("MedicalCondtions_Spouse_HighBloodPressure").ToString
                Else
                    MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_HighCholesterol")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_HighCholesterol").ToString) Then
                    MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked = hard("MedicalCondtions_Spouse_HighCholesterol").ToString
                Else
                    MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_Other")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_Other").ToString) Then
                    MedicalCondtions_Spouse_OtherTextBox.Text = hard("MedicalCondtions_Spouse_Other").ToString
                Else
                    MedicalCondtions_Spouse_OtherTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_NumPillsTaken")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_NumPillsTaken").ToString) Then
                    MedicalCondtions_Spouse_NumPillsTakenTextBox.Text = hard("MedicalCondtions_Spouse_NumPillsTaken").ToString
                Else
                    MedicalCondtions_Spouse_NumPillsTakenTextBox.Text = "0"
                End If
                If Not IsDBNull(hard("MedicalCondtions_Spouse_History")) AndAlso Not String.IsNullOrEmpty(hard("MedicalCondtions_Spouse_History").ToString) Then
                    MedicalCondtions_Spouse_HistoryTextBox.Text = hard("MedicalCondtions_Spouse_History").ToString
                Else
                    MedicalCondtions_Spouse_HistoryTextBox.Text = ""
                End If
                If Not IsDBNull(hard("AdditionalInformation")) AndAlso Not String.IsNullOrEmpty(hard("AdditionalInformation").ToString) Then
                    AdditionalInformationTextBox.Text = hard("AdditionalInformation").ToString
                Else
                    AdditionalInformationTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyIncome_Client_DescribeOther")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Client_DescribeOther").ToString) Then
                    MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text = hard("MonthlyIncome_Client_DescribeOther").ToString
                Else
                    MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyIncome_Spouse_DescribeOther")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_Spouse_DescribeOther").ToString) Then
                    MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text = hard("MonthlyIncome_Spouse_DescribeOther").ToString
                Else
                    MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyIncome_TotalMonthlyIncome")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyIncome_TotalMonthlyIncome").ToString) Then
                    MonthlyIncome_TotalMonthlyIncomeTextBox.Text = FormatNumber(hard("MonthlyIncome_TotalMonthlyIncome").ToString, 2)
                Else
                    MonthlyIncome_TotalMonthlyIncomeTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MedicalConditions_Client_AnxietyDepression")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Client_AnxietyDepression").ToString) Then
                    MedicalConditions_Client_AnxietyDepressionCheckBox.Checked = hard("MedicalConditions_Client_AnxietyDepression").ToString
                Else
                    MedicalConditions_Client_AnxietyDepressionCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalConditions_Client_HeartCondition")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Client_HeartCondition").ToString) Then
                    MedicalConditions_Client_HeartConditionCheckBox.Checked = hard("MedicalConditions_Client_HeartCondition").ToString
                Else
                    MedicalConditions_Client_HeartConditionCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalConditions_Spouse_AnxietyDepression")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Spouse_AnxietyDepression").ToString) Then
                    MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked = hard("MedicalConditions_Spouse_AnxietyDepression").ToString
                Else
                    MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MedicalConditions_Spouse_HeartCondition")) AndAlso Not String.IsNullOrEmpty(hard("MedicalConditions_Spouse_HeartCondition").ToString) Then
                    MedicalConditions_Spouse_HeartConditionCheckBox.Checked = hard("MedicalConditions_Spouse_HeartCondition").ToString
                Else
                    MedicalConditions_Spouse_HeartConditionCheckBox.Checked = False
                End If
                If Not IsDBNull(hard("MonthlyExpenses_SchoolExpenses")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_SchoolExpenses").ToString) Then
                    MonthlyExpenses_SchoolExpensesTextBox.Text = FormatNumber(hard("MonthlyExpenses_SchoolExpenses").ToString, 2)
                Else
                    MonthlyExpenses_SchoolExpensesTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_lawfirm")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_lawfirm").ToString) Then
                    MonthlyExpenses_lawfirmTextBox.Text = FormatNumber(hard("MonthlyExpenses_lawfirm").ToString, 2)
                Else
                    MonthlyExpenses_lawfirmTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_loans")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_loans").ToString) Then
                    MonthlyExpenses_loansTextBox.Text = FormatNumber(hard("MonthlyExpenses_loans").ToString, 2)
                Else
                    MonthlyExpenses_loansTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_creditcards")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_creditcards").ToString) Then
                    MonthlyExpenses_creditcardsTextBox.Text = FormatNumber(hard("MonthlyExpenses_creditcards").ToString, 2)
                Else
                    MonthlyExpenses_creditcardsTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_OtherDescription2")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription2").ToString) Then
                    MonthlyExpenses_Other2DescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription2").ToString
                Else
                    MonthlyExpenses_Other2DescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Other2")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other2").ToString) Then
                    MonthlyExpenses_Other2TextBox.Text = FormatNumber(hard("MonthlyExpenses_Other2").ToString, 2)
                Else
                    MonthlyExpenses_Other2TextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("MonthlyExpenses_OtherDescription3")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_OtherDescription3").ToString) Then
                    MonthlyExpenses_Other3DescriptionTextBox.Text = hard("MonthlyExpenses_OtherDescription3").ToString
                Else
                    MonthlyExpenses_Other3DescriptionTextBox.Text = ""
                End If
                If Not IsDBNull(hard("MonthlyExpenses_Other3")) AndAlso Not String.IsNullOrEmpty(hard("MonthlyExpenses_Other3").ToString) Then
                    MonthlyExpenses_Other3TextBox.Text = FormatNumber(hard("MonthlyExpenses_Other3").ToString, 2)
                Else
                    MonthlyExpenses_Other3TextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("IncomeAfterExpenses")) AndAlso Not String.IsNullOrEmpty(hard("IncomeAfterExpenses").ToString) Then
                    IncomeAfterExpensesTextBox.Text = FormatNumber(hard("IncomeAfterExpenses").ToString, 2)
                Else
                    IncomeAfterExpensesTextBox.Text = FormatNumber(0, 2)
                End If
                If Not IsDBNull(hard("Monthly_TotalExpenses")) AndAlso Not String.IsNullOrEmpty(hard("Monthly_TotalExpenses").ToString) Then
                    Monthly_TotalExpensesTextBox.Text = FormatNumber(hard("Monthly_TotalExpenses").ToString, 2)
                Else
                    Monthly_TotalExpensesTextBox.Text = FormatNumber(0, 2)
                End If
                tcHistory.activetabindex = 0
                Exit For
            Next
        End Using
    End Sub

    ''' <summary>
    ''' inserts or updates a new hardship form for client
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub SaveHardshipData()
        Dim actionText As String = ""
        Dim intRows As Integer = 0
        'Dim hID = SharedFunctions.AsyncDB.executeScalar(String.Format("select hardshipid from tblhardshipdata where clientid = {0}", DataClientID), ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim cmdText As String = ""

        Using cmd As New SqlClient.SqlCommand
            cmd.CommandType = CommandType.Text
            cmd.Connection = New SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)

            'insert
            cmdText = "INSERT INTO tblHardshipData(ClientID, ClientAcctNum, HardshipDate, Married, Single, Divorced, Widowed, OwnRent, Hardship, ConcernsID, BehindID , NumChildren, NumGrandChildren, MonthlyIncome_Client_Work, MonthlyIncome_Client_SocialSecurity, MonthlyIncome_Client_Disability, MonthlyIncome_Client_RetirementPension, MonthlyIncome_Client_401K, MonthlyIncome_Client_Savings, MonthlyIncome_Client_Other, MonthlyIncome_Client_OtherDebts, MonthlyIncome_Client_SelfEmployed, MonthlyIncome_Client_Unemployed, MonthlyIncome_Client_JobDescription, MonthlyIncome_Client_FullTime, MonthlyIncome_Client_PartTime, MonthlyIncome_Spouse_Work, MonthlyIncome_Spouse_SocialSecurity, MonthlyIncome_Spouse_Disability, MonthlyIncome_Spouse_RetirementPension, MonthlyIncome_Spouse_401k, MonthlyIncome_Spouse_Savings, MonthlyIncome_Spouse_Other, MonthlyIncome_Spouse_OtherDebts, MonthlyIncome_Spouse_SelfEmployed, MonthlyIncome_Spouse_Unemployed, MonthlyIncome_Spouse_JobDescription, MonthlyIncome_Spouse_FullTime, MonthlyIncome_Spouse_PartTime, MonthlyIncome_IsRecievingStateAssistance, MonthlyIncome_IsRecievingStateAssistanceDescription, MonthlyExpenses_Rent, MonthlyExpenses_Mortgage, MonthlyExpenses_2ndMortgage, MonthlyExpenses_2ndMortgageAmt, MonthlyExpenses_HasClientRefinanced, MonthlyExpenses_EquityValueOfHome, MonthlyExpenses_ReasonForDebt, MonthlyExpenses_DoesClientHaveAssets, MonthlyExpenses_Carpayment, MonthlyExpenses_CarInsurance, MonthlyExpenses_Utilities, MonthlyExpenses_Groceries, MonthlyExpenses_OweOnHome, MonthlyExpenses_DiningOut, MonthlyExpenses_Entertainment, MonthlyExpenses_MedicalInsurance, MonthlyExpenses_Medications, MonthlyExpenses_Gasoline, MonthlyExpenses_SchoolLoans, MonthlyExpenses_HomeInsurance, MonthlyExpenses_PhoneCell, MonthlyExpenses_Other, MonthlyExpenses_OtherDescription, MedicalCondtions_Client_Diabetes, MedicalCondtions_Client_Arthritis, MedicalCondtions_Client_Asthma, MedicalCondtions_Client_HighBloodPressure, MedicalCondtions_Client_HighCholesterol, MedicalCondtions_Client_Other, MedicalCondtions_Client_NumPillsTaken, MedicalCondtions_Client_History, MedicalCondtions_Spouse_Diabetes, MedicalCondtions_Spouse_Arthritis, MedicalCondtions_Spouse_Asthma, MedicalCondtions_Spouse_HighBloodPressure, MedicalCondtions_Spouse_HighCholesterol, MedicalCondtions_Spouse_Other, MedicalCondtions_Spouse_NumPillsTaken, MedicalCondtions_Spouse_History, AdditionalInformation, Created, CreatedBy, LastModified, LastModifiedBy, MonthlyIncome_Client_DescribeOther, MonthlyIncome_Spouse_DescribeOther, MonthlyIncome_TotalMonthlyIncome, MedicalConditions_Client_AnxietyDepression, MedicalConditions_Spouse_AnxietyDepression, MedicalConditions_Client_HeartCondition, MedicalConditions_Spouse_HeartCondition, MonthlyExpenses_SchoolExpenses, MonthlyExpenses_lawfirm, MonthlyExpenses_loans, MonthlyExpenses_creditcards, MonthlyExpenses_OtherDescription2, MonthlyExpenses_Other2, MonthlyExpenses_OtherDescription3, MonthlyExpenses_Other3, IncomeAfterExpenses, Monthly_TotalExpenses) VALUES (@ClientID, @ClientAcctNum, getdate(), @Married, @Single, @Divorced, @Widowed, @OwnRent, @Hardship, @ConcernsID, @BehindID, @NumChildren, @NumGrandChildren, @MonthlyIncome_Client_Work, @MonthlyIncome_Client_SocialSecurity, @MonthlyIncome_Client_Disability, @MonthlyIncome_Client_RetirementPension, @MonthlyIncome_Client_401K, @MonthlyIncome_Client_Savings, @MonthlyIncome_Client_Other, @MonthlyIncome_Client_OtherDebts ,@MonthlyIncome_Client_SelfEmployed, @MonthlyIncome_Client_Unemployed, @MonthlyIncome_Client_JobDescription, @MonthlyIncome_Client_FullTime, @MonthlyIncome_Client_PartTime, @MonthlyIncome_Spouse_Work, @MonthlyIncome_Spouse_SocialSecurity, @MonthlyIncome_Spouse_Disability, @MonthlyIncome_Spouse_RetirementPension, @MonthlyIncome_Spouse_401k, @MonthlyIncome_Spouse_Savings, @MonthlyIncome_Spouse_Other, @MonthlyIncome_Spouse_OtherDebts, @MonthlyIncome_Spouse_SelfEmployed, @MonthlyIncome_Spouse_Unemployed, @MonthlyIncome_Spouse_JobDescription, @MonthlyIncome_Spouse_FullTime, @MonthlyIncome_Spouse_PartTime, @MonthlyIncome_IsRecievingStateAssistance, @MonthlyIncome_IsRecievingStateAssistanceDescription, @MonthlyExpenses_Rent, @MonthlyExpenses_Mortgage, @MonthlyExpenses_2ndMortgage, @MonthlyExpenses_2ndMortgageAmt, @MonthlyExpenses_HasClientRefinanced, @MonthlyExpenses_EquityValueOfHome, @MonthlyExpenses_ReasonForDebt, @MonthlyExpenses_DoesClientHaveAssets, @MonthlyExpenses_Carpayment, @MonthlyExpenses_CarInsurance, @MonthlyExpenses_Utilities, @MonthlyExpenses_Groceries, @MonthlyExpenses_OweOnHome, @MonthlyExpenses_DiningOut, @MonthlyExpenses_Entertainment, @MonthlyExpenses_MedicalInsurance, @MonthlyExpenses_Medications, @MonthlyExpenses_Gasoline, @MonthlyExpenses_SchoolLoans, @MonthlyExpenses_HomeInsurance, @MonthlyExpenses_PhoneCell, @MonthlyExpenses_Other, @MonthlyExpenses_OtherDescription, @MedicalCondtions_Client_Diabetes, @MedicalCondtions_Client_Arthritis, @MedicalCondtions_Client_Asthma, @MedicalCondtions_Client_HighBloodPressure, @MedicalCondtions_Client_HighCholesterol, @MedicalCondtions_Client_Other, @MedicalCondtions_Client_NumPillsTaken, @MedicalCondtions_Client_History, @MedicalCondtions_Spouse_Diabetes, @MedicalCondtions_Spouse_Arthritis, @MedicalCondtions_Spouse_Asthma, @MedicalCondtions_Spouse_HighBloodPressure, @MedicalCondtions_Spouse_HighCholesterol, @MedicalCondtions_Spouse_Other, @MedicalCondtions_Spouse_NumPillsTaken, @MedicalCondtions_Spouse_History, @AdditionalInformation, GETDATE(), @CreatedBy, GETDATE(), @LastModifiedBy, @MonthlyIncome_Client_DescribeOther, @MonthlyIncome_Spouse_DescribeOther, @MonthlyIncome_TotalMonthlyIncome, @MedicalConditions_Client_AnxietyDepression, @MedicalConditions_Spouse_AnxietyDepression, @MedicalConditions_Client_HeartCondition, @MedicalConditions_Spouse_HeartCondition, @MonthlyExpenses_SchoolExpenses, @MonthlyExpenses_lawfirm, @MonthlyExpenses_loans, @MonthlyExpenses_creditcards, @MonthlyExpenses_OtherDescription2, @MonthlyExpenses_Other2, @MonthlyExpenses_OtherDescription3, @MonthlyExpenses_Other3, @IncomeAfterExpenses, @Monthly_TotalExpenses)"
            cmd.CommandText = cmdText

            Dim sqlAcct As String = String.Format("select accountnumber from tblclient where clientid = {0}", DataClientID)
            Dim acctNum As String = SharedFunctions.AsyncDB.executeScalar(sqlAcct, ConfigurationManager.AppSettings("connectionstring").ToString)

            cmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", DataClientID))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@ClientAcctNum", acctNum))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Married", MarriedCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Single", SingleCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Divorced", DivorcedCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Widowed", WidowedCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@OwnRent", ddlOwnRent.SelectedItem.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Hardship", ddlHardship.SelectedItem.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@ConcernsID", ddlConcerns.SelectedItem.Value))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@BehindID", ddlBehind.SelectedItem.Value))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@NumChildren", NumChildrenTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@NumGrandChildren", NumGrandChildrenTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Work", MonthlyIncome_Client_WorkTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_SocialSecurity", MonthlyIncome_Client_SocialSecurityTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Disability", MonthlyIncome_Client_DisabilityTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_RetirementPension", MonthlyIncome_Client_RetirementPensionTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_401K", MonthlyIncome_Client_Retirement401kTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Savings", MonthlyIncome_Client_SavingsCheckingsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Other", MonthlyIncome_Client_OtherAssetsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_OtherDebts", MonthlyIncome_Client_OtherDebtsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_SelfEmployed", MonthlyIncome_Client_SelfEmployedTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_Unemployed", MonthlyIncome_Client_UnemployedTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_JobDescription", MonthlyIncome_Client_JobDescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_FullTime", MonthlyIncome_Client_FullTimeCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_PartTime", MonthlyIncome_Client_PartTimeCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_Work", MonthlyIncome_Spouse_WorkTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_SocialSecurity", MonthlyIncome_Spouse_SocialSecurityTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_Disability", MonthlyIncome_Spouse_DisabilityTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_RetirementPension", MonthlyIncome_Spouse_RetirementPensionTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_401k", MonthlyIncome_Spouse_Retirement401kTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_Other", MonthlyIncome_Spouse_OtherAssetsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_OtherDebts", MonthlyIncome_Spouse_OtherDebtsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_Savings", MonthlyIncome_Spouse_SavingsCheckingsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_SelfEmployed", MonthlyIncome_Spouse_SelfEmployedTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_Unemployed", MonthlyIncome_Spouse_UnemployedTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_JobDescription", MonthlyIncome_Spouse_JobDescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_FullTime", MonthlyIncome_Spouse_FullTimeCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_PartTime", MonthlyIncome_Spouse_PartTimeCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_IsRecievingStateAssistance", MonthlyIncome_IsRecievingStateAssistanceCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_IsRecievingStateAssistanceDescription", MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Rent", MonthlyExpenses_RentTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Mortgage", MonthlyExpenses_MortgageTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_2ndMortgage", MonthlyExpenses_2ndMortgageCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_2ndMortgageAmt", MonthlyExpenses_2ndMortgageAmtTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_HasClientRefinanced", MonthlyExpenses_HasClientRefinancedCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_EquityValueOfHome", MonthlyExpenses_EquityValueOfHomeTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_ReasonForDebt", MonthlyExpenses_ReasonForDebtTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_DoesClientHaveAssets", MonthlyExpenses_DoesClientHaveAssetsCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Carpayment", MonthlyExpenses_CarpaymentTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_CarInsurance", MonthlyExpenses_CarInsuranceTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Utilities", MonthlyExpenses_UtilitiesTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Groceries", MonthlyExpenses_GroceriesTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_OweOnHome", MonthlyExpenses_OweOnHomeTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_DiningOut", MonthlyExpenses_DiningOutTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Entertainment", MonthlyExpenses_EntertainmentTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_MedicalInsurance", MonthlyExpenses_MedicalInsuranceTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Medications", MonthlyExpenses_MedicationsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Gasoline", MonthlyExpenses_GasolineTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_SchoolLoans", MonthlyExpenses_SchoolLoansTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_HomeInsurance", MonthlyExpenses_HomeInsuranceTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_PhoneCell", MonthlyExpenses_PhoneTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Other", MonthlyExpenses_OtherTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_OtherDescription", MonthlyExpenses_OtherDescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_Diabetes", MedicalCondtions_Client_DiabetesCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_Arthritis", MedicalCondtions_Client_ArthritisCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_Asthma", MedicalCondtions_Client_AsthmaCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_HighBloodPressure", MedicalCondtions_Client_HighBloodPressureCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_HighCholesterol", MedicalCondtions_Client_HighCholesterolCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_Other", MedicalCondtions_Client_OtherTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_NumPillsTaken", Integer.Parse(Val(MedicalCondtions_Client_NumPillsTakenTextBox.Text))))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Client_History", MedicalCondtions_Client_HistoryTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_Diabetes", MedicalCondtions_Spouse_DiabetesCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_Arthritis", MedicalCondtions_Spouse_ArthritisCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_Asthma", MedicalCondtions_Spouse_AsthmaCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_HighBloodPressure", MedicalCondtions_Spouse_HighBloodPressureCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_HighCholesterol", MedicalCondtions_Spouse_HighCholesterolCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_Other", MedicalCondtions_Spouse_OtherTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_NumPillsTaken", Integer.Parse(Val(MedicalCondtions_Spouse_NumPillsTakenTextBox.Text))))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalCondtions_Spouse_History", MedicalCondtions_Spouse_HistoryTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@AdditionalInformation", AdditionalInformationTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@CreatedBy", CreatedBy))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@LastModifiedBy", CreatedBy))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Client_DescribeOther", MonthlyIncome_Client_OtherAssetsDescribeTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_Spouse_DescribeOther", MonthlyIncome_Spouse_OtherAssetsDescribeTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyIncome_TotalMonthlyIncome", MonthlyIncome_TotalMonthlyIncomeTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalConditions_Client_AnxietyDepression", MedicalConditions_Client_AnxietyDepressionCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalConditions_Spouse_AnxietyDepression", MedicalConditions_Spouse_AnxietyDepressionCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalConditions_Client_HeartCondition", MedicalConditions_Client_HeartConditionCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MedicalConditions_Spouse_HeartCondition", MedicalConditions_Spouse_HeartConditionCheckBox.Checked))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_SchoolExpenses", MonthlyExpenses_SchoolExpensesTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_lawfirm", MonthlyExpenses_lawfirmTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_loans", MonthlyExpenses_loansTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_creditcards", MonthlyExpenses_creditcardsTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_OtherDescription2", MonthlyExpenses_Other2DescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Other2", MonthlyExpenses_Other2TextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_OtherDescription3", MonthlyExpenses_Other3DescriptionTextBox.Text))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@MonthlyExpenses_Other3", MonthlyExpenses_Other3TextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@IncomeAfterExpenses", IncomeAfterExpensesTextBox.Text.Replace("$", "")))
            cmd.Parameters.Add(New SqlClient.SqlParameter("@Monthly_TotalExpenses", Monthly_TotalExpensesTextBox.Text.Replace("$", "")))

            actionText = String.Format("Hardship Form Created. Reason for debt: {0}", MonthlyExpenses_ReasonForDebtTextBox.Text)

            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()

            intRows = cmd.ExecuteNonQuery()
            If intRows > 0 Then
                'SaveForm(actionText)
                LoadHardshipData()
            End If

        End Using
    End Sub

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As System.Web.UI.Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Protected Sub hardshipControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadHardshipData()
        End If

    End Sub

    Protected Sub gvHardshipHistory_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvHardshipHistory.RowCommand
        Select Case e.CommandName
            Case "load"
                LoadHardshipDataByID(e.CommandArgument)
        End Select
    End Sub

    Protected Sub gvHardshipHistory_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHardshipHistory.RowCreated
        If e.Row.RowType = DataControlRowType.Pager Then
            SetPagerButtonStates(gvHardshipHistory, e.Row, Me.Page)
        End If
    End Sub

    Protected Sub gvHardshipHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHardshipHistory.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#F0E68C'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
        End Select
    End Sub

    ''' <summary>
    ''' save hardship document and inserts note
    ''' </summary>
    ''' <param name="noteText"></param>
    ''' <remarks></remarks>
    Private Sub SaveForm(ByVal noteText As String)
        'Publish the report to the current user's
        Dim finalReport As New GrapeCity.ActiveReports.SectionReport
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString"))
        Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
        Dim aArgs() As String = String.Format("HardshipWorksheet_{0}", DataClientID).Split("_")

        rptDoc = rptTemplates.ViewTemplate("HardshipWorksheet", DataClientID, aArgs, False, CreatedBy)
        finalReport.Document.Pages.AddRange(rptDoc.Pages)

        'Dim rpt As Infragistics.Documents.Report.Report = HarassmentHelper.ProcessHarassmentForm(harass)
        Dim clientDocPath As String = DocumentAttachment.CreateDirForClient(DataClientID)
        clientDocPath += "ClientDocs\" & DocumentAttachment.GetUniqueDocumentName("9050", DataClientID)

        Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
        Using fStream As New System.IO.FileStream(clientDocPath, FileMode.CreateNew)
            pdf.Export(finalReport.Document, fStream)
        End Using

        ''attach documents to note
        Dim intNoteID As Integer = NoteHelper.InsertNote(noteText, CreatedBy, DataClientID)
        'relate
        NoteHelper.RelateNote(intNoteID, 1, DataClientID)
        'attach
        SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(clientDocPath), CreatedBy)
        SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientID, Path.GetFileName(clientDocPath), CreatedBy, "ClientDocs")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(clientDocPath), CreatedBy, Now)
    End Sub

    Private Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        gvHardshipHistory.PageIndex = ddl.SelectedIndex
        gvHardshipHistory.DataBind()
    End Sub

#End Region 'Methods

End Class