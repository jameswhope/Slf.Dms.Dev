
alter table tblcompany add LandingPage varchar(50) default('') not null
go
update tblcompany set LandingPage = 'lexasys.com' where companyid = 4
update tblcompany set LandingPage = 'lexpros.com' where companyid = 6
go 