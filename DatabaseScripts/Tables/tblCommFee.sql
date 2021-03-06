/****** Object:  Table [dbo].[tblCommFee]    Script Date: 11/19/2007 11:03:50 ******/

if object_id('tblCommFee') is null 
begin
	CREATE TABLE [dbo].[tblCommFee](
		[CommFeeID] [int] IDENTITY(1,1) NOT NULL,
		[CommStructID] [int] NOT NULL,
		[EntryTypeID] [int] NOT NULL,
		[Percent] [money] NOT NULL,
		[Created] [datetime] NOT NULL,
		[CreatedBy] [int] NOT NULL,
		[LastModified] [datetime] NOT NULL,
		[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblCommFee] PRIMARY KEY CLUSTERED 
		(
			[CommFeeID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
end

/*
	1/3/08	jhernandez	Flag will allow sum certain amounts to be stored in column Percent.
*/
if not exists (select 1 from syscolumns where id = object_id('tblCommFee') and name = 'IsPercent') 
begin
	alter table tblCommFee add [IsPercent] bit default(1)	
end
go

update tblCommFee set IsPercent = 1 where IsPercent is null
go

/*
	1/3/08	jhernandez	Future use. Allows payment order to be defined by fee type.
*/
if not exists (select 1 from syscolumns where id = object_id('tblCommFee') and name = 'Order') 
begin
	alter table tblCommFee add [Order] int default(0)
end
go

update tblCommFee set [Order] = 0 where [Order] is null
go
