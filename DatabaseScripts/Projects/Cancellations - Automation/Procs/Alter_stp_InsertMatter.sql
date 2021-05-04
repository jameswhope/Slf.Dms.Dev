IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertMatter')
	BEGIN
		DROP  Procedure  stp_InsertMatter
	END

GO

CREATE Procedure [dbo].[stp_InsertMatter]
(
   @MatterId int = NULL,
   @ClientId int,
   @MatterStatusCodeId int,
   @MatterNumber varchar(50),
   @MatterDate datetime,
   @MatterMemo varchar(200),
   @CreatedBy int,
   @AccountId int,
   @AttorneyId int,
   @CreditorInstanceId int	=0,
   @MatterTypeID int,
   @MatterStatusId int,
   @MatterSubStatusId int
)
AS

--** todo need to add transaction and validation *//
--** could be done in MatterData Helper class ***/

DECLARE @latestCreditorInstanceId int, @MatterSubStatus varchar(50);

	set @MatterSubStatus = (SELECT MatterSubStatus FROM tblMatterSubStatus WHERE MatterSubStatusId = @MatterSubStatusId);
--if @MatterTypeID=1
--Begin
	if @CreditorInstanceId=-1
		set @latestCreditorInstanceId=NULL
--	else if @CreditorInstanceId=0
--		set @latestCreditorInstanceId=0
	else	
--	if @CreditorInstanceId=0
--		SET @latestCreditorInstanceId=(select TOP 1 CreditorInstanceId from tblCreditorInstance where AccountId =@AccountId order by Created desc)
--	else
		set @latestCreditorInstanceId=@CreditorInstanceId
--End
--else
--Begin
--	if @AccountId=-1
--		set @LatestCreditorInstanceId=NULL
--	else if @AccountId=0
--		set @LatestCreditorInstanceId=0
--	else
--		set @LatestCreditorInstanceId=@CreditorInstanceId
--End

If @AttorneyId=-1
	set @AttorneyId=NULL


IF @MatterId is null 
BEGIN 
INSERT INTO dbo.tblMatter
(
ClientId,
MatterStatusCodeId,
MatterNumber,
MatterDate,
MatterMemo,
CreatedDateTime,
CreatedBy,
CreditorInstanceId,
AttorneyId,
MatterTypeID,
IsDeleted,
MatterStatusId,
MatterSubStatusId
)

VALUES 
(
@ClientId
,@MatterStatusCodeId
,@MatterNumber
,@MatterDate
,@MatterMemo
,getdate()
,@CreatedBy
,@latestCreditorInstanceId
,@AttorneyId
--,1
,@MatterTypeID
,0
,@MatterStatusId
,@MatterSubStatusId
)

DECLARE @MatId int
SET @MatId = (SELECT MAX(MatterId) FROM dbo.tblMatter)

SELECT NEWID = SCOPE_IDENTITY()

END


ELSE
BEGIN

-- Note need to put transaction here !
---Also CreditorInstanceId is also an identifying ID!
-- need to be able to update creditor instance too!

UPDATE dbo.tblMatter

SET MatterStatusCodeId	= @MatterStatusCodeId,
    MatterNumber		= @MatterNumber,
    MatterMemo			= @MatterMemo,
	AttorneyId		    = @AttorneyId,
	MatterTypeId		= @MattertypeId,
	CreditorInstanceId  = @latestCreditorInstanceId,
	MatterStatusId		= @MatterStatusId,
	MatterSubStatusId  = @MatterSubStatusId

where  MatterId =@MatterId 

IF @MatterTypeId = 3 BEGIN
	EXEC stp_ChangeSettlementMatterStatus @MatterID, @ClientId, @MatterStatusCodeId, @CreatedBy, @AccountId, @MatterStatusId, @MatterSubStatusId;
	
END

IF @MatterTypeId = 4 and @MatterSubStatus = 'RC' BEGIN
	EXEC stp_DeleteCancellationMatter @MatterID, @CreatedBy;
	
END


END
GO


