IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_InsertCheck')
	BEGIN
		DROP  Procedure  stp_CheckScan_InsertCheck
	END

GO

CREATE Procedure stp_CheckScan_InsertCheck
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
	@userID int
)
as
BEGIN
	INSERT INTO [tblNacha_Check21]
	([RegisterID],[clientID],[CheckFrontPath],[CheckBackPath],[Created],[CreatedBy],[Processed],[ProcessedBy],[Verified]
	,[VerifiedBy],[CheckRouting],[CheckAccountNum],[CheckAmount],[CheckAuxOnus],[CheckNumber],[CheckType],[CheckOnUs]	,[CheckRoutingCheckSum],[CheckMicrLine])
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
		,getdate()
		,@userid
		,@CheckRouting
		,@CheckAccountNum
		,@CheckAmount
		,@CheckAuxOnus
		,@CheckNumber
		,@CheckType
		,@CheckOnUs
		,@CheckRoutingCheckSum
		,@CheckMicrLine
	)

	Select  scope_identity()
END

GRANT EXEC ON stp_CheckScan_InsertCheck TO PUBLIC


