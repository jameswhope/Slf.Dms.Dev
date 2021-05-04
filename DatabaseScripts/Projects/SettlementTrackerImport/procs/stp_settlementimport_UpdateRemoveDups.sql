IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_UpdateRemoveDups')
	BEGIN
		DROP  Procedure  stp_settlementimport_UpdateRemoveDups
	END

GO

CREATE Procedure stp_settlementimport_UpdateRemoveDups
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
declare @tblsett table (settid numeric, count float)

insert into @tblsett
select settlementid, count(*) 
from tblsettlementtrackerimports 
group by settlementid
having count(*) > 1

declare @tbldups table(RowNum int,settlementid numeric, trackerimportid numeric)
declare @tblmoredup table (clientacctnumber numeric,name varchar(200),currentcreditor varchar(500),creditoraccountnum varchar(50), rowCnt int)
declare @tbltids table (RowNum int,clientacctnumber numeric,name varchar(200),currentcreditor  varchar(200),creditoraccountnum  varchar(200),rowCnt int,trackerimportid numeric)

insert into @tbldups
select row_number () over(PARTITION BY settlementid order by trackerimportid desc)[RowNum] ,settlementid,trackerimportid from tblsettlementtrackerimports
where settlementid in (select settid from @tblsett)

delete from tblsettlementtrackerimports where trackerimportid in (select trackerimportid from @tbldups where rownum <> 1)

insert into @tblmoredup
select clientacctnumber, name, currentcreditor, creditoraccountnum, count(*)
from tblsettlementtrackerimports sti
group by clientacctnumber, name, currentcreditor, creditoraccountnum
having count(*) > 1
order by clientacctnumber, name, currentcreditor, creditoraccountnum

insert into @tbltids
select row_number () over(PARTITION BY sti.currentcreditor order by sti.trackerimportid desc)[RowNum],md.*,sti.trackerimportid
from tblsettlementtrackerimports sti 
inner join @tblmoredup md on md.clientacctnumber = sti.clientacctnumber and md.currentcreditor = sti.currentcreditor
and md.creditoraccountnum = sti.creditoraccountnum

delete from tblsettlementtrackerimports where trackerimportid in (select trackerimportid from  @tbltids where rownum <> 1)


declare @tblsettids table (settid numeric)

insert into @tblsettids 
select settlementid from tblsettlements with(nolock) where active = 0 and status = 'a'

delete from tblSettlementTrackerImports where settlementid in(select settid from @tblsettids )

GO


GRANT EXEC ON stp_settlementimport_UpdateRemoveDups TO PUBLIC

GO


