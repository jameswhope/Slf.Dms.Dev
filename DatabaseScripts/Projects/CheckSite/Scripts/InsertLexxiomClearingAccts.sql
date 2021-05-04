
set identity_insert tblTrust on

-- General Clearing Account
if not exists (select 1 from tblTrust where TrustId = 22) begin
	insert tblTrust (TrustId,[Name],[Default],City,StateID,RoutingNumber,AccountNumber,Created,CreatedBy,LastModified,LastModifiedBy,Display,DisplayName)
	values (22,'Operating Account',0,'',0,0,0,getdate(),0,getdate(),0,1,'Bank of America')
end

-- Creditor Clearing Account
if not exists (select 1 from tblTrust where TrustId = 23) begin
	insert tblTrust (TrustId,[Name],[Default],City,StateID,RoutingNumber,AccountNumber,Created,CreatedBy,LastModified,LastModifiedBy,Display,DisplayName)
	values (23,'Disbursement Account',0,'',0,'0','0',getdate(),0,getdate(),0,1,'Lexxiom Creditor Clearing Account')
end

set identity_insert tblTrust off

