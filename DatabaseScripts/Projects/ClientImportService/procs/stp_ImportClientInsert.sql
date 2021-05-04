IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportClientInsert')
	BEGIN
		DROP  Procedure  stp_ImportClientInsert
	END

GO

CREATE Procedure stp_ImportClientInsert
@EnrollmentId int,
@AgencyId int,
@CompanyId int,
@TrustId int,
@UserId int,
@ClientStatusId int,
@InitialDraftAmount money = null,
@InitialDraftDate DateTime = null,
@DepositStartDate DateTime = null,
@MonthlyFee money,
@MonthlyFeeDay int,
@AdditionalAccountFee money,
@ReturnedCheckFee money,
@OvernightDeliveryFee money,
@SettlementFeePercentage money,
@SetupFeePercentage money,
@InitialAgencyPercent money = null,
@AccountNumber varchar(50),
@DepositMethod varchar(50),
@DepositDay int = null,
@DepositAmount money = null,
@BankAccountNumber varchar(50) = null,
@BankRoutingNumber varchar(50) = null,
@BankType varchar(2) = null,
@BankName varchar(255) = null,
@BankCity varchar(50) = null,
@BankStateId int = null,
@AgentName nvarchar(150) = null,
@SubsequentMaintFee money = null,
@SubMaintFeeStart datetime = null,
@Multideposit bit = null,
@MaintenanceFeeCap money = null,
@RemittName nvarchar(250) = null
AS
BEGIN

	declare @scenarioid int
	
	select @scenarioid = commscenid
	from tblcommscen
	where
		agencyid = @agencyid and
		startdate <= GetDate() and
		(
			enddate is null or
			enddate >= cast(convert(char(10), GetDate(), 101) as datetime)
		)
		
	if (@scenarioid is null)
		RAISERROR('Cannot create client. No scenario defined.',16,1)

	insert into tblClient (EnrollmentId, AgencyID, CompanyID, TrustID,
	CurrentClientStatusID, InitialDraftAmount, InitialDraftDate, DepositStartDate,
	MonthlyFee, MonthlyFeeDay, AdditionalAccountFee, ReturnedCheckFee,
	OvernightDeliveryFee, SettlementFeePercentage, SetupFeePercentage, InitialAgencyPercent,
	AccountNumber, DepositMethod, DepositDay, DepositAmount,
	BankAccountNumber, BankRoutingNumber, BankType, BankName,
	BankCity, BankStateID, AgentName, AutoAssignMediator,
	Created, CreatedBy, LastModified, LastModifiedBy,
	PFOBalance, SDABalance, SubsequentMaintFee, SubMaintFeeStart, MultiDeposit, MaintenanceFeeCap, RemittName, ScenarioId)
	Values(@EnrollmentId, @AgencyId, @CompanyId, @TrustId,
	 @ClientStatusId, @InitialDraftAmount, @InitialDraftDate, @DepositStartDate,
	 @MonthlyFee, @MonthlyFeeDay, @AdditionalAccountFee, @ReturnedCheckFee,
	 @OvernightDeliveryFee, @SettlementFeePercentage, @SetupFeePercentage, @InitialAgencyPercent,
	 @AccountNumber, @DepositMethod, @DepositDay, @DepositAmount,
	 @BankAccountNumber, @BankRoutingNumber, @BankType, @BankName,
	 @BankCity, @BankStateId, @AgentName, 1, 
	 GetDate(), @UserId, GetDate(), @UserId,
	 0, 0, @SubsequentMaintFee, @SubMaintFeeStart, isnull(@Multideposit,0), @MaintenanceFeeCap, @RemittName, @scenarioid)
	 
	 SELECT SCOPE_IDENTITY()
END

GO

