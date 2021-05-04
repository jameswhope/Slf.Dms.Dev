IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_insertPaymentProcessing')
	BEGIN
		DROP  Procedure  stp_settlements_insertPaymentProcessing
	END

GO

CREATE Procedure stp_settlements_insertPaymentProcessing
(
@settlementID int,
@userID int
)
as
	BEGIN
		if not exists(select matterid from tblAccount_PaymentProcessing where matterid = (SELECT matterid from tblSettlements where settlementid = @settlementID))
			BEGIN
				INSERT INTO tblAccount_PaymentProcessing(MatterId, DueDate, AvailableSDA, RequestType, CheckAmount, DeliveryMethod, Created, CreatedBy, LastModified, LastModifiedBy, Processed) 
				select matterid,settlementduedate,AvailSDA,'Settlement',settlementamount
				, [DeliveryMethod]=CASE DeliveryMethod  
						WHEN 'chkbyemail' then 'E'
						WHEN 'chkbytel' then 'P'
						ELSE 'C'		
					END
				, getdate(), @userID, getdate(), @userID, 0 
				from tblsettlements where settlementid = @settlementID
			END
	END
GO


GRANT EXEC ON stp_settlements_insertPaymentProcessing TO PUBLIC

GO


