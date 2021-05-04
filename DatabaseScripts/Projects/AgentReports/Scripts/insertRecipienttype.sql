 if not exists(select [name] from tblusertype where [name] = 'Commission Recipient')
	 insert into tblusertype([name], created, lastmodified, createdby, lastmodifiedby) 
	 VALUES ('Commission Recipient',getdate(),getdate(),0,0)
 GO