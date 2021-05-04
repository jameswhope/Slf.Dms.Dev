IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getConversionStats')
	BEGIN
		DROP  Procedure  stp_enrollment_getConversionStats
	END
GO

create procedure stp_enrollment_getConversionStats
as
BEGIN
	select 
		  u.firstname + ' ' + u.lastname [Name]
		, sum(case when la.statusid not in (7) then 1 else 0 end) [Pipe]
		, sum(case when la.statusid in (7) then 1 else 0 end) [Closed]
	from 
		tblleadapplicant la
	join 
		tbluser u on u.userid = la.repid
	group by 
		u.firstname + ' ' + u.lastname
END
GO