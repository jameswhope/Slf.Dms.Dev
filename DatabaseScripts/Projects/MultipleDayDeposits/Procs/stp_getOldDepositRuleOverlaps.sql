IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getOldDepositRuleOverlaps')
	BEGIN
		DROP  Procedure  stp_getOldDepositRuleOverlaps
	END

GO

CREATE procedure [dbo].[stp_getOldDepositRuleOverlaps]
(
	@OldRuleStartDate datetime,
	@OldRuleEndDate datetime,
	@ClientID int
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'dr.ClientID '
	set @ssql = @ssql + 'FROM tblRuleAch AS dr '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@OldRuleStartDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientID = ' + cast(@ClientID as varchar)
	set @ssql = @ssql + 'union '
	set @ssql = @ssql + 'SELECT dr.RuleACHId, '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'dr.ClientID '
	set @ssql = @ssql + 'FROM tblRuleAch AS dr '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@OldRuleEndDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientID = ' + cast(@ClientID as varchar)
	exec(@ssql)

END

GRANT EXEC ON stp_getOldDepositRuleOverlaps TO PUBLIC
