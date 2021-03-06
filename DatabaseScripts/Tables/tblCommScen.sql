
if object_id('tblCommScen') is null 
begin
	CREATE TABLE [dbo].[tblCommScen]
	(
		[CommScenID] [int] IDENTITY(1,1) NOT NULL,
		[AgencyID] [int] NOT NULL,
		[StartDate] [datetime] NOT NULL,
		[EndDate] [datetime] NULL,
		[Default] [bit] NOT NULL CONSTRAINT [DF_tblCommScen_Default]  DEFAULT ((0)),
		[Created] [datetime] NOT NULL,
		[CreatedBy] [int] NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [int] NOT NULL,
		CONSTRAINT [PK_tblCommScen] PRIMARY KEY CLUSTERED 
		(
			[CommScenID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
end
go

/*
	2/8/08	jhernandez	Seq column used to identify scenarios during client import.
*/
if not exists (select 1 from syscolumns where id = object_id('tblCommScen') and name = 'Seq') 
begin
	alter table [dbo].[tblCommScen] add Seq int default(1) not null
end
go

update [dbo].[tblCommScen] set Seq = 1 where Seq is null
go

