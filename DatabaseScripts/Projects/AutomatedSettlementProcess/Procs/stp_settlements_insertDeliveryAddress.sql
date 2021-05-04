IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_insertDeliveryAddress')
	BEGIN
		DROP  Procedure  stp_settlements_insertDeliveryAddress
	END

GO

CREATE Procedure stp_settlements_insertDeliveryAddress
(
	@SettlementID numeric(18,0)
	,@AttentionTo varchar(200)
	,@Address varchar(500)
	,@City varchar(100)
	,@State varchar(2)
	,@Zip varchar(20)
	,@UserID int
	,@email varchar(200) = null
	,@ContactNumber varchar(200) = null
	,@ContactName varchar(200) = null
	
)
as
BEGIN
	INSERT INTO tblSettlements_DeliveryAddresses([SettlementID],[AttentionTo],[Address],[City],[State],[Zip],created,createdby,emailaddress,ContactNumber,ContactName)
	VALUES (@SettlementID,@AttentionTo,@Address,@City,@State,@Zip,getdate(),@userid,@email,@ContactNumber,@ContactName)
END



GRANT EXEC ON stp_settlements_insertDeliveryAddress TO PUBLIC

GO


