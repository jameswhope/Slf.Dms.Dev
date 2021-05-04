IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertDailyAgencyWithholding')
	BEGIN
		DROP  Procedure  stp_InsertDailyAgencyWithholding
	END

GO

CREATE Procedure [dbo].[stp_InsertDailyAgencyWithholding]
(
 @NR INT,
 @NachaRegisterID INT,
 @CompanyID INT,
 @AmountWithheld MONEY,
 @Balance MONEY,
 @WithheldBy INT,
 @WithheldFrom NVARCHAR(150)
)
AS

--Testing******************************************
--DECLARE @NR as int
--DECLARE @NachaRegisterID int
--DECLARE @CompanyID int
--DECLARE @AmountWithheld money
--DECLARE @Balance money
--DECLARE @WithheldBy int
--DECLARE @WithheldFrom nvarchar(150)

--SET @NR = 1
--SET @NachaRegisterID = 1955960
--SET @CompanyID = 6
--SET @AmountWithheld = 34.27
--SET @Balance = 308.39
--SET @WithheldBy = 493
--SET @WithheldFrom = 'Avert Financial LLC'
--***************************************************

--***************************************************
DECLARE @NachaFileID int
DECLARE @Name varchar(100)
DECLARE @NewName varchar(150)
DECLARE @AccountNumber varchar(50)
DECLARE @RoutingNumber varchar(9)
DECLARE @Type char(1)
DECLARE @Amount money
DECLARE @IsPersonal bit
DECLARE @CommRecID int
DECLARE @TrustID int
DECLARE @Created datetime
DECLARE @RegisterID int
DECLARE @Flow varchar(6)
DECLARE @ReferenceNachaRegisterID int
DECLARE @PayoutWithheld bit
DECLARE @DateWithheld datetime
DECLARE @OriginalAmount money
DECLARE @OriginalNachaRegisterID int
--****************************************************
		--Get the Account and Routing numbers for the company to assign the $$ to
		SELECT
		  @AccountNumber = AccountNumber
		, @RoutingNumber = RoutingNumber
		, @NewName = cr.Display
		FROM tblCommRec cr
		WHERE cr.CompanyID = @CompanyID
		AND cr.IsGCA = 'true'
		
		SET @OriginalNachaRegisterID = @NACHARegisterID

IF @NR = 2
	BEGIN
		--Get the basic data from the NachaRegister
			SELECT
			@Name = nr.Name
			, @Amount = nr.Amount
			, @Type = nr.Type
			, @CommRecID = nr.CommRecID
			, @TrustID = nr.TrustID
			, @RegisterID = nr.RegisterID
			, @Created = nr.Created
			, @Flow = nr.Flow
			, @ReferenceNachaRegisterID = ReferenceNachaRegisterID
			FROM tblNachaRegister2 nr
			WHERE nr.NachaRegisterId = @NachaRegisterID
			
			SET @OriginalAmount = @Amount

		--Create a new record for this transaction moving $$ to atty GCA
		/*
		INSERT INTO tblNachaRegister2
		(
		[Name],
		AccountNumber,
		RoutingNumber,
		[Type],
		Amount,
		IsPersonal,
		CommRecID,
		CompanyID,
		TrustID,
		RegisterID,
		Created,
		Flow,
		ReferenceNachaRegisterID,
		PayoutWithheld,
		AmountWithheld,
		DateWithheld,
		WithheldBy,
		OriginalAmount,
	    WithheldFrom,
	    OriginalNachaRegisterID
		)
		VALUES
		(
		@NewName,
		@AccountNumber,
		@RoutingNumber,
		'C',
		@AmountWithheld,
		0,
		@CommRecID,
		@CompanyID,
		@TrustID,
		@RegisterID,
		@Created,
		@Flow,
		@ReferenceNachaRegisterID,
		1,
		@AmountWithheld,
		getdate(),
		@WithheldBy,
		@OriginalAmount,
		@WithheldFrom,
		@OriginalNachaRegisterID
		)

		*/
		--Update the old record lowering the Amount
		UPDATE tblNachaRegister2
		SET OriginalAmount = @OriginalAmount
		, Amount = @OriginalAmount - @AmountWithheld
		, PayoutWithheld = 1
		, AmountWithheld = @AmountWithheld
		, DateWithheld = getdate()
		, WithheldBy = @WithheldBy
		WHERE NachaRegisterID = @NachaRegisterID
	END

IF @NR = 1
		BEGIN
		--Get the basic data from the NachaRegister
			SET @TrustID = 20
			SELECT
			@Name = nr.Name
			, @Amount = nr.Amount
			, @Type = nr.Type
			, @CommRecID = nr.CommRecID
			, @RegisterID = nr.RegisterID
			, @Created = nr.Created
			FROM tblNachaRegister nr
			WHERE nr.NachaRegisterId = @NachaRegisterID

			SET @OriginalAmount = @Amount

		/* -- Insert used to divert funds to attorney GCA accounts
		INSERT INTO tblNachaRegister
		(
		[Name],
		AccountNumber,
		RoutingNumber,
		[Type],
		Amount,
		IsPersonal,
		CommRecID,
		CompanyID,
		Created,
		IsDeclined,
		PayoutWithheld,
		AmountWithheld,
		DateWithheld,
		WithheldBy,
		OriginalAmount,
		WithheldFrom,
		OriginalNachaRegisterID
		)
		VALUES
		(
		@NewName,
		@AccountNumber,
		@RoutingNumber,
		'C',
		@AmountWithheld,
		0,
		@CommRecID,
		@CompanyID,
		@Created,
		'False',
		1,
		@AmountWithheld,
		getdate(),
		@WithheldBy,
		@OriginalAmount,
		@WithheldFrom,
		@OriginalNachaRegisterID
		)
		*/
		
		-- Lower the commission payout
		UPDATE tblNachaRegister
		SET OriginalAmount = @OriginalAmount
		, Amount = @OriginalAmount - @AmountWithheld
		, PayoutWithheld = 1
		, AmountWithheld = @AmountWithheld
		, DateWithheld = getdate()
		, WithheldBy = @WithheldBy
		, WithheldFrom = @WithheldFrom
		WHERE NachaRegisterID = @NachaRegisterID
	END


GO

GRANT EXEC ON stp_InsertDailyAgencyWithholding TO PUBLIC

GO



