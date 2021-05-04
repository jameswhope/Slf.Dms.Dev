
 IF NOT EXISTS (SELECT * FROM tblusergroup WHERE Usergroupid = 23)
	BEGIN
		SET IDENTITY_INSERT tblusergroup ON
		
		Insert into tblusergroup (UsergroupID,Name,created,createdby,lastmodified, lastmodifiedby)
		values (23,'Bulk Negotation Team',getdate(),493,getdate(),493)
		
		SET IDENTITY_INSERT tblusergroup OFF
		
		insert tblUserTypeXref values (1,23)
		
		UPDATE tblUserGroup SET DefaultPage = '~/negotiation/bulk' WHERE UserGroupID = 23
	END 