IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadSources')
	BEGIN
CREATE TABLE [dbo].[tblLeadSources](
	[LeadSourceID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Address] [nvarchar](150) NULL,
	[City] [nvarchar](50) NULL,
	[StateID] [int] NULL,
	[ZipCode] [nvarchar](20) NULL,
	[Phone1] [nvarchar](20) NULL,
	[Phone2] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[Contact] [nvarchar](150) NULL,
	[Created] [datetime] NULL,
	[CreatedByID] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedByID] [int] NULL,
 CONSTRAINT [PK_tblLeadSources] PRIMARY KEY CLUSTERED 
(
	[LeadSourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	END

if not exists (select 1 from syscolumns where id = object_id('tblLeadSources') and name = 'Show') begin
	alter table tblleadsources add Show bit default(1) not null
end
go

-- Mossler LP, Barker LP
update tblleadsources set show = 0 where leadsourceid in (7,8)
go

