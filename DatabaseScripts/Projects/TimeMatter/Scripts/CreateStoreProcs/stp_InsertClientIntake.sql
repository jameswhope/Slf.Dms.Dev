/*
      Revision    : <01 - 29 December 2009>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Insert or update ClientIntakeform 

*/
CREATE PROCEDURE [dbo].[stp_InsertClientIntake]
@ClientIntakeId int =0,
@CreditorInstanceID int =0,
@AccountID int =0,
@IntakeFormDate datetime=null,
@LitigationDocument varchar(50)='',
@Amount money=0,
@ClientDocReceivedDate datetime=null,
@HowDocReceived varchar(50)='',
@IsPlaintiffCompany bit,
@IsAmountDispute bit,
@IsRealestateOwner bit,
@IsCurrentlyWorking bit,
@AnyAccount bit,
@HaveBankAccs bit,
@HaveOtherAssets bit,
@DeclinedLegalServices bit,
@SentLocalCounsel bit,
@Notes nvarchar(4000)='',
@IsresidenceofPropertyOne bit,
@DurationOwnerdPropertyOne int =0,
@AppMarketvalPropertyOne decimal(18,0)=0,
@PayoffPropertyOne varchar(50)='',
@LiensOnPropertyOne bit,
@TotalEquityPropertyOne varchar(50)='',
@HousePaymentsPropertyOne varchar(50)='',
@PeopleLivePropertyOne varchar(50)='',
@IsresidenceofPropertyTwo bit,
@DurationOwnerdPropertyTwo int =0,
@AppMarketvalPropertyTwo decimal(18,0)=0,
@PayoffPropertyTwo varchar(50)='',
@LiensOnPropertyTwo bit,
@TotalEquityPropertyTwo varchar(50)='',
@HousePaymentsPropertyTwo varchar(50)='',
@PeopleLivePropertyTwo varchar(50)='',
@EmployerName varchar(50)='',
@CurrentEmployerDuration int =0,
@Takehomepay money=0,
@Per varchar(50)='',
@Otherwage varchar(50)='',
@OtherIncomeSource varchar(50)='',
@BankAccOne varchar(50)='',
@BankAmtSourceAccOne varchar(50)='',
@AppBalanceAccOne varchar(50)='',
@BankAccTwo varchar(50)='',
@BankAmtSourceAccTwo varchar(50)='',
@AppBalanceAccTwo varchar(50)='',
@BankAccThree varchar(50)='',
@BankAmtSourceAccThree varchar(50)='',
@AppBalanceAccThree varchar(50)='',
@VerifiedBy int =0,
@FeePaidBy int =0,
@CreatedDatetime datetime=null,
@CreatedBy int =0,
@LastModifiedDatetime datetime=null,
@LastModifiedBy int =0,
@IsReceivingAid bit,
@IsVerified bit,
@TypeOfAid varchar(50)='',
@LegalServicesClientID int=0,
@VerifiedDate datetime=null,
@MatterID int=0,
@AccTypeOne int=0,
@AccTypeTwo int=0,
@IsSelfEmployed bit=null,
@Assets nvarchar(max)='',
@IsRentalPropertyOne bit=null,
@RentOnPropertyOne money=0,
@IsRentalPropertyTwo bit=null,
@RentOnPropertyTwo money=0
as
DECLARE @latestCreditorInstanceId int
SET @LatestCreditorInstanceId=(select TOP 1 CreditorInstanceId from tblCreditorInstance where AccountId =@AccountID order by Created desc)
 set @CreditorInstanceID=@LatestCreditorInstanceId
--select @CreditorInstanceID = CreditorInstanceID from tblmatter where matterid=@MatterId
declare @IntakeId  as int
set @IntakeId  =0
select @IntakeId = ClientIntakeId  from tblclientintakeform where AccountId = @AccountId 

