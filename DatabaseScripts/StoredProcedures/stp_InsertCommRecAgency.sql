IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCommRecAgency')
	BEGIN
		DROP  Procedure  stp_InsertCommRecAgency
	END

GO

CREATE procedure [dbo].[stp_InsertCommRecAgency]
(
	  @CommRecTypeID int
	, @IsCommercial bit
    , @IsLocked bit
    , @Method varchar(50)
    , @BankName varchar(50)
    , @RoutingNumber varchar(50)
    , @AccountNumber varchar(50)
    , @Type char(1)
	, @AgencyID int
	, @Abbreviation varchar(10)
	, @Display varchar(50)
    , @UserID int

)
as
begin


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
	   ,0
       ,@Method
       ,@BankName
       ,@RoutingNumber --,EncryptByPassphrase(@Passphrase, @RoutingNumber)
       ,@AccountNumber --,EncryptByPassphrase(@Passphrase, @AccountNumber)
       ,@Type
       ,getdate()
       ,@UserID
       ,getdate()
       ,@UserID
       ,NULL
	   ,NULL
	   ,@AgencyID)


select scope_identity()


end
GO

--GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO

