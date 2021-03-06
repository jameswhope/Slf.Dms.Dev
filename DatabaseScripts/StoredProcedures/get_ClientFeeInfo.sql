/****** Object:  StoredProcedure [dbo].[get_ClientFeeInfo]    Script Date: 11/19/2007 15:26:47 ******/
DROP PROCEDURE [dbo].[get_ClientFeeInfo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[get_ClientFeeInfo]
(
	@clientId int
)

AS

SET NOCOUNT ON

SELECT
	SetupFee,
	SetupFeePercentage,
	SettlementFeePercentage,
	MonthlyFee,
	AdditionalAccountFee,
	ReturnedCheckFee,
	OvernightDeliveryFee
FROM
	tblClient
WHERE
	ClientId=@clientId
GO
