IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_insertOverride')
	BEGIN
		DROP  Procedure  stp_settlements_insertOverride
	END

GO

CREATE Procedure stp_settlements_insertOverride
(
@SettlementID numeric,
@OverrideAccountID numeric,
@FieldName varchar(500),
@RealValue varchar(500),
@EnteredValue varchar(500),
@CreatedBy int
)
as
BEGIN

	INSERT INTO [tblSettlements_Overrides]([SettlementID],[OverrideAccountID],[FieldName],[RealValue],[EnteredValue],[CreatedBy],[Created])
	VALUES (@SettlementID,@OverrideAccountID,@FieldName,@RealValue,@EnteredValue,@CreatedBy,getdate())
END


GO


GRANT EXEC ON stp_settlements_insertOverride TO PUBLIC

GO


