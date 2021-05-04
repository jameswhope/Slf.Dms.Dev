IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClassifications')
BEGIN
	IF col_length('tblClassifications', 'Display') is null
			alter table tblClassifications add Display bit DEFAULT  1 not null

END

