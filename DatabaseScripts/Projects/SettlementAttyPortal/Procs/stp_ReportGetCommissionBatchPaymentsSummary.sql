DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatchPaymentsSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatchPaymentsSummary]
	(
		@CommRecIDs varchar(255),
		@date1 datetime=null,
		@date2 datetime=null,
		@CompanyID varchar(3)
	)

as
/* ------------------------------------------------------------------------------------------------
	History:
	jhernandez		12/10/08	Hotfix: Selecting batches into temp table to ensure only distinct
								batches are counted.
-------------------------------------------------------------------------------------------------*/

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')
	
declare @CommRecIDsPipe varchar(255)
select @CommRecIDsPipe = replace(@CommRecIDs,',','|')

exec
(
	'
	create table #batches
	(
		commbatchid int,
		commbatchtransferid int,
		commrec varchar(50),
		commrecid int,
		parentcommrecid int,
		amount money,
		transferamount money
	)
	
	insert
		#batches
	select distinct
		b.commbatchid,
		bt.commbatchtransferid,
		r.abbreviation as commrec,
		bt.commrecid,
		bt.parentcommrecid,
		bt.amount,
		bt.transferamount
	from
		tblcommbatch b inner join
		tblcommbatchtransfer bt on b.commbatchid = bt.commbatchid inner join
		tblcommrec r on bt.commrecid = r.commrecid and r.CommRecId IN (' + @CommRecIds + ') join
		tblcommscen s on s.commscenid = b.commscenid join
		tblcommstruct cs on cs.commscenid = s.commscenid 
			and cs.companyid = ' + @CompanyID + ' 
			and cs.commrecid = bt.commrecid 
			and cs.parentcommrecid = bt.parentcommrecid
			and cs.companyid = bt.companyid
	where
		( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
		( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) 
	
	
	-- Exception #1: Avert(29) did not have its own commstructs back then
	if (cast(''' + @date1 + ''' as datetime) < cast(''10/24/2008'' as datetime) and (charindex(''29'',''' + @CommRecIdsPipe + ''') > 0 or ' + @CommRecIdsPipe + ' = 29)) begin
		insert
			#batches
		select distinct
			b.commbatchid,
			bt.commbatchtransferid,
			r.abbreviation as commrec,
			bt.commrecid,
			bt.parentcommrecid,
			bt.amount,
			bt.transferamount
		from
			tblcommbatch b inner join
			tblcommbatchtransfer bt on b.commbatchid = bt.commbatchid inner join
			tblcommrec r on bt.commrecid = r.commrecid
		where
			( CAST(CONVERT(char(10), b.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
			( CAST(CONVERT(char(10), b.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) and
			r.CommRecId IN (29) and
			bt.companyid = ' + @CompanyID + '
	end
	
	
	-- Exception #2: Lexxiom > TSLF OA prior to PSM companyid overhaul release
	if (cast(''' + @date1 + ''' as datetime) < cast(''11/10/2008'' as datetime) and (charindex(''3|'',''' + @CommRecIdsPipe + ''') > 0 or ' + @CommRecIdsPipe + ' = 3) and ' + @CompanyID + ' = 2) begin
		insert
			#batches
		select distinct
			b.commbatchid,
			bt.commbatchtransferid,
			r.abbreviation as commrec,
			bt.commrecid,
			bt.parentcommrecid,
			bt.amount,
			bt.transferamount
		from
			tblcommbatch b inner join
			tblcommbatchtransfer bt on b.commbatchid = bt.commbatchid inner join
			tblcommrec r on bt.commrecid = r.commrecid and r.CommRecId IN (3) join
			tblcommscen s on s.commscenid = b.commscenid join
			tblcommstruct cs on cs.commscenid = s.commscenid 
				and cs.companyid = 2 
				and cs.commrecid = bt.commrecid 
				and cs.parentcommrecid = bt.parentcommrecid
				and cs.parentcommrecid = 4
		where
			( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
			( CAST(CONVERT(varchar(15), b.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) 
	end
		
	
	select
		ut.AgencyId,
		ut.Agency,	
		ut.EntryTypeId,
		ut.FeeType,
		ut.AmountPaid,
		tt.commrec,
		tt.commrecid,
		tt.parentcommrecid,
		tt.amount,
		tt.transferamount--,
		--ut.commstructid
	from
		(
			select distinct
				commrec,
				commrecid,
				parentcommrecid,
				sum(amount) [amount],
				sum(transferamount) [transferamount]
			from
				#batches
			group by
				commrec,
				commrecid,
				parentcommrecid
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
				sum(Amount) as AmountPaid--,
				--commstructid as commstructid
			FROM
				(
				SELECT 
					tblCommPay.Amount,
					
					tblAgency.AgencyId,
					tblAgency.Name as Agency,

					tblEntryType.EntryTypeId,
					tblEntryType.DisplayName as FeeType,

					tblCommRec.Abbreviation as CommRec,
					tblCommStruct.CommRecId,
					tblCommStruct.ParentCommRecId--,
					--tblCommStruct.commstructid as commstructid
				FROM
					tblCommPay INNER JOIN
					tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
					tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID and tblCommStruct.CompanyID = ' + @CompanyID + ' INNER JOIN
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
					tblEntryType.DisplayName as FeeType,

					tblCommRec.Abbreviation as CommRec,
					tblCommStruct.CommRecId,
					tblCommStruct.ParentCommRecId--,
					--tblCommStruct.commstructid as commstructid
				FROM
					tblCommChargeBack tblCommPay INNER JOIN
					tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
					tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID and tblCommStruct.CompanyID = ' + @CompanyID + ' INNER JOIN
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
				EntryTypeId,FeeType,Agency,CommRec,AgencyId,CommRecId,ParentCommRecId--,commstructid
		)
		as ut on tt.commrecid = ut.commrecid and
		(
			(
				tt.parentcommrecid = ut.parentcommrecid
			)
			or
			(
				tt.parentcommrecid is null and
				ut.parentcommrecid is null
			)
		)
	ORDER BY
		Agency,EntryTypeId,tt.CommRecID'
)
GO
