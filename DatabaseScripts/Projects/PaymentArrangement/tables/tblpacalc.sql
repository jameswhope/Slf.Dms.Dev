drop table tblPAcalc

IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPAcalc')
	BEGIN
		Create Table tblPAcalc(
			pasessionid int not null identity(1,1) primary key clustered,
			created datetime not null default getdate(),
			createdby int not null,
			lastmodified datetime not null default getdate(),
			lastmodifiedby int not null,
			deleted datetime null,
			deletedby int null,
			clientid int not null,
			accountid int not null,
			settlementamount money not null,
			startdate datetime null,
			plantype int not null,
			lumpsumamount money null,
			installmentmethod int null,
			installmentamount money null,
			installmentcount int null,
			custom bit not null default 0
		)
	END
GO