if @IntakeId  = 0
begin 
	insert into tblclientintakeform 
	(AccountID, CreditorInstanceID, IntakeFormDate, LitigationDocument, ClientDocReceivedDate, 
	HowDocReceived, IsPlaintiffCompany, IsAmountDispute, IsRealestateOwner, IsCurrentlyWorking, AnyAccount, 
	HaveBankAccs, HaveOtherAssets, DeclinedLegalServices, SentLocalCounsel, Notes, IsresidenceofPropertyOne, 
	DurationOwnerdPropertyOne, AppMarketvalPropertyOne, PayoffPropertyOne, LiensOnPropertyOne, TotalEquityPropertyOne, 
	HousePaymentsPropertyOne, PeopleLivePropertyOne, IsresidenceofPropertyTwo, DurationOwnerdPropertyTwo, 
	AppMarketvalPropertyTwo, PayoffPropertyTwo, LiensOnPropertyTwo, TotalEquityPropertyTwo, HousePaymentsPropertyTwo, 
	PeopleLivePropertyTwo, EmployerName, CurrentEmployerDuration, Takehomepay, Per, Otherwage, 
	OtherIncomeSource, BankAccOne, BankAmtSourceAccOne, AppBalanceAccOne, BankAccTwo, BankAmtSourceAccTwo, 
	AppBalanceAccTwo, --BankAccThree, BankAmtSourceAccThree, AppBalanceAccThree,
	VerifiedBy, FeePaidBy,CreatedDatetime, CreatedBy, IsReceivingAid, TypeOfAid, LegalServicesClientID, VerifiedDate, IsVerified,
	AccTypeOne, AccTypeTwo, IsSelfEmployed, Amount, Assets, IsRentalPropertyOne,RentOnPropertyOne, IsRentalPropertyTwo,RentOnPropertyTwo )
	values(@AccountID,
	@CreditorInstanceID, @IntakeFormDate, @LitigationDocument, @ClientDocReceivedDate, 
	@HowDocReceived, @IsPlaintiffCompany, @IsAmountDispute, @IsRealestateOwner, @IsCurrentlyWorking,
	@AnyAccount, @HaveBankAccs, @HaveOtherAssets, @DeclinedLegalServices, @SentLocalCounsel, @Notes,
	@IsresidenceofPropertyOne, @DurationOwnerdPropertyOne, @AppMarketvalPropertyOne, @PayoffPropertyOne, 
	@LiensOnPropertyOne, @TotalEquityPropertyOne, @HousePaymentsPropertyOne, @PeopleLivePropertyOne, 
	@IsresidenceofPropertyTwo, @DurationOwnerdPropertyTwo, @AppMarketvalPropertyTwo, @PayoffPropertyTwo, 
	@LiensOnPropertyTwo, @TotalEquityPropertyTwo, @HousePaymentsPropertyTwo, @PeopleLivePropertyTwo, 
	@EmployerName, @CurrentEmployerDuration, @Takehomepay, @Per, @Otherwage, @OtherIncomeSource, 
	@BankAccOne, @BankAmtSourceAccOne, @AppBalanceAccOne, @BankAccTwo, @BankAmtSourceAccTwo,
	@AppBalanceAccTwo,-- @BankAccThree, @BankAmtSourceAccThree, @AppBalanceAccThree, 
	@VerifiedBy, @FeePaidBy, @CreatedDatetime, @CreatedBy, @IsReceivingAid, @TypeOfAid, @LegalServicesClientID, @VerifiedDate, @IsVerified,
	@AccTypeOne, @AccTypeTwo, @IsSelfEmployed, @Amount, @Assets, @IsRentalPropertyOne, @RentOnPropertyOne, @IsRentalPropertyTwo, @RentOnPropertyTwo )
