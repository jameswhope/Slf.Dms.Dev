
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadStatus')
	BEGIN
		CREATE TABLE [tblLeadStatus]
		(
			[StatusID] [int] IDENTITY(1,1) NOT NULL,
			[Description] [nvarchar](50) NULL,
			[Created] [datetime] NULL,
			[CreatedBy] [int] NULL,
			[Modified] [datetime] NULL,
			[ModifiedBy] [nchar](10) NULL,
			CONSTRAINT [PK_tblLeadStatus] PRIMARY KEY CLUSTERED 
			(
				[StatusID] ASC
			)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END


alter table tblleadstatus add Show bit default(1) not null
alter table tblLeadStatus add StatusGroupID int null


update tblleadstatus set show = 0 where 1=1
update tblleadstatus set show = 1 where statusid in (1,2,3,6,7,10,9,8)
update tblleadstatus set description = 'Unable To Contact' where statusid = 1

set identity_insert tblleadstatus on

insert tblleadstatus (statusid,description,created,createdby,modified,modifiedby,show)
values (12,'No Sale',getdate(),820,getdate(),820,1)

insert tblleadstatus (statusid,description,created,createdby,modified,modifiedby,show)
values (13,'Left Message',getdate(),820,getdate(),820,1)

set identity_insert tblleadstatus off

-- added 2/1/2010
insert tblleadstatus (description,created,createdby,modified,modifiedby,show)
values ('New',getdate(),820,getdate(),820,0)

insert tblleadstatus (description,created,createdby,modified,modifiedby,show)
values ('Recycled',getdate(),820,getdate(),820,1)