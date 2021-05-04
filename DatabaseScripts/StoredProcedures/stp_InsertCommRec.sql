if exists (select * from sysobjects where name = 'stp_InsertCommRec')
	drop procedure stp_InsertCommRec
go

create procedure stp_InsertCommRec
(
	  @CommRecTypeID int
	, @IsCommercial bit
    , @IsLocked bit
    , @Method varchar(50)
    , @BankName varchar(50)
    , @RoutingNumber varchar(50)
    , @AccountNumber varchar(50)
    , @Type char(1)
    , @UserID int
    , @CompanyID int
	, @AccountTypeID int
	, @AgencyID int
)
as
begin

declare 
	@Abbreviation varchar(10)
,	@Display varchar(50)
,	@Name varchar(50)
,	@ShortName varchar(50)
,	@IsTrust bit


-- The abbreviation and display name used in tblCommRec will be auto-generated
-- based on company name and account type.

select @Abbreviation = Abbreviation, @Display = AccountType
from tblAccountType
where AccountTypeID = @AccountTypeID


if @Abbreviation = 'Trust'
	set @IsTrust = 1
else
	set @IsTrust = 0


select @Name = [Name], @ShortName = ShortCoName
from tblCompany
where CompanyID = @CompanyID

set @Abbreviation = @ShortName + ' ' + @Abbreviation
set @Display = @Name + ' ' + @Display



INSERT INTO [tblCommRec]
	   ([CommRecTypeID]
	   ,[Abbreviation]
	   ,[Display]
	   ,[IsCommercial]
	   ,[IsLocked]
	   ,[IsTrust]
	   ,[Method]
	   ,[BankName]
	   ,[RoutingNumber]
	   ,[AccountNumber]
	   ,[Type]
	   ,[Created]
	   ,[CreatedBy]
	   ,[LastModified]
	   ,[LastModifiedBy]
	   ,[CompanyID]
	   ,[AccountTypeID]
	   ,[AgencyID])
 VALUES
       (@CommRecTypeID
       ,@Abbreviation
       ,@Display
       ,@IsCommercial
       ,@IsLocked
       ,@IsTrust
       ,@Method
       ,@BankName
       ,@RoutingNumber --,EncryptByPassphrase(@Passphrase, @RoutingNumber)
       ,@AccountNumber --,EncryptByPassphrase(@Passphrase, @AccountNumber)
       ,@Type
       ,getdate()
       ,@UserID
       ,getdate()
       ,@UserID
       ,@CompanyID
	   ,@AccountTypeID
	   ,@AgencyID)


select scope_identity()


end