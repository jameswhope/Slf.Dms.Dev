IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblConvertFeeStructLookup')
	BEGIN
		CREATE TABLE tblConvertFeeStructLookup(
			ConversionId int identity(1,1) not null Primary Key,
			ClientId int not null,
			Converted datetime not null,
			ConvertedBy int not null,
			FromStruct int not null,
			ToStruct int not null,
			oldmonthlyfee money null,
			newmonthlyfee money null, 
			oldsubsequentmonthlyfee money null,
			newsubsequentmonthlyfee money null,
			oldsubmaintfeestart datetime null,
			newsubmaintfeestart datetime null,
			oldadditionalaccfee money null,
			newadditionalaccfee money null,
			oldmaintfeecap money null,
			newmaintfeecap money null
		)
	END
GO

