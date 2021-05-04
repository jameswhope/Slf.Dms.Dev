IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_icl_insertFileHeaderRecord')
	BEGIN
		DROP  Procedure  stp_icl_insertFileHeaderRecord
	END

GO

CREATE Procedure stp_icl_insertFileHeaderRecord

	(
		@Date datetime
		,@EffectiveDate datetime
		,@DateSent datetime
		,@FileName varchar(max)
		,@StandardLevel varchar(2)
		,@FileIndicator varchar(2)
		,@ImmediateDestinationRoutingNumber varchar(9)
		,@ImmediateOriginRoutingNumber varchar(9)
		,@FileCreationDate varchar(8)
		,@FileCreationTime varchar(4)
		,@ResendIndicator varchar(1)
		,@ImmediateDestinationName varchar(18)
		,@ImmediateOriginName varchar(18)
		,@FileIDModifier varchar(1)
		,@CountryCode varchar(2)
		,@UserField varchar(4)
		,@Reserved varchar(1)
	)


AS
BEGIN
	INSERT INTO [tblICLFileHeader]
	([Date],[EffectiveDate],[DateSent],[FileName],[StandardLevel],[FileIndicator],[ImmediateDestinationRoutingNumber],[ImmediateOriginRoutingNumber],[FileCreationDate]
	,[FileCreationTime],[ResendIndicator],[ImmediateDestinationName],[ImmediateOriginName],[FileIDModifier],[CountryCode],[UserField],[Reserved])
	VALUES
	(@Date,@EffectiveDate,@DateSent,@FileName,@StandardLevel,@FileIndicator,@ImmediateDestinationRoutingNumber,@ImmediateOriginRoutingNumber,@FileCreationDate
	,@FileCreationTime,@ResendIndicator,@ImmediateDestinationName,@ImmediateOriginName,@FileIDModifier,@CountryCode,@UserField,@Reserved)
END

GO


GRANT EXEC ON stp_icl_insertFileHeaderRecord TO PUBLIC

GO


