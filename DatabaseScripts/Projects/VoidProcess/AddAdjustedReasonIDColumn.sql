IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblRegister')
	BEGIN
		alter table tblregister ADD AdjustedReasonID int NULL
	END 