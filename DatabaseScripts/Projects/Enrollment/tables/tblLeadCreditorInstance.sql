IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadCreditorInstance')
	BEGIN
		CREATE TABLE [dbo].[tblLeadCreditorInstance](
			[LeadCreditorInstance] [int] IDENTITY(1,1) NOT NULL,
			[LeadApplicantID] [int] NOT NULL,
			[CreditorGroupID] [int] NULL,
			[CreditorID] [int] NOT NULL,
			--[ForCreditorGroupID] [int] NULL,
			--[ForCreditorID] [int] NULL,
			[AccountNumber] [nvarchar](50) NULL,
			[Balance] [money] NULL,
			[IntRate] [money] default(0) not null,
			[MinPayment] [money] default(0) not null,
			[Name] [nvarchar](150) NULL,
			[Street] [nvarchar](150) NULL,
			[Street2] [nvarchar](50) NULL,
			[City] [nvarchar](50) NULL,
			[StateID] [int] NULL,
			[ZipCode] [nvarchar](50) NULL,
			--[ForName] [nvarchar](150) NULL,
			--[ForStreet] [nvarchar](150) NULL,
			--[ForStreet2] [nvarchar](50) NULL,
			--[ForCity] [nvarchar](50) NULL,
			--[ForStateID] [int] NULL,
			--[ForZipCode] [nvarchar](50) NULL,
			--[Phone] [varchar](20) NULL,
			--[Ext] [varchar](50) NULL,
			[Created] [datetime] NULL,
			[CreatedBy] [int] NULL,
			[Modified] [datetime] NULL,
			[ModifiedBy] [int] NULL,
		 CONSTRAINT [PK_tblLeadCreditorInstance] PRIMARY KEY CLUSTERED 
		(
			[LeadCreditorInstance] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'IntRate') begin
	alter table tblLeadCreditorInstance add [IntRate] [money] default(0) not null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'MinPayment') begin
	alter table tblLeadCreditorInstance add [MinPayment] [money] default(0) not null
end 
/*
if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForCreditorGroupID') begin
	alter table tblLeadCreditorInstance add [ForCreditorGroupID] [int] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForCreditorID') begin
	alter table tblLeadCreditorInstance add [ForCreditorID] [int] NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForName') begin
	alter table tblLeadCreditorInstance add [ForName] [nvarchar](150) NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForStreet') begin
	alter table tblLeadCreditorInstance add [ForStreet] [nvarchar](150) NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForStreet2') begin
	alter table tblLeadCreditorInstance add [ForStreet2] [nvarchar](50) NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForCity') begin
	alter table tblLeadCreditorInstance add [ForCity] [nvarchar](50) NULL
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForStateID') begin
	alter table tblLeadCreditorInstance add [ForStateID] [int] default(0) not null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'ForZipCode') begin
	alter table tblLeadCreditorInstance add [ForZipCode] [nvarchar](50) NULL
end 
*/
if not exists (select 1 from syscolumns where id = object_id('tblLeadCreditorInstance') and name = 'CreditLiabilityID') begin
	alter table tblLeadCreditorInstance add CreditLiabilityID int null
end 