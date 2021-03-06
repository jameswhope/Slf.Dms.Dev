/****** Object:  Table [dbo].[tblCommPay]    Script Date: 11/19/2007 11:03:51 ******/

if object_id('tblCommPay') is null
begin
	CREATE TABLE [dbo].[tblCommPay]
	(
		[CommPayID] [int] IDENTITY(1,1) NOT NULL,
		[RegisterPaymentID] [int] NOT NULL,
		[CommStructID] [int] NOT NULL,
		[Percent] [money] NOT NULL,
		[Amount] [money] NOT NULL,
		[CommBatchID] [int] NULL,
		CONSTRAINT [PK_tblCommPay] PRIMARY KEY CLUSTERED 
		(
			[CommPayID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
	
	CREATE NONCLUSTERED INDEX [_dta_index_tblCommPay_7_167723700__K2_5] ON [dbo].[tblCommPay] 
	(
		[RegisterPaymentID] ASC
	)
	INCLUDE ( [Amount]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
end
GO

/*
	1/4/08	jhernandez	Added CommFeeID for reporting purposes and to track sum certain payouts.
*/
if not exists (select 1 from syscolumns where id = object_id('tblCommPay') and name = 'CommFeeID') 
begin
	alter table tblCommPay add [CommFeeID] [int] NULL 
end
go