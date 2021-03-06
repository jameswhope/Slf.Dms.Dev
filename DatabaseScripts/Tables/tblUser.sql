/****** Object:  Table [dbo].[tblUser]    Script Date: 11/19/2007 11:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
if object_id('tblUser') is null begin
	CREATE TABLE [dbo].[tblUser](
		[UserID] [int] IDENTITY(1,1) NOT NULL,
		[UserName] [varchar](50) NOT NULL,
		[Password] [varchar](50) NOT NULL,
		[FirstName] [varchar](50) NOT NULL,
		[LastName] [varchar](50) NOT NULL,
		[EmailAddress] [varchar](50) NOT NULL,
		[SuperUser] [bit] NOT NULL CONSTRAINT [DF_tblUser_SuperUser]  DEFAULT (0),
		[Locked] [bit] NOT NULL CONSTRAINT [DF_tblUser_Locked]  DEFAULT (0),
		[Temporary] [bit] NOT NULL,
		[System] [bit] NOT NULL CONSTRAINT [DF_tblUser_System]  DEFAULT (0),
		[Created] [datetime] NOT NULL,
		[CreatedBy] [int] NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [int] NOT NULL,
		[UserTypeId] [int] NOT NULL,
		[UserGroupID] [int] NULL,
		[CommRecID] [int] NULL,
	 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
	(
		[UserID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
end
GO
SET ANSI_PADDING OFF
GO


if not exists (select 1 from syscolumns where id = object_id('tblUser') and name = 'Manager') begin
	alter table tblUser add Manager bit not null default(0)
end