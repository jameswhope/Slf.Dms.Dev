IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblleadapplicant')
 BEGIN
	IF col_length('tblleadapplicant', 'lastreportid') is null
		Alter table tblleadapplicant Add LastReportId int null 
 END
go
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblleadapplicant')
BEGIN
	IF col_length('tblleadapplicant', 'lastreportid') is not null
	update tblleadapplicant set
	lastreportid = r2.reportid
	from tblleadapplicant l
	join ( 
	select r1.* from
	(select r.reportid, r.leadapplicantid, ranked = rank() over (partition by r.leadapplicantid order by r.requestdate desc) 
	from tblcreditreport r 
	where r.leadapplicantid <> 0) r1
	where r1.ranked = 1) r2 on r2.leadapplicantid = l.leadapplicantid
END