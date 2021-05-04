IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Hardship_getHardshipHistory')
	BEGIN
		DROP  Procedure  stp_Hardship_getHardshipHistory
	END

GO

CREATE Procedure stp_Hardship_getHardshipHistory
(
	@clientid int
)
as
BEGIN
	select 
		clientid
		,hardshipid
		,[User] = u.firstname + ' ' + u.lastname + '/' + ug.name
		,[Date] = hd.hardshipdate
		,[Ttl Income] = MonthlyIncome_Client_Work+MonthlyIncome_Client_SocialSecurity+MonthlyIncome_Client_Disability+MonthlyIncome_Client_RetirementPension+MonthlyIncome_Client_SelfEmployed+MonthlyIncome_Client_Unemployed+MonthlyIncome_Spouse_Work+MonthlyIncome_Spouse_SocialSecurity+MonthlyIncome_Spouse_Disability+MonthlyIncome_Spouse_RetirementPension+MonthlyIncome_Spouse_SelfEmployed+MonthlyIncome_Spouse_Unemployed
		,[Ttl Expenses] = MonthlyExpenses_Rent+MonthlyExpenses_Mortgage+MonthlyExpenses_2ndMortgageAmt+MonthlyExpenses_Carpayment+MonthlyExpenses_CarInsurance+MonthlyExpenses_Utilities+MonthlyExpenses_Groceries+MonthlyExpenses_MedicalInsurance+MonthlyExpenses_Medications+MonthlyExpenses_Gasoline+MonthlyExpenses_SchoolLoans+MonthlyExpenses_Other
		,[Medical] = case when MedicalCondtions_Client_Diabetes = 1 OR MedicalCondtions_Client_Arthritis = 1 OR MedicalCondtions_Client_Asthma = 1 OR MedicalCondtions_Client_HighBloodPressure = 1 OR MedicalCondtions_Client_HighCholesterol = 1 OR MedicalCondtions_Client_Other <> '' 
		or MedicalCondtions_spouse_Diabetes = 1 OR MedicalCondtions_spouse_Arthritis = 1 OR MedicalCondtions_spouse_Asthma = 1 OR MedicalCondtions_spouse_HighBloodPressure = 1 OR MedicalCondtions_spouse_HighCholesterol = 1 OR MedicalCondtions_spouse_Other <> '' THEN 'Y' ELSE 'N' END
		,[Summary] = rtrim(ltrim(MedicalCondtions_Client_History + case when MedicalCondtions_Spouse_History <> '' then '  [Spouse]: ' + MedicalCondtions_Spouse_History else '' end))
	from 
		tblhardshipdata hd
		inner join tbluser u on u.userid=hd.createdby
		inner join tblusergroup ug on ug.usergroupid = u.usergroupid
	where 
		clientid = @clientid
	order by 
		hardshipdate desc
END

GO


GRANT EXEC ON stp_Hardship_getHardshipHistory TO PUBLIC

GO


