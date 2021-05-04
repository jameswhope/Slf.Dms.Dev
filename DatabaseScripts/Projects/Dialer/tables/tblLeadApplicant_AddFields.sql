IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadApplicant')
BEGIN
	IF col_length('tblLeadApplicant', 'DialerRetryAfter') is null
		Alter table tblLeadApplicant Add DialerRetryAfter Datetime null  
		
	IF col_length('tblLeadApplicant', 'DialerLastRecycled') is null
		Alter table tblLeadApplicant Add DialerLastRecycled Datetime null  
END
GO