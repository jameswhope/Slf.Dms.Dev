﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTransferredClients')
	BEGIN
		DROP  Procedure  stp_GetTransferredClients
	END
GO

create procedure stp_GetTransferredClients
(
	@UserID int = -1
)
as
begin

	select c.clientid, c.accountnumber, p.firstname + ' ' + p.lastname[client], 
		c.created [statuscreated],
		c.depositstartdate, co.shortconame[company], g.name[language],
		case 
			when lsa.completed is not null then '16x16_pdf.png'
			when lsa.leadapplicantid is not null then '16x16_pdf_grey.png'
			else 'spacer.gif' end [LSAImg],
		case 
			when ver.completed is not null then '16x16_check.png'
			when ver.leadapplicantid is not null then '16x16_check_grey.png'
			else 'spacer.gif' end [VerImg],
		case 
			when lpv.stepcompleted is not null then '16x16_blue_check.png'
			else 'spacer.gif' end [LPVImg]
	from tblclient c
	join tblimportedclient i on i.importid = c.serviceimportid
	join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
	join tblperson p on p.personid = c.primarypersonid
	join tblcompany co on co.companyid = c.companyid
	join tbllanguage g on g.languageid = p.languageid
	left join vw_enrollment_LSA_complete lsa on lsa.leadapplicantid = l.leadapplicantid
	left join vw_enrollment_Ver_complete ver on ver.leadapplicantid = l.leadapplicantid
	left join tblLeadVerificationSheet lpv on lpv.leadapplicantid = l.leadapplicantid and lpv.stepindex = 3
	where ((c.AssignedUnderwriter is null and @UserID = -1) or (c.AssignedUnderwriter = @UserID))
	and c.currentclientstatusid in (7,23,24) -- Recieved LSA, Returned to CID, Return to Compliance
	and l.statusid in (10,19) -- In Process, Return to Compliance
	order by [statuscreated]

end
go 