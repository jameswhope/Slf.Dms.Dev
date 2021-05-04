ALTER view [dbo].[vw_CreditLiabilitiesFiltered]
as
select r.leadapplicantid, l.*, 
loantypedescription = isnull(tl.description,'Unknown')
from tblcreditliability l
join tblcreditreport r on r.reportid = l.reportid	
left join tblTUloanType tl on tl.typecode = l.loantype
where l.accounttype <> 'Mortgage' 
--and l.accountstatus <> 'closed'
--and isnull(tl.exclude, 0) = 0  
