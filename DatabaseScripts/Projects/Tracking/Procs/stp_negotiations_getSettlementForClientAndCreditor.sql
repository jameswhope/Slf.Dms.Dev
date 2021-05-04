IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_negotiations_getSettlementForClientAndCreditor')
	BEGIN
		DROP  Procedure  stp_negotiations_getSettlementForClientAndCreditor
	END

GO

CREATE Procedure stp_negotiations_getSettlementForClientAndCreditor
	(
		@clientid int,
		@creditoraccountid int
	)

AS
BEGIN
	SELECT
		[SettlementID],
		[OfferDirection],
		[CreditorAccountBalance],
		[SettlementPercent],
		[SettlementAmount],
		[SettlementDueDate],
		[SettlementSavings],
		[SettlementFee],
		[SettlementCost],
		[Status],
		[Created],
		[OfferDirection],
		[IsPaymentArrangement]
	FROM
		[tblSettlements] WITH (NOLOCK)
	WHERE
		CreditorAccountID = @creditoraccountid AND
		clientid = @clientid
	ORDER BY
		[Created] DESC
	OPTION (FAST 5)
END

GO

GRANT EXEC ON stp_negotiations_getSettlementForClientAndCreditor TO PUBLIC

GO


