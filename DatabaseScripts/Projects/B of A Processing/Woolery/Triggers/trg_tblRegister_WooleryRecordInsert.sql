IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trg_tblRegister_WooleryRecordInsert')
	BEGIN
		DROP  Trigger trg_tblRegister_WooleryRecordInsert
	END
GO

CREATE Trigger trg_tblRegister_WooleryRecordInsert ON tblRegister 


GO

