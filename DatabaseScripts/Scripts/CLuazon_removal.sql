
update tblcommfee set [percent] = 1 where commfeeid = 91 and commstructid = 38 -- Lexxiom 30% -> 100%  Rtr Fee
update tblcommfee set [percent] = 1 where commfeeid = 94 and commstructid = 38 -- Lexxiom 75% -> 100%  Settl Fee
delete from tblcommfee where commfeeid in (96,97) and commstructid = 39 -- Remove CLauzon

update tblcommfee set [percent] = 1 where commfeeid = 83 and commstructid = 34 -- Lexxiom 10% -> 100%  Rtr Fee
delete from tblcommfee where commfeeid in (88) and commstructid = 35 -- Remove CLauzon

update tblcommfee set [percent] = 1 where commfeeid = 75 and commstructid = 30 -- Lexxiom 30% -> 100%  Rtr Fee
delete from tblcommfee where commfeeid in (80) and commstructid = 31 -- Remove CLauzon

-- dunno why these scenarios were ever created, never used
delete from tblcommfee where commstructid in (select commstructid from tblcommstruct where commscenid = 7 and companyid in (3,6))
delete from tblcommstruct where commscenid = 7 and companyid in (3,6)

-- update commpay so CLauzon doesnt show up on the Batch Payments Summary reports
update tblcommpay
set commstructid = 38 -- Lexxiom
from tblcommpay c 
join tblregisterpayment rp on rp.registerpaymentid = c.registerpaymentid
join tblregister r on r.registerid = rp.feeregisterid
where commstructid = 39
and r.entrytypeid = 4
and year(rp.paymentdate) = 2010

/*
-- shouldnt have ran this, Lexxiom already has the correct Gross Deposit amount in nacha, we're just not cutting a check to CLauzon
-- updated commpay/chargeback so Net Payments in Batch Pay Summ is correct
update tblcommbatchtransfer
set commrecid = 4, parentcommrecid = 11
from tblcommbatchtransfer cbt
join tblcommbatch b on b.commbatchid = cbt.commbatchid 
where cbt.commrecid = 14
and year(b.batchdate) = 2010

-- fixing above update
update tblcommbatchtransfer
set commrecid = -1, parentcommrecid = 4 -- CLauzon
from tblcommbatchtransfer cbt
join tblcommbatch b on b.commbatchid = cbt.commbatchid 
where cbt.commrecid = 4 and parentcommrecid = 11 and [order] = 0 -- [order]=0 are the CLauzon ones that got updated
and year(b.batchdate) = 2010

-- update 3/24/10
-- on 3/3/10 the -1 transactions got re-batched becuase they were never in nachacabinet/nacharegister for when
-- stp_CollectACHCommission does its check (line 80-99)
-- Since lexxiom kept this money these transactions needed to be added to nachacabinet
select distinct typeid -- should be 9
from tblNachaCabinet
where lower(type) = 'commbatchtransferid'
and typeid in (75993
,78215
,78395
,81849
,82072
,82390
,82588
,83123 -- all of the above were meant for CLauzon
,83128)
*/