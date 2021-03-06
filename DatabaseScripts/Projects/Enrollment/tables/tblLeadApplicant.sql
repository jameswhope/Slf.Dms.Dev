if object_id('tblLeadApplicant') is null 
	begin
		CREATE TABLE [dbo].[tblLeadApplicant]
		(
			[LeadApplicantID] [int] IDENTITY(1,1) NOT NULL,
			[Prefix] [varchar](5) NULL,
			[FirstName] [nvarchar](100) NOT NULL,
			[MiddleName] [nvarchar](50) NULL,
			[LastName] [nvarchar](100) NOT NULL,
			[FullName] [nvarchar](200) NULL,
			[Address1] [nvarchar](150) NULL,
			[City] [nvarchar](50) NULL,
			[StateID] [int] NULL,
			[ZipCode] [nvarchar](50) NULL,
			[HomePhone] [nvarchar](20) NULL,
			[BusinessPhone] [nvarchar](50) NULL,
			[CellPhone] [nvarchar](20) NULL,
			[FaxNumber] [nvarchar](20) NULL,
			[Email] [nvarchar](50) NULL,
			[SSN] [nvarchar](12) NULL,
			[DOB] [datetime] NULL,
			[ConcernsID] [int] NOT NULL,
			[LeadSourceID] [int] NULL,
			[CompanyID] [int] NULL,
			[LanguageID] [int] NULL,
			[DeliveryID] [int] NULL,
			[RepID] [int] NULL,
			[StatusID] [int] NULL,
			[ReasonID] [int] NULL,
			[ReasonOther] [nvarchar] (300) NULL,
			[BankRoutingNumber] [nvarchar](9) NULL,
			[BankAccountNumber] [nvarchar](50) NULL,
			[BankAccountType] [nvarchar](50) NULL,
			[NameOnAccount] [nvarchar](300) NULL,
			[NotesID] [int] NULL,
			[LeadTransferInDate] [datetime] NULL,
			[LeadTransferOutDate] [datetime] NULL,
			[Created] [datetime] NULL,
			[CreatedByID] [int] NULL,
			[LastModified] [datetime] NULL,
			[LastModifiedByID] [int] NULL,
			[DebtAmount] [decimal](18, 2) NULL,
			[BehindID] [int] NULL,
			[PaperLeadCode] [varchar](50) NULL,
		 CONSTRAINT [PK_tblLeadApplicant] PRIMARY KEY CLUSTERED 
		(
			[LeadApplicantID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'PaperLeadCode') begin
	alter table tblLeadApplicant add PaperLeadCode varchar(50) null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Processor') begin
	alter table tblLeadApplicant add Processor int null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'ProcAssigned') begin
	alter table tblLeadApplicant add ProcAssigned datetime null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'ReasonID') begin
	alter table tblLeadApplicant add ReasonID int null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'ProductID') begin
	alter table tblLeadApplicant add ProductID int null
	alter table tblLeadApplicant add foreign key (ProductID) references tblLeadProducts(ProductID) on delete no action
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'AffiliateID') begin
	alter table tblLeadApplicant add AffiliateID int null
	alter table tblLeadApplicant add foreign key (AffiliateID) references tblLeadAffiliates(AffiliateID) on delete no action
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Referrer') begin
	alter table tblLeadApplicant add Referrer varchar(100) null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'RemoteAddr') begin
	alter table tblLeadApplicant add RemoteAddr varchar(20) null
end 

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Cost') begin
	alter table tblLeadApplicant add Cost money null
end

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'ReasonOther') begin
	alter table tblleadapplicant add ReasonOther varchar(300) null
end

if not exists (select 1 from syscolumns where id = object_id('tblLeadApplicant') and name = 'Refund') begin
	alter table tblleadapplicant add Refund bit default(0) not null
	alter table tblleadapplicant add RefundDate datetime null
end