
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

-- Tabs for Bulk
insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Home','~/negotiation/bulk/default.aspx','~/negotiation/images/hometab_off.png','~/negotiation/images/hometab_on.png',25,60,1,23)

insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Negotiation','~/negotiation/bulk/bulklistA.aspx','~/negotiation/images/negotiationtab_off.png','~/negotiation/images/negotiationtab_on.png',25,97,2,23)

insert tblNegotiationColumn (Name,Path,ImagePath,OverImagePath,Height,Width,Seq,UserGroupID)
values ('Assignment','~/negotiation/assignments/default.aspx','~/negotiation/images/assignmentstab_off.png','~/negotiation/images/assignmentstab_on.png',25,97,3,23)
