IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_DeleteCheck')
	BEGIN
		DROP  Procedure  stp_CheckScan_DeleteCheck
	END

GO

CREATE Procedure stp_CheckScan_DeleteCheck
(
	@check21ID int
)
as
BEGIN
	update tblICLChecks
	set DeleteDate = getdate()
	where check21ID = @check21ID
END


GRANT EXEC ON stp_CheckScan_DeleteCheck TO PUBLIC


