IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateClientContactInfo')
	BEGIN
		DROP  Procedure  stp_UpdateClientContactInfo
	END

GO

CREATE Procedure [dbo].[stp_UpdateClientContactInfo]
(
	@ClientId int,
	@UserId int,
	@FirstName varchar(50),
	@LastName varchar(50),
	@Street varchar(255),
	@Street2 varchar(255),
	@City varchar(50),
	@StateId int,
	@ZipCode varchar(50),
	@HomeAreaCode varchar(50),
	@HomeNumber varchar(50),
	@FaxAreaCode varchar(50),
	@FaxNumber varchar(50),
	@EmailAddress varchar(50)
)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	DECLARE @Return INT
			,@InTran BIT						
			,@Note VARCHAR(MAX)
			,@UserName VARCHAR(50)
			,@PersonId INT
			,@VerifyFirstName VARCHAR(50)
			,@VerifyLastName VARCHAR(50)
			,@VerifyStreet VARCHAR(255)
			,@VerifyStreet2 VARCHAR(255)
			,@VerifyCity VARCHAR(50)
			,@VerifyState INT
			,@VerifyZip VARCHAR(50)
			,@VerifyEmail VARCHAR(50)
			,@MatterId INT
			,@TaskId INT
			,@PhoneId INT
			,@Abbreviation VARCHAR(10)
			,@Address varchar(255)
			,@HomePhone VARCHAR(20)
			,@FaxPhone VARCHAR(20);
			
	SELECT @Return = 0
		   ,@InTran = (CASE WHEN (SELECT @@trancount) = 0 THEN 0 ELSE 1 END)
		   ,@UserName = (SELECT FirstName+ ' ' + LastName FROM tblUser WHERE UserId = @UserId)
		   ,@PersonId = (SELECT PersonId FROM tblPerson WHERE ClientId = @ClientId and Relationship = 'Prime')
		   ,@MatterId = (SELECT MatterId FROM tblMatter WHERE ClientId = @ClientId and IsDeleted = 0 and MatterTypeId = 4)
		   ,@TaskId = (SELECT TaskId FROM tblMatterTask WHERE MatterId = @MatterId)
		   ,@Abbreviation = (SELECT Abbreviation FROM tblState WHERE StateId = @StateId)
		   ,@Address = (CASE WHEN @Street is null THEN NULL ELSE (@Street+isnull(@Street2, '')) END)
		   ,@HomePhone = (CASE WHEN @HomeAreaCode is null THEN NULL ELSE ('('+@HomeAreaCode+')' + isnull(@HomeNumber, '')) END)
		   ,@FaxPhone = (CASE WHEN @FaxAreaCode is null THEN NULL ELSE ('('+@FaxAreaCode+')' + isnull(@FaxNumber, '')) END);

	IF @PersonId is null SET @Return = -2;

	IF @Return = 0 BEGIN
		IF @InTran = 0 BEGIN TRANSACTION;
		BEGIN TRY

			SELECT @VerifyFirstName = FirstName, @VerifyLastName = LastName, @VerifyStreet = Street, 
					@VerifyStreet2 = Street2, @VerifyCity = City, @VerifyEmail = EmailAddress,
					@VerifyState = StateId, @VerifyZip = ZipCode FROM tblPerson WHERE PersonId = @PersonId

			UPDATE tblPerson SET
				FirstName = @FirstName,
				LastName = @LastName,
				Street = @Street,
				Street2 = @Street2,
				City = @City,
				StateId = @StateId,
				ZipCode = @ZipCode,
				EmailAddress = @EmailAddress,
				LastModified = getdate(),
				LastModifiedBy = @UserId
			WHERE PersonId = @PersonId;

			IF exists (SELECT 1 FROM tblPhone WHERE PhoneTypeId = 27 and 
						PhoneId in (SELECT PhoneId FROM tblPersonPhone WHERE PersonId = @PersonId)) BEGIN
				UPDATE tblPhone SET
					AreaCode = @HomeAreaCode,
					Number = @HomeNumber,
					LastModified = getdate(),
					LastModifiedBy = @UserId
				WHERE PhoneTypeId = 27 and PhoneId in 
				(SELECT PhoneId FROM tblPersonPhone WHERE PersonId = @PersonId)
			END
			ELSE BEGIN
				INSERT INTO tblPhone(PhoneTypeId, AreaCode, Number, Created, CreatedBy, LastModified, LastModifiedBy)
				VALUES(27, @HomeAreaCode, @HomeNumber, getdate(), @UserId, getdate(), @UserId)

				SET @PhoneId = SCOPE_IDENTITY()

				INSERT INTO tblPersonPhone(PhoneId, PersonId, Created, CreatedBy, LastModified, LastModifiedBy)
				VALUES(@PhoneId, @PersonId, getdate(), @UserId, getdate(), @UserId)
			END

			IF exists (SELECT 1 FROM tblPhone WHERE PhoneTypeId = 29 and 
						PhoneId in (SELECT PhoneId FROM tblPersonPhone WHERE PersonId = @PersonId)) BEGIN
				UPDATE tblPhone SET
					AreaCode = @FaxAreaCode,
					Number = @FaxNumber,
					LastModified = getdate(),
					LastModifiedBy = @UserId
				WHERE PhoneTypeId = 29 and PhoneId in 
				(SELECT PhoneId FROM tblPersonPhone WHERE PersonId = @PersonId)
			END
			ELSE BEGIN
				INSERT INTO tblPhone(PhoneTypeId, AreaCode, Number, Created, CreatedBy, LastModified, LastModifiedBy)
				VALUES(29, @FaxAreaCode, @FaxNumber, getdate(), @UserId, getdate(), @UserId)

				SET @PhoneId = SCOPE_IDENTITY()

				INSERT INTO tblPersonPhone(PhoneId, PersonId, Created, CreatedBy, LastModified, LastModifiedBy)
				VALUES(@PhoneId, @PersonId, getdate(), @UserId, getdate(), @UserId)
			END

			IF not exists (SELECT 1 FROM tblAccount_DeliveryInfo WHERE MatterId = @MatterId) BEGIN
				INSERT INTO tblAccount_DeliveryInfo(MatterId, DeliveryAddress, DeliveryCity, DeliveryState,
									DeliveryZip, DeliveryPhone, DeliveryFax, DeliveryEmail)
				VALUES(@MatterId, @Address, @City, @Abbreviation, @ZipCode, @HomePhone,
						 @FaxPhone, @EmailAddress);
			END
			ELSE BEGIN
				UPDATE tblAccount_DeliveryInfo SET
					DeliveryAddress = @Address,
					DeliveryCity = @City,
					DeliveryState = @Abbreviation,
					DeliveryZip = @ZipCode,
					DeliveryPhone = @HomePhone,
					DeliveryFax = @FaxPhone,
					DeliveryEmail = @EmailAddress
				WHERE Matterid = @MatterId;
			END

			SET @Note = (SELECT @UserName + ' updated the contact information of client ' + @VerifyFirstName + ' ' + @VerifyLastName);
			EXEC @Return = stp_InsertNoteForSettlementMatter @ClientId, @MatterId,
										 null,@UserId, @TaskId, @Note,null,null,null, null,null;
			
			IF @VerifyFirstName <> @FirstName BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(99, @PersonId, @FirstName, getdate(), @UserId, 0)
			END

			IF @VerifyLastName <> @LastName BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(100, @PersonId, @LastName, getdate(), @UserId, 0)
			END

			IF @VerifyEmail <> @EmailAddress BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(104, @PersonId, @EmailAddress, getdate(), @UserId, 0)
			END

			IF @VerifyStreet <> @Street BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(105, @PersonId, @Street, getdate(), @UserId, 0)
			END

			IF @VerifyStreet2 <> @Street2 BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(106, @PersonId, @Street2, getdate(), @UserId, 0)
			END

			IF @VerifyCity <> @City BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(107, @PersonId, @City, getdate(), @UserId, 0)
			END

			IF @VerifyState <> @StateId BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(108, @PersonId, @StateId, getdate(), @UserId, 0)
			END

			IF @VerifyZip <> @ZipCode BEGIN
				INSERT INTO tblAudit(AuditColumnId, PK, [Value], DC, UC, Deleted)
				VALUES(109, @PersonId, @ZipCode, getdate(), @UserId, 0)
			END

			IF @InTran = 0 BEGIN
				 IF @Return = 0 COMMIT ELSE ROLLBACK;
			END
		END TRY
		BEGIN CATCH
			SET @Return = -1;
			IF @InTran = 0 ROLLBACK;
		END CATCH
	END

	RETURN @Return;
END
GO



