IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertDailyAgencyWithholding')
	BEGIN
		DROP  Procedure  stp_InsertDailyAgencyWithholding
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure stp_InsertDailyAgencyWithholding
(
 @NR INT,
 @NachaRegisterID INT,
 @CompanyID INT,
 @AmountWithheld NUMERIC(18, 2),
 @Balance NUMERIC(18, 2),
 @WithheldBy INT,
 @WithheldFrom NVARCHAR(150),
 @Payee NVARCHAR(MAX) 
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
DECLARE @Amount NUMERIC(18, 2)
DECLARE @IsPersonal bit
DECLARE @CommRecID int
DECLARE @TrustID int
DECLARE @Created datetime
DECLARE @RegisterID int
DECLARE @Flow varchar(6)
DECLARE @ReferenceNachaRegisterID int
DECLARE @PayoutWithheld bit
DECLARE @DateWithheld datetime
DECLARE @OriginalAmount NUMERIC(18, 2)
DECLARE @OriginalNachaRegisterID int
DECLARE @IsAttorney bit
DECLARE @LexxiomPmtSysHoldingName varchar(50)
DECLARE @LexxiomPmtSysHoldingAccountNo varchar(50)
DECLARE @LexxiomPmtSysHoldingRoutingNo varchar(50)
--****************************************************
		--Assign Holding account information
		SELECT @LexxiomPmtSysHoldingAccountNo = AccountNumber, @LexxiomPmtSysHoldingRoutingNo = RoutingNumber, @LexxiomPmtSysHoldingName = Display FROM tblCommRec WHERE Abbreviation = 'Lexxiom WH'

		--Get the Account and Routing numbers for the company to assign the $$ to
		SELECT
		  @AccountNumber = AccountNumber
		, @RoutingNumber = RoutingNumber
		, @NewName = cr.Display
		FROM tblCommRec cr
		WHERE cr.CompanyID = @CompanyID
		AND cr.IsGCA = 'true'
		
		SET @OriginalNachaRegisterID = @NACHARegisterID
		
--NR 2	
IF @WithheldFrom NOT LIKE '%Lexxiom%' AND @WithheldFrom NOT LIKE '%Seideman%'
	BEGIN
		IF @NR = 2
			BEGIN
				--Is this an attorney
				select @IsAttorney = case when name like '%operating%' then 'True' else 'False' end
				from tblnacharegister2
				where nacharegisterid = @nacharegisterid 
				and name not like '%seideman%' 
				--Get the basic data from the NachaRegister
				SELECT
				@Name = nr.Name
				, @Amount = nr.Amount
				, @Type = nr.Type
				, @CommRecID = nr.CommRecID
				, @TrustID = nr.TrustID
				, @RegisterID = nr.RegisterID
				, @CompanyID = nr.CompanyID
				, @Created = nr.Created
				, @Flow = nr.Flow
				, @ReferenceNachaRegisterID = ReferenceNachaRegisterID
				FROM tblNachaRegister2 nr
				WHERE nr.NachaRegisterId = @NachaRegisterID
				
				SET @OriginalAmount = @Amount

				--Create a new record for this transaction moving $$ to atty GCA
				INSERT INTO tblNachaRegister2
				(
				NachaFileID,
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
				OriginalNachaRegisterID,
				IsAttorney
				)
				VALUES
				(
				-1,
				@LexxiomPmtSysHoldingName,
				@LexxiomPmtSysHoldingAccountNo,
				@LexxiomPmtSysHoldingRoutingNo,
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
				@OriginalNachaRegisterID,
				@IsAttorney
				)

				--Update the old record lowering the Amount
				UPDATE tblNachaRegister2
				SET OriginalAmount = @OriginalAmount
				, Amount = @OriginalAmount - @AmountWithheld
				, PayoutWithheld = 1
				, AmountWithheld = @AmountWithheld
				, DateWithheld = getdate()
				, WithheldBy = @WithheldBy
				, WithheldFrom = @WithheldFrom
				, IsAttorney = @IsAttorney
				WHERE NachaRegisterID = @NachaRegisterID
				END
		END
--NR 1
IF @WithheldFrom NOT LIKE '%Lexxiom%' AND @WithheldFrom NOT LIKE '%Seideman%'
	BEGIN
		IF @NR = 1
			BEGIN
				--Is this an attorney
				select @IsAttorney = case when name like '%operating%' then 'True' else 'False' end
				from tblnacharegister
				where nacharegisterid = @nacharegisterid 
				and name not like '%seideman%' 
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

				-- Insert used to divert funds to Lexxiom Escrow account
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
				OriginalNachaRegisterID,
				IsAttorney
				)
				VALUES
				(
				@LexxiomPmtSysHoldingName,
				@LexxiomPmtSysHoldingAccountNo,
				@LexxiomPmtSysHoldingRoutingNo,
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
				@OriginalNachaRegisterID,
				@IsAttorney
				)
				
				-- Lower the commission payout
				UPDATE tblNachaRegister
				SET OriginalAmount = @OriginalAmount
				, Amount = @OriginalAmount - @AmountWithheld
				, PayoutWithheld = 1
				, AmountWithheld = @AmountWithheld
				, DateWithheld = getdate()
				, WithheldBy = @WithheldBy
				, WithheldFrom = @WithheldFrom
				, IsAttorney = @IsAttorney
				WHERE NachaRegisterID = @NachaRegisterID	
		END
END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

