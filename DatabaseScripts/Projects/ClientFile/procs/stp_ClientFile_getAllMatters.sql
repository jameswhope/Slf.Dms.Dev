IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getAllMatters')
	BEGIN
		DROP  Procedure  stp_ClientFile_getAllMatters
	END

GO

CREATE Procedure stp_ClientFile_getAllMatters
	(
		@clientid int
	)

AS
BEGIN
	select * from tblmatter where clientid = @clientid
END

GO


GRANT EXEC ON stp_ClientFile_getAllMatters TO PUBLIC

GO


