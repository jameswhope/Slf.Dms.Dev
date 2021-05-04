
/* Fixing old commstructs that had duplicate commrecs in them

-- here are the dups, after cleanup should be none, structures should be unqiue by these criteria
select commscenid, commrecid, parentcommrecid, companyid, count(*) 
from tblcommstruct
group by commscenid, commrecid, parentcommrecid, companyid
having count(*) > 1

-- this was causing cbt to create dup entries, commpays & commchargebacks are okay though
-- monitor this query, make sure no new dups show up
select b.batchdate, b.commbatchid, b.commscenid, commrecid, parentcommrecid, companyid, count(*)
from tblcommbatchtransfer cbt
join tblcommbatch b on b.commbatchid = cbt.commbatchid
group by b.batchdate, b.commbatchid, b.commscenid, commrecid, parentcommrecid, companyid--, amount
having count(*) > 1
order by batchdate desc

-- should be 0
select * from tblcommstruct where commstructid not in (select commstructid from tblcommfee) and parentcommstructid is not null and commrecid <> 14 -- CLauzon removed from commfee (see CLauzon_removal.sql) but not deleted from structs

*/

-- Dup commrecs in structure cleanup. commstructid's 194-197 all added on 4/14/08 to add Overnight Fee
-- to these commstruct's. Should have been attached to existing commstructid.

-- Debt Zero - Palmer (only 20 active using as of 3/3/10)
update tblcommfee set commstructid = 158, lastmodified=getdate(), lastmodifiedby = 820 where commstructid = 194
update tblcommpay set commstructid = 158 where commstructid = 194
update tblcommchargeback set commstructid = 158 where commstructid = 194
delete from tblcommstruct where commstructid = 194

-- Ebinex - Palmer (only 4 active using this commstruct as of 3/3/10)
update tblcommfee set commstructid = 165, lastmodified=getdate(), lastmodifiedby = 820 where commstructid = 195
update tblcommpay set commstructid = 165 where commstructid = 195
update tblcommchargeback set commstructid = 165 where commstructid = 195
delete from tblcommstruct where commstructid = 195 

-- Onviant - Palmer (only 34 active using as of 3/3/10)
update tblcommfee set commstructid = 170, lastmodified=getdate(), lastmodifiedby = 820 where commstructid = 196
update tblcommpay set commstructid = 170 where commstructid = 196
update tblcommchargeback set commstructid = 170 where commstructid = 196
delete from tblcommstruct where commstructid = 196

-- Smith Allen - Peavey (924 active using as of 3/3/10)
update tblcommfee set commstructid = 178, lastmodified=getdate(), lastmodifiedby = 820 where commstructid = 197
update tblcommpay set commstructid = 178 where commstructid = 197
update tblcommchargeback set commstructid = 178 where commstructid = 197
delete from tblcommstruct where commstructid = 197
update tblcommstruct set parentcommstructid = 178 where commstructid = 179


-- Other cleanup..

-- Debt Zero - Peavey (only 1 active using as of 3/3/10)
-- 788 not used in tblCommFree or any comms tables
delete from tblcommstruct where commstructid = 788

-- SLF Storm - bad structures, no parent, never used. (18 active Palmer, 1 active Peavey clients are using default scenario)
delete from tblcommfee where commstructid in (select commstructid from tblcommstruct where commscenid = 6 and companyid in (2,5))
delete from tblcommstruct where commscenid = 6 and companyid in (2,5)

-- DRF(840) - Palmer/Peavey - commstructs are not used because clients are created before this scenario's start date. Added by cor
delete from tblcommstruct where commstructid in (147,755)

-- DRF(840) 8/1/08-1/1/50 - Palmer & Peavey (0 clients created in this time frame, structures have never been used)
delete from tblcommstruct where commstructid in (229,830)

