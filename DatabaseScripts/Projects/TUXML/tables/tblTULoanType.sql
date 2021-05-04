 --drop table tblTULoanType
 
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTULoanType')
 BEGIN	
	Create Table tblTULoanType(
		TypeCode varchar(10) not null Primary Key Clustered,
		Description varchar(100) not null,
		LoanType varchar(100) null
	)
 END

