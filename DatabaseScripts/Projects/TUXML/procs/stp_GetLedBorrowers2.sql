IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetLeadBorrowers2')
	BEGIN
		DROP  Procedure  stp_GetLeadBorrowers2
	END

GO

CREATE Procedure stp_GetLeadBorrowers2
@LeadApplicantId int
AS
Begin

select l.firstname,l.lastname,l.address1[address],l.city,isnull(s.abbreviation,'')[state],l.zipcode,l.ssn,l.email,1[seq],[applicanttype]='Primary',l.dob,
lastokdate = cs.RequestDate,
xmlfile = cs.xmlfile,
cs.FileHitIndicator,
cs.Flags,
reuseid = cs.creditsourceid
from tblleadapplicant l
left join vw_lastcreditrequest_OK cs on replace(l.ssn,'-','') = cs.ssn
left join tblstate s on s.stateid=l.stateid 
where leadapplicantid = @LeadApplicantID
and len(ltrim(rtrim(replace(l.ssn,'-','')))) > 0

union all

select l.firstname,l.lastname,l.[address],l.city,isnull(s.abbreviation,'')[state],l.zipcode,l.ssn,l.email,2[seq],[applicanttype]='Co-applicant', l.dob,
lastokdate = cs.RequestDate,
xmlfile = cs.xmlfile,
cs.FileHitIndicator,
cs.Flags,
reuseid = cs.creditsourceid
from tblleadcoapplicant l 
left join vw_lastcreditrequest_OK cs on replace(l.ssn,'-','') = cs.ssn
left join tblstate s on s.stateid=l.stateid 
where leadapplicantid = @LeadApplicantID
and len(ltrim(rtrim(replace(l.ssn,'-','')))) > 0

order by seq, firstname
End
GO


