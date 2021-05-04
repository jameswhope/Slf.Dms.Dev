IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'get_ClientAccountSums')
	BEGIN
		DROP  Procedure  get_ClientAccountSums
	END

GO

CREATE PROCEDURE [dbo].[get_ClientAccountSums]
(
	@clientId int,
	@settled bit=null,
	@removed bit=null
)

AS

SET NOCOUNT ON
SELECT
	sum(total.CurrentAmount) as Total,
	sum(total.OriginalAmount) as OriginalTotal,
	sum(active.CurrentAmount) as TotalActive,
	sum(active.OriginalAmount) as OriginalTotalActive
FROM
	(
		SELECT
			a.AccountID,
			sum(a.CurrentAmount) as CurrentAmount,
			sum(a.OriginalAmount) as OriginalAmount
		FROM
			tblAccount a inner join
			tblCreditorInstance ci on a.CurrentCreditorInstanceID = ci.CreditorInstanceID
		WHERE
			clientid = @clientid
			and	(
				@settled is null or 
				(@settled = 1 and not settled is null) or
				(@settled = 0 and settled is null)
			)
			and	(
				@removed is null or 
				(@removed = 1 and not removed is null) or
				(@removed = 0 and removed is null)
			)
		GROUP BY
			a.AccountID
	) as total left join
	(
		SELECT
			a.AccountID,
			sum(a.CurrentAmount) as CurrentAmount,
			sum(a.OriginalAmount) as OriginalAmount
		FROM
			tblAccount a inner join
			tblCreditorInstance ci on a.CurrentCreditorInstanceID = ci.CreditorInstanceID
		WHERE
			clientid = @clientid 
			and settled is null 
			and removed is null
			and	(
				@settled is null or 
				(@settled = 1 and not settled is null) or
				(@settled = 0 and settled is null)
			)
			and	(
				@removed is null or 
				(@removed = 1 and not removed is null) or
				(@removed = 0 and removed is null)
			)
			and a.accountstatusid <> 171
		GROUP BY
			a.AccountID
	) as active on total.AccountID = active.AccountID 


GO