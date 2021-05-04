 IF EXISTS(SELECT Name FROM tblUserGroup WHERE Name = 'Retention Group')
         BEGIN
			DECLARE @User nvarchar(50)
			DECLARE @GroupID int
			
			SET @User = SYSTEM_USER 
			              
                  INSERT  INTO                                  
						tblUserGroup(
						[Name],
						Created, 
						CreatedBy, 
						LastModifiedBy,
						LastModified
						DefaultPage)                 
						VALUES(
						'Retention Group',
						@User,
						getdate(),
						@User,
						getdate(),
						'~/Clients/Client/Finances/ach/default.aspx')
						@GroupID = SELECT scope_Identity
						
				INSERT INTO
						tblUserTypeXref(
						UserTypeID,
						UserGroupID)
						VALUES(
						1,
						@GroupID)       
		END