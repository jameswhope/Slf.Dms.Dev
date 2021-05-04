IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertCallResolution')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertCallResolution
	END

GO

CREATE Procedure stp_Dialer_InsertCallResolution
@CallMadeId int,
@ReasonId int,
@TableName varchar(50) = null,
@FieldName varchar(50) = null,
@FieldValue varchar(50),
@Expiration datetime,
@UserId int
AS
Begin

Insert into tbldialercallresolution(CallMadeId, ReasonId, TableName, FieldName, FieldValue, Created, CreatedBy, Expiration, LastModified, LastModifiedBy)
Values (@CallMadeId, @ReasonId, @TableName, @FieldName, @FieldValue, GetDate(), @UserId, @Expiration, GetDate(), @UserId )

Select scope_identity()
End

GO



