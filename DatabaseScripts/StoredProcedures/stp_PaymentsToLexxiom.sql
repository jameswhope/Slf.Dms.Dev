USE [DMS]
GO
/****** Object:  StoredProcedure [dbo].[stp_PaymentsToLexxiom]    Script Date: 08/20/2010 15:34:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stp_PaymentsToLexxiom '6/8/10', '6/9/10', 856

ALTER procedure [dbo].[stp_PaymentsToLexxiom]
(
	@from datetime,
	@to datetime,
	@agencyid int
)
as
begin


SELECT
	clientid,
	Amount,	
	AgencyId,
	Agency,
	EntryTypeId,
	FeeType,
	CommRec,
	CommRecId,
	ParentCommRecId,
	company
into 
	#temp
from (
	SELECT 
		tblFeeRegister.clientid,
		tblCommPay.Amount,	
		tblAgency.AgencyId,
		tblAgency.Name as Agency,
		tblEntryType.EntryTypeId,
		tblEntryType.DisplayName as FeeType,
		tblCommRec.Abbreviation as CommRec,
		tblCommStruct.CommRecId,
		tblCommStruct.ParentCommRecId,
		c.shortconame [company]
	FROM
		tblCommPay INNER JOIN
		tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID  INNER JOIN
		tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN
		tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
		tblRegister tblFeeRegister ON tblRegisterPayment.FeeRegisterId=tblFeeRegister.RegisterId INNER JOIN
		tblEntryType ON tblFeeRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
		tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
		tblCommBatch on tblCommPay.CommBatchId=tblCommBatch.CommBatchId join
		tblcompany c on c.companyid = tblcommstruct.companyid
	WHERE
		tblCommBatch.BatchDate between @from and @to
		and tblCommRec.CommRecId IN (4,27)
		and tblagency.agencyid = @agencyid

	UNION ALL

	SELECT 
		tblFeeRegister.clientid,
		-tblCommPay.Amount as amount,
		tblAgency.AgencyId,
		tblAgency.Name as Agency,
		tblEntryType.EntryTypeId,
		tblEntryType.DisplayName as FeeType,
		tblCommRec.Abbreviation as CommRec,
		tblCommStruct.CommRecId,
		tblCommStruct.ParentCommRecId,
		c.shortconame [company]
	FROM
		tblCommChargeBack tblCommPay INNER JOIN
		tblRegisterPayment ON tblCommPay.RegisterPaymentID=tblRegisterPayment.RegisterPaymentID INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructID INNER JOIN
		tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN
		tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
		tblRegister tblFeeRegister ON tblRegisterPayment.FeeRegisterId=tblFeeRegister.RegisterId INNER JOIN
		tblEntryType ON tblFeeRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
		tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
		tblCommBatch on tblCommPay.CommBatchId=tblCommBatch.CommBatchId join
		tblcompany c on c.companyid = tblcommstruct.companyid
	WHERE
		tblCommBatch.BatchDate between @from and @to
		and tblCommRec.CommRecId IN (4,27)
		and tblagency.agencyid = @agencyid
) d


SELECT
	AgencyId,
	Agency,	
	Company,
	EntryTypeId,
	FeeType,
	CommRec,
	CommRecId,
	ParentCommRecId,
	sum(Amount) as AmountPaid
into 
	#payments
FROM
	#temp
GROUP BY
	EntryTypeId,FeeType,Agency,CommRec,AgencyId,CommRecId,ParentCommRecId,company



-- output
select distinct feetype
from #payments
order by feetype

select distinct company
from #payments
order by company

select * 
from #payments 
order by agency, company, feetype

-- client detail
select 
	c.accountnumber [Account],
	p.firstname + ' ' + p.lastname [Client],
	t.company [Firm],
	sum(case when amount > 0 then amount else 0 end) [Payments],
	sum(case when amount < 0 then amount else 0 end) [Chargebacks],
	sum(amount) [Net Payments]
from #temp t
join tblclient c on c.clientid = t.clientid
join tblperson p on p.personid = c.primarypersonid
group by c.accountnumber, p.firstname, p.lastname, t.company
order by t.company, p.firstname, p.lastname


drop table #payments
drop table #temp


end
 