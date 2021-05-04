IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetClientRtrFees')
	BEGIN
		DROP  Procedure  stp_GetClientRtrFees
	END

GO

CREATE Procedure stp_GetClientRtrFees
@ClientID int 
AS
BEGIN
		SET NOCOUNT ON;
DECLARE @RtrFees Table
(
AccountID INT,
FeeAmount MONEY
)

INSERT INTO @RtrFees

SELECT AccountID, 
sum(Amount) [RetainerFee] 
FROM tblRegister 
WHERE EntryTypeID IN (2, 42) 
AND ClientID =@ClientID
AND Void IS NULL 
AND Bounce IS NULL
GROUP BY AccountID

--INSERT INTO @RtrFees

--SELECT r.AccountID,
--SUM(r1.Amount) [RetainerFee]
--FROM tblRegister r
--JOIN tblRegister r1 ON r1.AdjustedRegisterID = r.RegisterID
--WHERE r1.EntryTypeID = -2
--AND r.ClientID = @ClientID
--AND r1.Void IS NULL
--AND r1.Bounce IS NULL 
--GROUP BY r.AccountID

SELECT AccountID, SUM(FeeAmount)
FROM @RtrFees
GROUP BY AccountID
END
GO

GRANT EXEC ON stp_GetClientRtrFees TO PUBLIC

GO

