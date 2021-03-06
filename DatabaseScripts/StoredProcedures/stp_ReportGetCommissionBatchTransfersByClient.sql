/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionBatchTransfersByClient]    Script Date: 11/19/2007 15:27:43 ******/
DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatchTransfersByClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatchTransfersByClient]
	(
		@CommBatchIDs varchar(1500),
		@CommRecID int,
		@ClientID int
	)

as

exec
(
'SELECT
	EntryType,
	[Percent],
	Amount
FROM
	(
		SELECT
			(
				SELECT
					Name
				FROM
					tblEntryType
				WHERE
					EntryTypeID = register.EntryTypeID
			) as EntryType,
			[Percent],
			comm.Amount as Amount
		FROM
			tblCommPay as comm inner join
			tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID inner join
			tblRegister as register on register.RegisterID = registerpay.FeeRegisterID inner join
			tblClient as client on client.ClientID = register.ClientID left join
			tblPerson as person on person.PersonID = client.PrimaryPersonID
		WHERE
			comm.CommBatchID in (' + @CommBatchIDs + ') and
			client.ClientID = ' + @ClientID + ' and
			CommStructID in
			(
				SELECT
					CommStructID
				FROM
					tblCommStruct
				WHERE
					CommRecID = ' + @CommRecID + '
			)

		UNION ALL

		SELECT
			(
				SELECT
					Name
				FROM
					tblEntryType
				WHERE
					EntryTypeID = register.EntryTypeID
			) as EntryType,
			[Percent],
			(-comm.Amount) as Amount
		FROM
			tblCommChargeback as comm inner join
			tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID inner join
			tblRegister as register on register.RegisterID = registerpay.FeeRegisterID inner join
			tblClient as client on client.ClientID = register.ClientID left join
			tblPerson as person on person.PersonID = client.PrimaryPersonID
		WHERE
			comm.CommBatchID in (' + @CommBatchIDs + ') and
			client.ClientID = ' + @ClientID + ' and
			CommStructID in
			(
				SELECT
					CommStructID
				FROM
					tblCommStruct
				WHERE
					CommRecID = ' + @CommRecID + '
			)
	) as derivedtable
ORDER BY
	EntryType'
)
GO
