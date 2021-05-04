IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCheck21TransactionByDepositId')
	BEGIN
		DROP  Procedure  stp_GetCheck21TransactionByDepositId
	END

GO

CREATE Procedure stp_GetCheck21TransactionByDepositId
@DepositId int
AS
BEGIN
	Select 
TransactionId as [Transaction Id],
Created as [Created],
ReceivedDate as [Received Date],
ProcessedDate as [Processed Date],
AccountNumber as [Account Number],
CheckNumber as [Check Number],
Amount as [Amount],
CASE [Status] 
	When 0 Then 'Good'
	When 1 Then 'Warning'
	When 2 Then 'Error'
	When 3 Then 'Returned'
	Else 'Unknown'
END as [Status],
CASE [State]
	When 0 Then 'Received'
	When 1 Then 'Processed'
	Else 'Unknown'
END as [State],
CASE CheckType
	When 1 Then 'Order'
	When 2 Then 'Bearer'
	Else 'Unknown'
END as [Check Type],
FrontImagePath as [Front Image],
BackImagePath as [Back Image]
From tblC21BatchTransaction
Where DepositId = @DepositId
		 
END


GO
