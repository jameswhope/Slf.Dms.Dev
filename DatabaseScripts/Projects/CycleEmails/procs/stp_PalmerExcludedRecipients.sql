IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PalmerExcludedRecipients')
	DROP  Procedure  stp_PalmerExcludedRecipients
GO

create procedure stp_PalmerExcludedRecipients
as
/*
	As of 7/2/2010 we're no longer including batches from these recipients in the nacha files. This query shows
	what we didn't send to the bank.
*/

select r.display + ' ***' + right(r.accountnumber,4) [recipient],
	sum(case when b.batchdate > cast(convert(varchar(10),getdate(),101) as datetime) then cbt.amount else 0 end) [today],
	sum(case when b.batchdate > '7/2/10' then cbt.amount else 0 end) [total] -- first day these batches were withheld
from tblcommrec r
left join tblcommbatchtransfer cbt on cbt.commrecid = r.commrecid
	and cbt.companyid = 2
left join tblcommbatch b on b.commbatchid = cbt.commbatchid
where r.commrecid in (5,6,17,24,25,26,28,29)
group by r.display, r.accountnumber
order by r.display 