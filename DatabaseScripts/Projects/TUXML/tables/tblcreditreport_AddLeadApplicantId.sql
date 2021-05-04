IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblcreditreport')
 BEGIN
	IF col_length('tblcreditreport', 'leadapplicantid') is null
		Alter table tblcreditreport Add leadapplicantid int not null default 0
		
	IF col_length('tblcreditreport', 'ErrorMessage') is null
		Alter table tblcreditreport Add ErrorMessage varchar(max) null
 END
 
go 
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblcreditreport')
BEGIN 
	IF col_length('tblcreditreport', 'leadapplicantid') is not null
		 update tblcreditreport set
		leadapplicantid = b.leadapplicantid
		from tblcreditreport t
		inner join
		(select a.*
		from (
		select r.reportid, l.leadapplicantid, ranked = rank() over (partition by r.reportid order by l.leadapplicantid) 
		from tblcreditreport r 
		join tblcreditsource s on r.reportid = s.reportid
		join tblleadapplicant l on s.ssn = replace(l.ssn,'-','')) a
		where a.ranked = 1) b on t.reportid = b.reportid 
END