IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProcessingReportStateGroup')
	BEGIN
		 CREATE TABLE tblProcessingReportStateGroup
		(	
		   StateGroupId int not null
		   ,Description varchar(50)
		   ,Seq int 
		   ,CssClass varchar(50)
		)
		
		Insert Into tblProcessingReportStateGroup(StateGroupId, Description, Seq, CssClass) values (1, 'Completed Transactions', 2, 'completed')
		Insert Into tblProcessingReportStateGroup(StateGroupId, Description, Seq, CssClass) values (2, 'Pending Transactions', 3, 'pending')
		Insert Into tblProcessingReportStateGroup(StateGroupId, Description, Seq, CssClass) values (3, 'Exceptions', 1, 'exception')
		
	END
GO