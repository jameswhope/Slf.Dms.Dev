/****** Object:  StoredProcedure [dbo].[stp_CollectACHCommission]    Script Date: 11/19/2007 15:26:57 ******/
DROP PROCEDURE [dbo].[stp_CollectACHCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectACHCommission]


as


---------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING COMMISSION BATCH TRANSFERS
-- (1) Get batch transfers that need to be ACH'd.  This would exclude:
--     (a) Any that had open (not declined) nacha records already
--     (b) Any that had check information on the transfer already
--     (c) Any where the associated recipient is locked
--     (d) Any where the associated recipient's delivery method is not ACH
-- (2) Loop through the open transfers to send
-- (3) On each commbatchtransfer that is sent, follow the following procedures
--     exactly and in order:
--     (a) If the parent recipient is null, use the trust recipient as the master
--     (b) Write a debit against the parent recipient for the transfer amount
--     (c) Write a credit to the recipient for the transfer amount
---------------------------------------------------------------------------------------


exec stp_CollectACHCommission_S
exec stp_CollectACHCommission_P
GO