end
else
begin
	update tblclientintakeform set CreditorInstanceID=@CreditorInstanceID,
    LitigationDocument= @LitigationDocument,  ClientDocReceivedDate= @ClientDocReceivedDate, 
	HowDocReceived= @HowDocReceived, IsPlaintiffCompany= @IsPlaintiffCompany, 
	IsAmountDispute= @IsAmountDispute, IsRealestateOwner= @IsRealestateOwner, 
	IsCurrentlyWorking= @IsCurrentlyWorking, AnyAccount= @AnyAccount, HaveBankAccs= @HaveBankAccs, 
	HaveOtherAssets= @HaveOtherAssets, DeclinedLegalServices= @DeclinedLegalServices, 
	SentLocalCounsel= @SentLocalCounsel, Notes= @Notes, IsresidenceofPropertyOne= @IsresidenceofPropertyOne, 
	DurationOwnerdPropertyOne= @DurationOwnerdPropertyOne, AppMarketvalPropertyOne= @AppMarketvalPropertyOne, 
	PayoffPropertyOne= @PayoffPropertyOne, LiensOnPropertyOne= @LiensOnPropertyOne, 
	TotalEquityPropertyOne= @TotalEquityPropertyOne, HousePaymentsPropertyOne= @HousePaymentsPropertyOne, 
	PeopleLivePropertyOne= @PeopleLivePropertyOne, IsresidenceofPropertyTwo= @IsresidenceofPropertyTwo, 
	DurationOwnerdPropertyTwo= @DurationOwnerdPropertyTwo, AppMarketvalPropertyTwo= @AppMarketvalPropertyTwo, 
	PayoffPropertyTwo= @PayoffPropertyTwo, LiensOnPropertyTwo= @LiensOnPropertyTwo, 
	TotalEquityPropertyTwo= @TotalEquityPropertyTwo, HousePaymentsPropertyTwo= @HousePaymentsPropertyTwo, 
	PeopleLivePropertyTwo= @PeopleLivePropertyTwo, EmployerName= @EmployerName, 
	CurrentEmployerDuration= @CurrentEmployerDuration, Takehomepay= @Takehomepay, Per= @Per, 
	Otherwage= @Otherwage, OtherIncomeSource= @OtherIncomeSource, BankAccOne= @BankAccOne, 
	BankAmtSourceAccOne= @BankAmtSourceAccOne, AppBalanceAccOne= @AppBalanceAccOne, BankAccTwo= @BankAccTwo, 
	BankAmtSourceAccTwo= @BankAmtSourceAccTwo, AppBalanceAccTwo= @AppBalanceAccTwo, 
	--BankAccThree= @BankAccThree, BankAmtSourceAccThree= @BankAmtSourceAccThree, AppBalanceAccThree= @AppBalanceAccThree,
	FeePaidBy= @FeePaidBy, 
	LastModifiedDatetime= @LastModifiedDatetime, LastModifiedBy= @LastModifiedBy,
	IsReceivingAid=@IsReceivingAid, TypeOfAid =@TypeOfAid, LegalServicesClientID=@LegalServicesClientID,
	IsVerified=@IsVerified, VerifiedBy=@VerifiedBy, VerifiedDate=@VerifiedDate ,
	AccTypeOne=@AccTypeOne, AccTypeTwo=@AccTypeTwo, IsSelfEmployed=@IsSelfEmployed, Amount=@Amount, Assets =@Assets,
IsRentalPropertyOne=@IsRentalPropertyOne, RentOnPropertyOne=@RentOnPropertyOne, IsRentalPropertyTwo=@IsRentalPropertyTwo, RentOnPropertyTwo =@RentOnPropertyTwo 
	where ClientIntakeId=@IntakeId-- @ClientIntakeId
 
	--if @IsVerified = 0
	--update tblclientintakeform set VerifiedBy=@VerifiedBy, VerifiedDate=@VerifiedDate
	--where ClientIntakeId= @ClientIntakeId
--CreditorInstanceID= @CreditorInstanceID, IntakeFormDate= @IntakeFormDate, 
--Amount= @Amount,CreatedDatetime= @CreatedDatetime, CreatedBy= @CreatedBy, 
end

