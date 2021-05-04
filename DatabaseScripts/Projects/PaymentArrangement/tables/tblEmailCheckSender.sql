IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCompany')
	IF col_length('tblCompany', 'PaymentEmailSender') is null
		begin
			Alter table tblCompany Add PaymentEmailSender varchar(300) null
			
		end	
		
go

IF col_length('tblCompany', 'PaymentEmailSender') is not null
Begin
	update tblcompany Set PaymentEmailSender = 'gborgardt@lawfirmld.com' where companyid <= 2
	update tblcompany Set PaymentEmailSender = 'cperez@lawfirmcs.com' where companyid > 2
End	