IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DashboardGetItems')
	BEGIN
		DROP  Procedure  stp_DashboardGetItems
	END

GO

CREATE Procedure stp_DashboardGetItems
(
	@userid int,
	@scenario nvarchar(50)
)

as

BEGIN

set nocount on
set ansi_warnings off

declare @paramname nvarchar(50)
declare @paramvalue nvarchar(50)
declare @id int

declare @vtblProfile table
(
	DashboardItemID int,
	ClientX int,
	ClientY int
)

declare @vtblPermission table
(
	DashboardItemID int
)

declare @vtblFinal table
(
	DashboardItemID int,
	ClientX int,
	ClientY int
)

INSERT INTO
	@vtblProfile
exec
	stp_DashboardGetProfile @userid, @scenario

if (SELECT count(*) FROM @vtblProfile) = 0
begin
	INSERT INTO
		@vtblProfile
	exec
		stp_DashboardGetDefaultProfile @scenario
end

declare cursor_dashboardpermission cursor for
	SELECT DISTINCT
		UserParameterName,
		UserParameter,
		DashboardItemID
	FROM
		tblDashboardPermission
	WHERE
		Scenario = @scenario

open cursor_dashboardpermission

fetch next from cursor_dashboardpermission into @paramname, @paramvalue, @id

while @@fetch_status = 0
begin
	if @paramname is null or @paramvalue is null
	begin
		INSERT INTO
			@vtblPermission (DashboardItemID)
		VALUES
		(
			@id
		)
	end
	else
	begin
		INSERT INTO
			@vtblPermission (DashboardItemID)
		exec
		('
		SELECT
			' + @id + '
		FROM
			tblUser
		WHERE
			UserID = ' + @userid + '
			and [' + @paramname + '] = ' + @paramvalue + '
		')
	end

	fetch next from cursor_dashboardpermission into @paramname, @paramvalue, @id
end

close cursor_dashboardpermission
deallocate cursor_dashboardpermission

INSERT INTO
	@vtblFinal
SELECT DISTINCT
	pf.DashboardItemID,
	pf.ClientX,
	pf.ClientY
FROM
	@vtblProfile as pf
	inner join @vtblPermission as p on p.DashboardItemID = pf.DashboardItemID

SELECT
	di.DesignXML,
	di.SQLParamXML,
	f.ClientX,
	f.ClientY,
	isnull(di.ClientWidth, 'null') as ClientWidth,
	isnull(di.ClientHeight, 'null') as ClientHeight
FROM
	@vtblFinal as f
	inner join tblDashboardItem as di on di.DashboardItemID = f.DashboardItemID

END
GO