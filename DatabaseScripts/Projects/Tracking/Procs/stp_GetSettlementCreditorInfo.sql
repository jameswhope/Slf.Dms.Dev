IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementCreditorInfo')
	BEGIN
		DROP  Procedure  stp_GetSettlementCreditorInfo
	END

GO

CREATE procedure [dbo].[stp_GetSettlementCreditorInfo]
	(
		@accountid int
	)

as

SELECT
	cic.CreditorInstanceID,
	a.AccountID,
	cc.Name as CreditorName,
	co.Name as ForCreditorName,
	cic.Acquired,
	a.OriginalAmount,
	a.CurrentAmount,
	cic.AccountNumber,
	cic.ReferenceNumber,
	cc.CreditorID as CreditorID,
	co.CreditorID as ForCreditorID,
	case when a.verified is null then 0 else 1 end as verified,
	a.VerifiedAmount
FROM
	tblAccount as a with(nolock) inner join
	tblCreditorInstance as cic with(nolock) on cic.CreditorInstanceID = a.CurrentCreditorInstanceID left outer join
	tblCreditorInstance as cio with(nolock) on cio.CreditorInstanceID = a.OriginalCreditorInstanceID left outer join
	tblCreditor as cc with(nolock) on cc.CreditorID = cic.CreditorID left outer join
	tblCreditor as co with(nolock) on co.CreditorID = cio.CreditorID
WHERE
	a.AccountID = @accountid

GO


GRANT EXEC ON stp_GetSettlementCreditorInfo TO PUBLIC

GO


