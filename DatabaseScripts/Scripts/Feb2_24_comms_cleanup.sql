
-- Cleanup from use of invalid commstructs (commstructs that had dup commrecs)
-- Only cleaning this up to get the Batch Payments Summary report numbers to jive

-- 2/4/2010
-- TSLF OA got double what they should have 
--update tblcommpay
--set amount = amount * 2
--where commbatchid = 17108
--and commstructid = 166
--
--update tblcommchargeback
--set amount = amount * 2
--where commbatchid = 17108
--and commstructid = 166

-- Lexxiom also got an extra 57.28 because of an invalid record in cbt(79829). Going to assign this amount to one of the 
-- registerpayments in this commbatch
--insert tblcommpay (registerpaymentid,commstructid,[percent],amount,commbatchid)
--values (2425931,165,0,57.28,17108)

--2/24/2010
-- TSLF OA got double what they should have 
--update tblcommpay
--set amount = amount * 2
--where commbatchid = 17567
--and commstructid = 171
--
--update tblcommchargeback
--set amount = amount * 2
--where commbatchid = 17567
--and commstructid = 171

-- Lexxiom also got an extra 140.72 because of an invalid record in cbt(82101). Going to assign this amount to one of the 
-- registerpayments in this commbatch
--insert tblcommpay (registerpaymentid,commstructid,[percent],amount,commbatchid)
--values (2447022,170,0,140.72,17567) 