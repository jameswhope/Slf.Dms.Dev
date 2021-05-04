
alter procedure stp_NachaCabinetDups as
begin

-- Colonial entries should have 2 entries per commbatchtransferid that offset eachother in tblnacharegister.
select [type], trustid, typeid, count(typeid) [cnt]
from tblnachacabinet
where [type] = 'CommbatchTransferID'
	and trustid = 20
	-- known dups, issues already been resolved. should not need to add to this list but can if needed
	and typeid not in (
		51001,
		51662,
		56185,
		56187,
		56186,
		50487)
group by typeid, [type], trustid
having count(typeid) <> 2

union all

-- Checksite entries should have only 1 entry per commbatchtransferid. (no offset in tblnacharegister2)
select [type], trustid, typeid, count(typeid) [cnt]
from tblnachacabinet
where [type] = 'CommbatchTransferID'
	and trustid = 22
group by typeid, [type], trustid
having count(typeid) <> 1

end
go 