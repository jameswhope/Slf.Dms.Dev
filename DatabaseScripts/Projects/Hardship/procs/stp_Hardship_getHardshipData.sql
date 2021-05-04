IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Hardship_getHardshipData')
	BEGIN
		DROP  Procedure  stp_Hardship_getHardshipData
	END

GO

CREATE procedure [dbo].[stp_Hardship_getHardshipData]
(
@clientID int
)
as
BEGIN
	SELECT TOP 1 HardshipID, ClientID, ClientAcctNum, HardshipDate, CSR, Married, Single, Divorced, Widowed, NumChildren, NumGrandChildren, MonthlyIncome_Client_Work, 
		  MonthlyIncome_Client_SocialSecurity, MonthlyIncome_Client_Disability, MonthlyIncome_Client_RetirementPension, MonthlyIncome_Client_SelfEmployed, 
		  MonthlyIncome_Client_Unemployed, MonthlyIncome_Client_JobDescription, MonthlyIncome_Client_FullTime, MonthlyIncome_Client_PartTime, 
		  MonthlyIncome_Spouse_Work, MonthlyIncome_Spouse_SocialSecurity, MonthlyIncome_Spouse_Disability, MonthlyIncome_Spouse_RetirementPension, 
		  MonthlyIncome_Spouse_SelfEmployed, MonthlyIncome_Spouse_Unemployed, MonthlyIncome_Spouse_JobDescription, MonthlyIncome_Spouse_FullTime, 
		  MonthlyIncome_Spouse_PartTime, MonthlyIncome_IsRecievingStateAssistance, MonthlyIncome_IsRecievingStateAssistanceDescription, MonthlyExpenses_Rent, 
		  MonthlyExpenses_Mortgage, MonthlyExpenses_2ndMortgage, MonthlyExpenses_2ndMortgageAmt, MonthlyExpenses_HasClientRefinanced, 
		  MonthlyExpenses_EquityValueOfHome, MonthlyExpenses_ReasonForDebt, MonthlyExpenses_DoesClientHaveAssets, MonthlyExpenses_Carpayment, 
		  MonthlyExpenses_CarInsurance, MonthlyExpenses_Utilities, MonthlyExpenses_Groceries, MonthlyExpenses_MedicalInsurance, MonthlyExpenses_Medications, 
		  MonthlyExpenses_Gasoline, MonthlyExpenses_SchoolLoans, MonthlyExpenses_Other, MonthlyExpenses_OtherDescription, MedicalCondtions_Client_Diabetes, 
		  MedicalCondtions_Client_Arthritis, MedicalCondtions_Client_Asthma, MedicalCondtions_Client_HighBloodPressure, MedicalCondtions_Client_HighCholesterol, 
		  MedicalCondtions_Client_Other, MedicalCondtions_Client_NumPillsTaken, MedicalCondtions_Client_History, MedicalCondtions_Spouse_Diabetes, 
		  MedicalCondtions_Spouse_Arthritis, MedicalCondtions_Spouse_Asthma, MedicalCondtions_Spouse_HighBloodPressure, MedicalCondtions_Spouse_HighCholesterol,
		  MedicalCondtions_Spouse_Other, MedicalCondtions_Spouse_NumPillsTaken, MedicalCondtions_Spouse_History, AdditionalInformation
	FROM tblHardshipData AS hd
	WHERE ClientID = @clientid
	ORDER BY HardshipDate desc
END


GRANT EXEC ON stp_Hardship_getHardshipData TO PUBLIC


