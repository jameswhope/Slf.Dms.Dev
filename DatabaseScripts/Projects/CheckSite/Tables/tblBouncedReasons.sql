IF col_length('tblBouncedReasons', 'ChargeFee') is null 
begin
	Alter table tblBouncedReasons Add ChargeFee bit not null default 0
End 
 
GO

IF  col_length('tblBouncedReasons', 'ChargeFee') is not null	 
Begin	
	Declare @codes table(Code varchar(4), CodeDescription varchar(255))
	
	Insert into @codes(Code, CodeDescription)
	Values ('R01', 'Insufficient Funds')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R02', 'Account Closed')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R03', 'No Account/Unable to Locate Account')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R04', 'Invalid Account Number')
		
	Insert into @codes(Code, CodeDescription)
	Values ('R06', 'Returned per Originating Depository Financial Institution Request')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R07', 'Authorization Revoked by Customer')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R08', 'Payment Stopped')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R09', 'Uncollected Funds')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R10', 'Customer Advises not Authorized')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R11', 'Check Truncation Entry Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R12', 'Branch Sold to Another Depository Financial Institution')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R13', 'R.D.F.I. not Qualified to Participate (A.C.H. operator initiated)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R14', 'Representative Payee (account holder) Deceased or Unable to Continue in that Capacity')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R15', 'Beneficiary or Account Holder (other than a representative payee) Deceased')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R16', 'Account Frozen')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R17', 'File Record Edit Criteria')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R18', 'Improper Effective Entry Date (A.C.H. operator initiated)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R19', 'Amount Field Error (A.C.H. operator initiated)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R20', 'Non-transaction Account')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R21', 'Invalid Company Identification')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R22', 'Invalid Individual I.D. Number')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R23', 'Credit Entry Refused by Receiver')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R24', 'Duplicate Entry')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R25', 'Addenda Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R26', 'Mandatory Field Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R27', 'Trace Number Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R28', 'Routing Number Check Digit Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R29', 'Corporate Customer Advises not Authorized (CCD)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R30', 'R.D.F.I. not Participant in Check Truncation Program')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R31', 'Permissible return entry (CCD)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R32', 'R.D.F.I. Non-Settlement')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R33', 'Return of XCK Entry')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R34', 'Limited Participation D.F.I.')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R35', 'Return of Improper Debit Entry')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R36', 'Return of Improper Credit Entry')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R37', 'Source Document Presented for Payment (adjustment entries) (A.R.C.)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R38', 'Stop Payment on Source Document (adjustment entries)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R39', 'Improper Source Document')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R40', 'Non Participant in E.N.R. Program')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R41', 'Invalid Transaction Code (E.N.R. only)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R42', 'Routing Number/Check Digit Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R43', 'Invalid D.F.I. Account Number')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R44', 'Invalid Individual I.D. Number')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R45', 'Invalid Individual Name')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R46', 'Invalid Representative Payee Indicator')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R47', 'Duplicate Enrollment')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R50', 'State Law Prohibits Truncated Checks')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R51', 'Notice not Provided/Signature not Authentic/Item Altered/Ineligible for Conversion')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R52', 'Stop Pay on Item')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R53', 'Item and A.C.H. Entry Presented for Payment')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R61', 'Misrouted Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R67', 'Duplicate Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R68', 'Untimely Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R69', 'Field Errors')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R70', 'Permissible Return Entry Not Accepted')
		
	Insert into @codes(Code, CodeDescription)
	Values ('R71', 'Misrouted Dishonor Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R72', 'Untimely Dishonored Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R73', 'Timely Original Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R74', 'Corrected Return')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R75', 'Original Return not a Duplicate')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R76', 'No Errors Found')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R80', 'Cross-Border Payment Coding Error')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R81', 'Non-Participant in Cross-Border Program')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R82', 'Invalid Foreign Receiving D.F.I. Identification')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R83', 'Foreign Receiving D.F.I. Unable to Settle')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R84', 'Entry Not Processed by O.G.O.')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0A', 'NSF - Not Sufficient Funds')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0B', 'UCF  - Uncollected Funds Hold')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0C', 'Stop Payment')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0D', 'Closed Account')
	 
	Insert into @codes(Code, CodeDescription)
	Values ('R0E', 'UTLA - Unable to Locate Account')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0F', 'Frozen/Blocked Account')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0G', 'Stale Dated')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0H', 'Post Dated')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0I', 'Endorsement Missing')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0J', 'Endorsement Irregular')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0K', 'Signature(s) Missing')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0L', 'Signature(s) Irregular')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0M', 'Non-Cash Item (Non-Negotiable)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0O', 'Unable to Process (e.g. Mutilated Item)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0P', 'Not Authorized')
		
	Insert into @codes(Code, CodeDescription)
	Values ('R0R', 'Branch/Account Sold (Wrong Bank)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0S', 'Refer to Maker')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0T', 'Stop Payment Suspect')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0U', 'Unusable Image (Image could not be used for required business purpose)')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0V', 'Image fails security check')
	
	Insert into @codes(Code, CodeDescription)
	Values ('R0W', 'Cannot Determine Amount')

	declare @bouncedid int
	select @bouncedid = max(bouncedid) from tblBouncedReasons
	
	Insert into tblBouncedReasons(BouncedId, BouncedCode, BouncedDescription)
	Select -1, Code, CodeDescription
	From @codes
	Where Code not in (Select BouncedCode from tblBouncedReasons)
		 
	Update tblBouncedReasons Set
	@bouncedid = bouncedid = @bouncedId + 1
	where bouncedid = -1 


	Update tblBouncedReasons Set
	ChargeFee = 1
	where BouncedCode in ('R01', 'R02', 'R07', 'R08', 'R10', 'R0A', 'R0C', 'R0D', 'R0P') 
	
end

	

	

	