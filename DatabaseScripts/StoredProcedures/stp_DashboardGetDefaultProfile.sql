IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DashboardGetDefaultProfile')
	BEGIN
		DROP  Procedure  stp_DashboardGetDefaultProfile
	END

GO

CREATE Procedure stp_DashboardGetDefaultProfile
(
	@scenario nvarchar(50)
)

as
BEGIN
set nocount on
set ansi_warnings off

exec stp_DashboardGetProfile -1, @scenario
END
GO