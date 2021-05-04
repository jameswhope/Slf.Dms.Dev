IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProcessingReportDetail')
	BEGIN
		 CREATE TABLE tblProcessingReportDetail
		(	
			ReportDetailId int identity(1,1) not null
		   ,ReportId int not null
		   ,StateId int not null
		   ,TransactionId varchar(50) not null
		   ,TransactionType int not null
		   ,Notes varchar(max)
		)
	END
GO
