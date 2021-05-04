IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateCommRecAgency')
	BEGIN
		DROP  Procedure  stp_UpdateCommRecAgency
	END

GO

CREATE procedure [dbo].[stp_UpdateCommRecAgency]
(
	  @CommRecID int
	, @Abbreviation varchar(10)	
	, @Display varchar(50) 
	, @CommRecTypeID int
	, @IsCommercial bit
    , @IsLocked bit
    , @Method varchar(50)
    , @BankName varchar(50)
    , @RoutingNumber varchar(50)
    , @AccountNumber varchar(50)
    , @Type char(1)
	, @AgencyID int
    , @UserID int
)
as
begin

-- Not currently updating: IsTrust, Company, AccountTypeId 

UPDATE [tblCommRec]
   SET 
	   [CommRecTypeID] = @CommRecTypeID
	  ,[Abbreviation] = @Abbreviation 
	  ,[Display] = @Display 
      ,[IsCommercial] = @IsCommercial
      ,[IsLocked] = @IsLocked
      ,[Method] = @Method
      ,[BankName] = @BankName
      ,[Type] = @Type
      ,[LastModified] = getdate()
      ,[LastModifiedBy] = @UserID
      ,[AgencyID] = @AgencyID
      ,[RoutingNumber] = @RoutingNumber -- EncryptByPassphrase(@Passphrase, @RoutingNumber)
      ,[AccountNumber] = @AccountNumber -- EncryptByPassphrase(@Passphrase, @AccountNumber)
 WHERE 
	CommRecID = @CommRecID


end
GO

--GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO


