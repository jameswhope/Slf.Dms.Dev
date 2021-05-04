
if object_id('tblLeadReasons') is null begin
	create table tblLeadReasons
	(
		[LeadReasonsID] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](50) NOT NULL,
		[ReasonType] [nvarchar](50) NULL, -- not used
		[StatusID] int,
		[DisplayOrder] [int] NULL,
		[Created] [datetime] default(getdate()) NOT NULL,
		[CreatedBy] [int] NOT NULL,
		primary key (LeadReasonsID),
		foreign key (StatusID) references tblLeadStatus(StatusID) on delete no action
	)
end

if not exists (select 1 from tblLeadReasons where statusid = 8) begin
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'No Income',1,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Secured Debt',2,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Student Loans',3,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'IRS',4,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Unqualified State',5,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Age',6,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Corporate Debt',7,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (8,'Loan Modification',8,820)
end

if not exists (select 1 from tblLeadReasons where statusid = 12) begin
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Damage To Credit',1,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Fees',2,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Trust',3,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Cannot Contact',4,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Spouse/Partner objects',5,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'BK/Competitor/Other',6,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Not Interested',7,820)
	insert tblLeadReasons (statusid,description,displayorder,createdby) values (12,'Signed/Cancelled',8,820)
end
 
if not exists (select 1 from tblLeadReasons where statusid = 14) begin -- Bad Lead
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Did not fill out form',14,1,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Wrong Number',14,2,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Disconnected Number',14,3,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Bad email',14,4,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Applying for job',14,5,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Applying for loan',14,6,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Applying for grant',14,7,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Applying for credit card',14,8,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Duplicate lead',14,9,getdate(),820)
	insert tblleadreasons (description,statusid,displayorder,created,createdby) values ('Other',14,10,getdate(),820)
end