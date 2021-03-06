IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DoRegisterCleanup')
	BEGIN
		DROP  Procedure  stp_DoRegisterCleanup
	END

GO

CREATE Procedure stp_DoRegisterCleanup
	(
		@clientid int,
		@UserID int = 28
	)


as


-- reset all isfullypaid values for this client
exec stp_DoRegisterResetAllForClient @clientid

-- run payment manager on client
exec stp_PayFeeForClient @clientid, @UserID

-- reset all balances for client
exec stp_DoRegisterRebalanceClient @clientid

-- assign negogiator
--exec stp_AssignNegotiator @clientid
GO



