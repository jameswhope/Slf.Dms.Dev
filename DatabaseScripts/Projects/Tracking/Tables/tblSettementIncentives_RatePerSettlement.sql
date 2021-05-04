IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettementIncentives_RatePerSettlement')
	BEGIN
		DROP  Table tblSettementIncentives_RatePerSettlement
	END
GO

CREATE TABLE [dbo].[tblSettementIncentives_RatePerSettlement](
	[RateID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SettlementUnits] [numeric](18, 0) NOT NULL,
	[Rate] [float] NOT NULL,
	[BeginRange] [numeric](18, 0) NULL,
	[EndRange] [numeric](18, 0) NULL
) ON [PRIMARY]

INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 30, '5', '0', '39' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 40, '8', '40', '49' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 50, '10', '50', '59' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 60, '14', '60', '69' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 70, '17', '70', '79' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 80, '19', '80', '89' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 90, '21', '90', '99' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 100, '23', '100', '109' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 110, '24', '110', '119' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 120, '25', '120', '139' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 140, '26', '140', '149' 
INSERT INTO tblSettementIncentives_RatePerSettlement ([SettlementUnits],[Rate],[BeginRange],[EndRange])  SELECT 150, '30', '150', '9999' 

GRANT SELECT ON tblSettementIncentives_RatePerSettlement TO PUBLIC

