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
	@SaveID varchar(50)
)
as
BEGIN
	INSERT INTO [tblNacha_Check21]
	([RegisterID],[clientID],[CheckFrontPath],[CheckBackPath],[Created],[CreatedBy],[Processed],[ProcessedBy],[Verified]
	,[VerifiedBy],[CheckRouting],[CheckAccountNum],[CheckAmount],[CheckAuxOnus],[CheckNumber],[CheckType],[CheckOnUs]	,[CheckRoutingCheckSum],[CheckMicrLine], [SaveGUID])
	VALUES
	(
		@regID	
		,@clientID
		,@frontPath
		,@backPath
		,getdate()
		,@userID
		,NULL
		,NULL
		,NULL
		,NULL
		,@CheckRouting
		,@CheckAccountNum
		,@CheckAmount
		,@CheckAuxOnus
		,@CheckNumber
		,@CheckType
		,@CheckOnUs
		,@CheckRoutingCheckSum
		,@CheckMicrLine
		,@SaveID 
	)

	Select  scope_identity()
END

GRANT EXEC ON stp_CheckScan_SaveCheck TO PUBLIC


