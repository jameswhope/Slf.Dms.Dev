if exists (select * from sysobjects where name = 'stp_LoadScenario')
	drop procedure stp_LoadScenario
go

create procedure stp_LoadScenario
(
	@CommScenID int,
	@CompanyID int
)
as
begin

declare @IsPercent bit
set @IsPercent = 1

-- output table 0
select distinct
	e.EntryTypeID
,	e.DisplayName [EntryType]
from
	tblCommFee f
	join tblCommStruct s on s.CommStructID = f.CommStructID and s.CommScenID = @CommScenID and s.CompanyID = @CompanyID
	join tblEntryType e on e.EntryTypeID = f.EntryTypeID
order by
	e.DisplayName

-- output table 1
select
	s.CommStructID
,	s.CommScenID
,	-1 [CommRecID]
,	-1 [ParentCommRecID]
,	s.[Order]
,	'Master Account' [CommRec]
,	'Deposit Account' [ParentCommRec]
,	r.Abbreviation [CommRec]
,	p.Abbreviation [ParentCommRec]
,	s.Created
from
	tblCommStruct s
	join tblCommRec r on r.CommRecID = s.CommRecID
	join tblCommRec p on p.CommRecID = s.ParentCommRecID
where
	s.CommScenID = @CommScenID 
	and s.CompanyID = @CompanyID
	and s.ParentCommStructID is null
order by
	s.[Order]

-- output table 2
select 
	f.EntryTypeID
,	f.CommFeeID
,	f.CommStructID
,	isnull(s.ParentCommStructID, -1) [ParentCommStructID]
,	r.CommRecTypeID
,	r.CommRecID
--,	p.CommRecID [ParentCommRecID]
,	r.Abbreviation [CommRec]
--,	p.Abbreviation [ParentCommRec]
,	f.[Percent]
,	@IsPercent [IsPercent]
,	r.Display [CommRecFull]
from
	tblCommFee f
	join tblCommStruct s on s.CommStructID = f.CommStructID and s.CommScenID = @CommScenID and s.CompanyID = @CompanyID
	join tblCommRec r on r.CommRecID = s.CommRecID
	--join tblCommRec p on p.CommRecID = s.ParentCommRecID
order by
	f.EntryTypeID


end
go