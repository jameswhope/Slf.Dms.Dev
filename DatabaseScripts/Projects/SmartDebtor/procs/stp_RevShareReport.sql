IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_RevShareReport')
	drop procedure  stp_RevShareReport
GO

create procedure stp_RevShareReport
as

select datename(m,startdate) + ' ' + datename(yy,startdate) [monthyr],
	total_leads [Total Leads], rev_shares [Rev Share Leads], rev_shares_closed [Rev Shares Closed],
	standard_leads [Standard Leads], new_leads [New Rev Shares], attempted_contact [Attempted Contact],
	Contacted, rev_shares_closed_pct [Pct Rev Shares Closed], rev_shares_contact_pct [Pct Rev Shares Contacted],
	rev_shares_cost [Marketing Budget Spent]
from tblRevShareReport 
order by startdate desc

select datename(m,startdate) + ' ' + datename(yy,startdate) [monthyr], servicefee,
	total_leads [Total Leads], rev_shares [Rev Share Leads], rev_shares_closed [Rev Shares Closed],
	standard_leads [Standard Leads], new_leads [New Rev Shares], attempted_contact [Attempted Contact],
	Contacted, rev_shares_closed_pct [Pct Rev Shares Closed], rev_shares_contact_pct [Pct Rev Shares Contacted],
	rev_shares_cost [Marketing Budget Spent] 
from tblRevShareReportByFee
order by startdate desc, servicefee

select datename(m,startdate) + ' ' + datename(yy,startdate) [monthyr], servicefee, createddate,
	total_leads [Total Leads], rev_shares [Rev Share Leads], rev_shares_closed [Rev Shares Closed],
	standard_leads [Standard Leads], new_leads [New Rev Shares], attempted_contact [Attempted Contact],
	Contacted, rev_shares_closed_pct [Pct Rev Shares Closed], rev_shares_contact_pct [Pct Rev Shares Contacted],
	rev_shares_cost [Marketing Budget Spent] 
from tblRevShareReportDetail
order by startdate desc, servicefee, createddate
