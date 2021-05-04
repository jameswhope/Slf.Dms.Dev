if exists (select * from sysobjects where name = 'stp_UpdateCommRec')
	drop procedure stp_UpdateCommRec
go

create procedure stp_UpdateCommRec
(
	  @CommRecID int
	, @CommRecTypeID int
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

-- Not currently updating: IsTrust, Display, Abbreviation

UPDATE [tblCommRec]
   SET 
	   [CommRecTypeID] = @CommRecTypeID
      ,[IsCommercial] = @IsCommercial
      ,[IsLocked] = @IsLocked
      ,[Method] = @Method
      ,[BankName] = @BankName
      ,[Type] = @Type
      ,[LastModified] = getdate()
      ,[LastModifiedBy] = @UserID
      ,[CompanyID] = @CompanyID
	  ,[AccountTypeID] = @AccountTypeID
      ,[AgencyID] = @AgencyID
      ,[RoutingNumber] = @RoutingNumber -- EncryptByPassphrase(@Passphrase, @RoutingNumber)
      ,[AccountNumber] = @AccountNumber -- EncryptByPassphrase(@Passphrase, @AccountNumber)
 WHERE 
	CommRecID = @CommRecID


end