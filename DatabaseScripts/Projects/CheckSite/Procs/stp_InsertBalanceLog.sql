IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertBalanceLog')
	BEGIN
		DROP  Procedure  stp_InsertBalanceLog
	END

GO

CREATE Procedure stp_InsertBalanceLog
AS
Insert Into tblBalanceLog(ClientId, LastCheck, Balanced)
Select clientId, null, 0
from tblClient Where TrustId = 22 and clientid not in
(Select clientid from tblBalanceLog)    

GO
