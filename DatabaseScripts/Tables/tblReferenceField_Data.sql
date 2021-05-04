IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblReferenceField')
	EXEC('
	PRINT ''Delete the Agency field entry, which is deprecated, from the Agent (Reference) web form ''
	DELETE FROM tblReferenceField
	WHERE Field =''AgencyName'' and ReferenceID = (SELECT ReferenceId FROM tblReference WHERE [table] = ''tblAgent'')  
	')
