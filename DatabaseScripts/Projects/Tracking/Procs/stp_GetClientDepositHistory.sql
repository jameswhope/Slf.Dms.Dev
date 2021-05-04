IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetClientDepositHistory')
	BEGIN
		DROP  Procedure  stp_GetClientDepositHistory
	END

EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[stp_GetClientDepositHistory]
	(
		@clientid int,
		@top int
	)

as

SELECT TOP (@top)
	*
FROM
	(
		SELECT
			''Deposit'' as DepositType,
			*
		FROM
			tblRegister
		WHERE
			ClientID = @clientid
			and EntryTypeID = 3
			and AdjustedRegisterID is null
			and RegisterID not in
				(
					SELECT
						r.RegisterID
					FROM
						tblRuleACH as ra
						inner join tblRegister as r on r.ClientID = ra.ClientID and r.TransactionDate between ra.StartDate and ra.EndDate
					WHERE
						ra.ClientID = @clientid
						and r.EntryTypeID = 3
						and r.AdjustedRegisterID is null

					UNION ALL

					SELECT
						r.RegisterID
					FROM
						tblRegister as r inner join
						tblAdHocACH as a on a.RegisterID = r.RegisterID
					WHERE
						a.ClientID = @clientid
						and r.AdjustedRegisterID is null
				)

		UNION ALL

		SELECT
			''Rule'' as DepositType,
			r.*
		FROM
			tblRuleACH as ra
			inner join tblRegister as r on r.ClientID = ra.ClientID and r.TransactionDate between ra.StartDate and ra.EndDate
		WHERE
			ra.ClientID = @clientid
			and r.EntryTypeID = 3
			and r.AdjustedRegisterID is null

		UNION ALL

		SELECT
			''Additional'' as DepositType,
			r.*
		FROM
			tblRegister as r inner join
			tblAdHocACH as a on a.RegisterID = r.RegisterID
		WHERE
			a.ClientID = @clientid
			and r.AdjustedRegisterID is null
	) as deposits
	inner join tblClient as c on c.ClientID = deposits.ClientID
ORDER BY
	TransactionDate DESC

' 
	
GRANT EXEC ON stp_GetClientDepositHistory TO PUBLIC


