/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionBatchPaymentsSummary_seideman]    Script Date: 11/19/2007 15:27:42 ******/
DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatchPaymentsSummary_seideman]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatchPaymentsSummary_seideman]
	(
		@CommRecIDs varchar(255),
		@date1 datetime=null,
		@date2 datetime=null
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

exec
(
	'select
		ut.AgencyId,
		ut.Agency,	
		ut.EntryTypeId,
		ut.FeeType,
		ut.AmountPaid,
		tt.commrec,
		tt.commrecid,
		tt.parentcommrecid,
		tt.amount,
		tt.transferamount,
		ut.commstructid
	from
		(
			select
				r.abbreviation as commrec,
				bt.commrecid,
				bt.parentcommrecid,
				sum(bt.amount) as amount,
				sum(bt.transferamount) as transferamount
			from
				tblcommbatch b inner join
				tblcommbatchtransfer bt on b.commbatchid = bt.commbatchid inner join
				tblcommrec r on bt.commrecid = r.commrecid
			where
				( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
				( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) and
				r.CommRecId IN (' + @CommRecIds + ') and
				((select top 1 commstructid from tblcommpay where commbatchid = bt.commbatchid) < 56)
			group by
				r.abbreviation,
				bt.commrecid,
				bt.parentcommrecid
		)
		as tt left join
		(
			SELECT
				AgencyId,
				Agency,	
				EntryTypeId,
				FeeType,
				CommRec,
				CommRecId,
				ParentCommRecId,
				sum(Amount) as AmountPaid,
				commstructid as commstructid
			FROM
				(
				SELECT 
					tblCommPay.Amount,
					
					tblAgency.AgencyId,
					tblAgency.Name as Agency,

					tblEntryType.EntryTypeId,
					tblEntryType.Name as FeeType,

					tblCommRec.Abbreviation as CommRec,
					tblCommStruct.CommRecId,
					tblCommStruct.ParentCommRecId,
					tblCommStruct.commstructid as commstructid
				FROM
					tblCommPay INNER JOIN
					tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
					tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID INNER JOIN
					tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN
					tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
					tblRegister tblFeeRegister ON tblRegisterPayment.FeeRegisterId=tblFeeRegister.RegisterId INNER JOIN
					tblEntryType ON tblFeeRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
					tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
					tblCommBatch on tblCommPay.CommBatchId=tblCommBatch.CommBatchId

				WHERE
					( CAST(CONVERT(varchar(15), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
					( CAST(CONVERT(varchar(15), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
					tblCommRec.CommRecId IN (' + @CommRecIds + ')
				
				UNION ALL

				SELECT 
					-tblCommPay.Amount as amount,
							tblAgency.AgencyId,
					tblAgency.Name as Agency,

					tblEntryType.EntryTypeId,
					tblEntryType.Name as FeeType,

					tblCommRec.Abbreviation as CommRec,
					tblCommStruct.CommRecId,
					tblCommStruct.ParentCommRecId,
					tblCommStruct.commstructid as commstructid
				FROM
					tblCommChargeBack tblCommPay INNER JOIN
					tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
					tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID INNER JOIN
					tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN
					tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
					tblRegister tblFeeRegister ON tblRegisterPayment.FeeRegisterId=tblFeeRegister.RegisterId INNER JOIN
					tblEntryType ON tblFeeRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
					tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
					tblCommBatch on tblCommPay.CommBatchId=tblCommBatch.CommBatchId

				WHERE
					( CAST(CONVERT(varchar(15), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
					( CAST(CONVERT(varchar(15), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
					tblCommRec.CommRecId IN (' + @CommRecIds + ')
				)
				derivetbl
			GROUP BY
				EntryTypeId,FeeType,Agency,CommRec,AgencyId,CommRecId,ParentCommRecId,commstructid
		)
		as ut on tt.commrecid = ut.commrecid and tt.parentcommrecid = ut.parentcommrecid
	WHERE
		commstructid < 56 or tt.parentcommrecid in (3, 11, 15)
	ORDER BY
		Agency,EntryTypeId,tt.CommRecID'
)
GO
