IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_SaveCheck')
	BEGIN
		DROP  Procedure  stp_CheckScan_SaveCheck
	END

GO

CREATE Procedure stp_CheckScan_SaveCheck
(
	@regID int,
	@clientID int,
	@frontPath varchar(max),
	@backPath varchar(max),
	@CheckRouting varchar(20),
	@CheckAccountNum varchar(20),
	@CheckAmount money,
	@CheckAuxOnus varchar(20),
	@CheckNumber varchar(50),
	@CheckType varchar(50),
	@CheckOnUs varchar(50),
	@CheckRoutingCheckSum varchar(1),
	@CheckMicrLine varchar(200),
	@userID int,
	@EPC varchar(1),
	@SaveID varchar(50)
)
as
BEGIN
	declare @checkid int
	
	INSERT INTO [tblICLChecks]
	([RegisterID],[clientID],[CheckFrontPath],[CheckBackPath],[Created],[CreatedBy],[Processed],[ProcessedBy],[Verified]
	,[VerifiedBy],[CheckRouting],[CheckAccountNum],[CheckAmount],[CheckAuxOnus],[CheckNumber],[CheckType],[CheckOnUs]	
	,[CheckRoutingCheckSum],[CheckMicrLine], [SaveGUID], [EPC])
	VALUES
	(
		@regID	,@clientID,@frontPath,@backPath,getdate(),@userID
		,NULL,NULL,NULL,NULL,@CheckRouting,@CheckAccountNum,@CheckAmount
		,@CheckAuxOnus,@CheckNumber,@CheckType,@CheckOnUs,@CheckRoutingCheckSum,@CheckMicrLine,@SaveID, @EPC 
	)

	Select @checkid = scope_identity()
	
	if (@CheckAmount > 0)
		BEGIN
			update [tblICLChecks] set verified=getdate(),verifiedby=@userID where check21id = @checkid
		END
	
	Select @checkid 
END

GRANT EXEC ON stp_CheckScan_SaveCheck TO PUBLIC


