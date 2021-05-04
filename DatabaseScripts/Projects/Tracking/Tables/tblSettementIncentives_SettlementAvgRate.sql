IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettementIncentives_SettlementAvgRate')
	BEGIN
		DROP  Table tblSettementIncentives_SettlementAvgRate
	END
GO

CREATE TABLE [dbo].[tblSettementIncentives_SettlementAvgRate](
	[RatePercentID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[AvgSettlementPercentageStartRange] [numeric](18, 0) NOT NULL,
	[AvgSettlementPercentageEndRange] [numeric](18, 0) NOT NULL,
	[SettlementPercentageRate] [float] NOT NULL
) ON [PRIMARY]

INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 0, '29', '20' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 30, '34', '10' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 35, '39', '5' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 40, '49', '0' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 50, '54', '-15' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 55, '64', '-25' 
INSERT INTO [tblSettementIncentives_SettlementAvgRate] ([AvgSettlementPercentageStartRange],[AvgSettlementPercentageEndRange],[SettlementPercentageRate])  SELECT 65, '100', '-50' 

GRANT SELECT ON tblSettementIncentives_SettlementAvgRate TO PUBLIC
