IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserClientAccess')
	BEGIN
		CREATE TABLE tblUserClientAccess
		(
			UserId int not null,  
			ClientCreatedFrom datetime default('1/1/1900') not null,
			ClientCreatedTo datetime default('12/31/2050') not null,
			constraint pk_UserClientAccess primary key clustered (UserId)
		)
		
		insert tbluserclientaccess (userid,clientcreatedfrom,clientcreatedto) values (22,'1/1/2000','12/31/2007')
		insert tbluserclientaccess (userid,clientcreatedfrom,clientcreatedto) values (897,'1/1/2008','12/31/2050')
		insert tbluserclientaccess (userid,clientcreatedfrom,clientcreatedto) select distinct userid, '1/1/2000', '12/31/2050' from tblusercompanyaccess where userid not in (22,897) -- debtchoice, debtchoiceall
 
	END
GO 