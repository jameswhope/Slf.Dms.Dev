  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerClientLogSummary')
 BEGIN
	IF col_length('tblDialerClientLogSummary', 'CallDate') is null
		Alter table tblDialerClientLogSummary Add CallDate datetime
END
GO