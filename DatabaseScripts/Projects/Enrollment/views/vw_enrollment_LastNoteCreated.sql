IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollment_LastNoteCreated')
	drop view vw_enrollment_LastNoteCreated
GO

create view vw_enrollment_LastNoteCreated
as

	select leadapplicantid, count(*) [numnotes], max(created) [lastnotecreated], max(leadnoteid) [lastnoteid]
	from tblleadnotes
	group by leadapplicantid
