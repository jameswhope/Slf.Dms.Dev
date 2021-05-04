 
set identity_insert tblEntryType on

if not exists (select 1 from tblEntryType where EntryTypeId = 44) begin
	insert tblEntryType (EntryTypeId,type,name,displayname,fee,created,createdby,lastmodified,lastmodifiedby,system)
	values (44,'Debit','Transfer Withdrawal','Transfer Withdrawal',0,getdate(),1,getdate(),1,0)
end

if not exists (select 1 from tblEntryType where EntryTypeId = 45) begin
	insert tblEntryType (EntryTypeId,type,name,displayname,fee,created,createdby,lastmodified,lastmodifiedby,system)
	values (45,'Credit','Transfer Deposit','Transfer Deposit',0,getdate(),1,getdate(),1,0)
end

if not exists (select 1 from tblEntryType where EntryTypeId = 46) begin
	insert tblEntryType (EntryTypeId,type,name,displayname,fee,created,createdby,lastmodified,lastmodifiedby,system)
	values (46,'Debit','Reversal Withdrawal','Reversal Withdrawal',0,getdate(),1,getdate(),1,0)
end

if not exists (select 1 from tblEntryType where EntryTypeId = 47) begin
	insert tblEntryType (EntryTypeId,type,name,displayname,fee,created,createdby,lastmodified,lastmodifiedby,system)
	values (47,'Credit','Reversal Deposit','Reversal Deposit',0,getdate(),1,getdate(),1,0)
end

set identity_insert tblEntryType off