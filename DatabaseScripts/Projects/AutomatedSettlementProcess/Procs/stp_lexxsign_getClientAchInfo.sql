IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_getClientAchInfo')
	BEGIN
		DROP  Procedure  stp_lexxsign_getClientAchInfo
	END

GO

CREATE Procedure stp_lexxsign_getClientAchInfo

	(
		@clientid int,
		@onlyDeposited bit
	)
AS
BEGIN
	declare @ssql varchar(max)

	set @ssql = 'select * from tblAdHocACH '
	set @ssql = @ssql  + 'where clientid = ' + cast(@clientid as varchar)
	if @onlyDeposited = 1
		BEGIN
			set @ssql = @ssql  + ' AND RegisterID is not null '
		END
	else
		BEGIN
			set @ssql = @ssql  + ' AND RegisterID is null '
		END
		
	set @ssql = @ssql  + 'ORDER BY tblAdHocACH.DepositDate Desc, tblAdHocACH.Created Desc'

	exec(@ssql)
END

GO


GRANT EXEC ON stp_lexxsign_getClientAchInfo TO PUBLIC

GO


