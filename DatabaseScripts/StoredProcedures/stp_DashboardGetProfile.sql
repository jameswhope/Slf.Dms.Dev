IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DashboardGetProfile')
	BEGIN
		DROP  Procedure  stp_DashboardGetProfile
	END

GO

CREATE Procedure stp_DashboardGetProfile
(
	@userid int,
	@scenario nvarchar(50)
)

as

set nocount on
set ansi_warnings off

SELECT
	DashboardItemID,
	ClientX,
	ClientY
FROM
	tblDashboardProfile
WHERE
	UserID = @userid
	and Scenario = @scenario


