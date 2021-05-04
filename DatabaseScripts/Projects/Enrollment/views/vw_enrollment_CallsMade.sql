if exists (select 1 from sysobjects where name = 'vw_enrollment_CallsMade')
	drop view vw_enrollment_CallsMade
go

create view vw_enrollment_CallsMade
as

select t.leadapplicantid, count(t.callmadeid) [callsmade], min(t.created) [firstcallmade], max(t.created) [lastcallmade]
from
(
	select leadapplicantid, callmadeid , created from tblleaddialercall
	where outboundcallkey is not null
	and created >= '2012-11-02 10:00'
	UNION
	select leadapplicantid, leadnoteid,  created   from tblleadnotes 
	where NoteType = 'Phone'
	and created < '2012-11-02 10:00'
) t
group by t.leadapplicantid
