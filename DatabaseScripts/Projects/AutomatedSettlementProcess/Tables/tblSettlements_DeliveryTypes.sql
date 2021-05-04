IF  EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements_DeliveryTypes')
	BEGIN
		drop table 	tblSettlements_DeliveryTypes
	END

CREATE TABLE [dbo].[tblSettlements_DeliveryTypes](
			[DeliveryTypeID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[Name] [varchar](50) NOT NULL,
			[Value] [varchar](10) NOT NULL,
		 CONSTRAINT [PK_tblSettlements_DeliveryTypes] PRIMARY KEY CLUSTERED 
		(
			[DeliveryTypeID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
GRANT SELECT ON tblSettlements_DeliveryTypes TO PUBLIC


INSERT INTO [tblSettlements_DeliveryTypes] ([Name],[Value])VALUES ('Check','chk')
INSERT INTO [tblSettlements_DeliveryTypes] ([Name],[Value])VALUES ('Check By Email','chkbyemail')
INSERT INTO [tblSettlements_DeliveryTypes] ([Name],[Value])VALUES ('Check By Phone','chkbytel')


