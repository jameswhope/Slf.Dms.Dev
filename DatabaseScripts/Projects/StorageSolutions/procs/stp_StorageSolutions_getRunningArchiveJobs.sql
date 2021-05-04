IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_StorageSolutions_getRunningArchiveJobs')
	BEGIN
		DROP  Procedure  stp_StorageSolutions_getRunningArchiveJobs
	END

GO

CREATE Procedure stp_StorageSolutions_getRunningArchiveJobs
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
BEGIN
	SELECT sst.StorageSolutionType, u.FirstName + ' ' + u.LastName AS UserName, ss.SolutionStatusDate
	FROM tblStorageSolutionsLogs AS ss INNER JOIN
	tblUser AS u ON ss.CreatedBy = u.UserID INNER JOIN
	tblStorageSolutionType AS sst ON ss.SolutionTypeID = sst.StorageSolutionTypeID
	where SolutionStatusID in (2) and SolutionTypeID in (1,2)
END

GO


GRANT EXEC ON stp_StorageSolutions_getRunningArchiveJobs TO PUBLIC

GO


