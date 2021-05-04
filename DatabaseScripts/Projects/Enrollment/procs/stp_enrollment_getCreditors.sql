IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getCreditors')
	BEGIN
		DROP  Procedure  stp_enrollment_getCreditors
	END

GO

create procedure stp_enrollment_getCreditors
(
	@applicantID int
)
as
	BEGIN
		IF @applicantID <> 0
		BEGIN
			select 
				  Name [Creditor]
				, AccountNumber
				, Balance
				, LeadCreditorInstance
				, Phone
				, Ext
				, Street
				, Street2
				, City
				, StateID
				, ZipCode
				--, isnull(ForName,'') [ForCreditor]
				--, ForStreet
				--, ForStreet2
				--, ForCity
				--, ForStateID
				--, ForZipCode
				, IntRate
				, MinPayment
			from 
				dbo.tblLeadCreditorInstance
			where
				leadApplicantID = @applicantID
			order by 
				[Creditor], AccountNumber
		END
	END