IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationCall')
 BEGIN
	IF col_length('tblVerificationCall', 'ViciFileName') is null
		Alter table tblVerificationCall Add ViciFileName  varchar(255) null 
END
go
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProperty')
BEGIN
	IF col_length('tblProperty', 'IsInitialFee') is null
		Alter table tblProperty Add IsInitialFee bit not null default 0
END
go
update tblproperty set IsInitialFee = 1
where name like 'initial%fee'


 

