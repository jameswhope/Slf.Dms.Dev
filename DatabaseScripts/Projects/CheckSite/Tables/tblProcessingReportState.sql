IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProcessingReportState')
	BEGIN
		 CREATE TABLE tblProcessingReportState
		(	
			StateId int not null
		   ,StateGroupId int not null
		   ,Description varchar(50)
		   ,Seq int not null
		)
		--Completed
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (1, 1, 'Processed OK',1)
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (7, 1, 'Ignored', 2)
		--Pending
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (2, 2, 'Received', 1)
		--Exceptions
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (3, 3, 'Bounced', 1)
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (4, 3, 'Require Manual Resolution', 2)
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (5, 3, 'Other', 3)
		Insert Into tblProcessingReportState(StateId, StateGroupId, Description, Seq) values (6, 3, 'Ignored', 4)
	END
GO