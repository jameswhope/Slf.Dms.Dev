/****** Object:  StoredProcedure [dbo].[stp_DoRegisterCleanup]    Script Date: 11/19/2007 15:27:01 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterCleanup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterCleanup]
	(
		@clientid int
	)


as


-- reset all isfullypaid values for this client
exec stp_DoRegisterResetAllForClient @clientid

-- run payment manager on client
exec stp_PayFeeForClient @clientid

-- reset all balances for client
exec stp_DoRegisterRebalanceClient @clientid

-- assign negogiator
--exec stp_AssignNegotiator @clientid
GO
