
create procedure stp_GetLeadBorrowers
(
	@LeadApplicantID int
)
as
begin

select firstname,lastname,address1[address],city,isnull(abbreviation,'')[state],zipcode,ssn,1[seq]
from tblleadapplicant l
left join tblstate s on s.stateid=l.stateid 
where leadapplicantid = @LeadApplicantID

union all

select firstname,lastname,[address],city,isnull(abbreviation,'')[state],zipcode,ssn,2[seq]
from tblleadcoapplicant l 
left join tblstate s on s.stateid=l.stateid 
where leadapplicantid = @LeadApplicantID

order by seq, firstname

end
go 