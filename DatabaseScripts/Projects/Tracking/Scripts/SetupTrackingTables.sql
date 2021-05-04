IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeCredit')
	BEGIN
		ALTER TABLE [tblSettlements] ADD SettlementFeeCredit money
	END	

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblUser' AND column_name='Manager')
	BEGIN
		ALTER TABLE tblUser ADD [Manager] [bit] NOT NULL DEFAULT ((0))
	END	
 
 IF NOT EXISTS (SELECT * FROM tblusergroup WHERE Usergroupid = 22)
	BEGIN
		SET IDENTITY_INSERT tblusergroup ON
		Insert into tblusergroup (UsergroupID,Name,created,createdby,lastmodified, lastmodifiedby)
		values (22,'Creditor Services Processing',getdate(),750,getdate(),750)
	END
	
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblUserGroup' AND column_name='DefaultPage')
	BEGIN
		ALTER TABLE tblUserGroup ADD DefaultPage varchar(50)
	END
go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblNegotiationColumn' AND column_name='Seq')
	BEGIN
		ALTER TABLE tblNegotiationColumn ADD Seq int
	END
go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblNegotiationColumn' AND column_name='UserGroupID')
	BEGIN
		ALTER TABLE tblNegotiationColumn ADD UserGroupID int
	END
go 


-- Tabs for Outbound
update tblNegotiationColumn set UserGroupID = 4
update tblNegotiationColumn set Seq = 1 where Name = 'Home'
update tblNegotiationColumn set Seq = 2 where Name = 'Negotiation'
update tblNegotiationColumn set Seq = 3 where Name = 'Assignment'
update tblNegotiationColumn set Seq = 4 where Name = 'Statistics'

	
UPDATE tblUserGroup SET DefaultPage = '~/processing' WHERE UserGroupID = 22
UPDATE tblUserGroup SET DefaultPage = '~/negotiation' WHERE UserGroupID = 4