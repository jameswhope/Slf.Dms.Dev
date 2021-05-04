
if not exists (select 1 from tblleadstatus where statusid = 18) begin
	set identity_insert tblleadstatus on
	insert tblleadstatus(statusid,description,created,createdby,modified,modifiedby,show)
	values (18,'Returned',getdate(),820,getdate(),820,0)	
	set identity_insert tblleadstatus off
end 

if not exists (select 1 from tblclientstatus where clientstatusid = 23) begin
	set identity_insert tblclientstatus on
	insert tblclientstatus (clientstatusid,name,code,[order],created,createdby,lastmodified,lastmodifiedby,display)
	values (23,'Returned to CID','RET',0,getdate(),820,getdate(),820,0)
	set identity_insert tblclientstatus off
end

if not exists (select 1 from tblleadstatus where statusid = 19) begin
	set identity_insert tblleadstatus on
	insert tblleadstatus (statusid,description,created,createdby,modified,modifiedby,show)
	values (19,'Return to Compliance',getdate(),820,getdate(),820,0)
	set identity_insert tblleadstatus off
end

if not exists (select 1 from tblclientstatus where clientstatusid = 24) begin
	set identity_insert tblclientstatus on
	insert tblclientstatus (clientstatusid,name,code,[order],created,createdby,lastmodified,lastmodifiedby,display)
	values (24,'Return to Compliance','RCO',0,getdate(),820,getdate(),820,0)
	set identity_insert tblclientstatus off
end