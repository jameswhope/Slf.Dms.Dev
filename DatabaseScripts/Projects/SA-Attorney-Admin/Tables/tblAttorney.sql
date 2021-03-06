/****** Object:  Table [dbo].[tblAttorney]    Script Date: 11/19/2007 11:02:58 ******/

if object_id('tblAttorney') is null begin
	CREATE TABLE [dbo].[tblAttorney](
		[AttorneyID] [int] IDENTITY(1,1) NOT NULL,
		--[CompanyId] [int] NOT NULL,  -- Moved to tblAttyRelation
		--[States] [nvarchar](100) NOT NULL,  -- Moved to tblAttyStates
		--[StateID] [int] NULL,  -- Not used
		[FirstName] [nvarchar](50) NOT NULL,
		[LastName] [nvarchar](50) NOT NULL,
		[MiddleName] [nvarchar](50) NULL,
		[Suffix] [nvarchar](50) NULL,
		[Address1] [nvarchar](150) NULL,
		[Address2] [nvarchar](150) NULL,
		[City] [nvarchar](50) NULL,
		[State] [nvarchar](50) NULL,
		[Zip] [nvarchar](15) NULL,
		[Phone1] [nvarchar](15) NULL,
		[Phone2] [nvarchar](15) NULL,
		[Fax] [nvarchar](15) NULL,
		[UserID] [int] NULL,
		[Created] [datetime] NOT NULL,
		[CreatedBy] [int] NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [int] NOT NULL,
		--[StatePrimary] [bit] NULL  -- Moved to tblAttyRelation
	) ON [PRIMARY]
end


/*
	11/30/07	jhernandez		Adding primary key
*/
if not exists (select c.COLUMN_NAME from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk , INFORMATION_SCHEMA.KEY_COLUMN_USAGE c where pk.TABLE_NAME = 'tblAttorney' and CONSTRAINT_TYPE = 'PRIMARY KEY' and c.TABLE_NAME = pk.TABLE_NAME and c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME) begin
	alter table tblAttorney add primary key (AttorneyID)
end