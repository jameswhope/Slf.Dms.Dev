IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetMultiDepositCheckRuleOverlaps')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetMultiDepositCheckRuleOverlaps
	END

GO

create procedure [dbo].[stp_NonDeposit_GetMultiDepositCheckRuleOverlaps]
(
	@NewRuleStartDate datetime,
	@NewRuleEndDate datetime,
	@ClientDepositID int,
	@ExcludeRuleId int = Null
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT dr.RuleCheckId, '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate '
	set @ssql = @ssql + 'FROM tblDepositRuleCheck AS dr '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleStartDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleCheckId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar)  
	set @ssql = @ssql + ' union '
	set @ssql = @ssql + 'SELECT dr.RuleCheckId, '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate  '
	set @ssql = @ssql + 'FROM tblDepositRuleCheck AS dr  '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleEndDate as varchar) + char(39) + ' between dr.startdate and dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleCheckId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar) 
	set @ssql = @ssql + ' union '
	set @ssql = @ssql + 'SELECT dr.RuleCheckId,  '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate '
	set @ssql = @ssql + 'FROM tblDepositRuleCheck AS dr '
	set @ssql = @ssql + 'WHERE ' + char(39) + cast(@NewRuleStartDate as varchar) + char(39) + ' <= dr.startdate '
	set @ssql = @ssql + 'and ' + char(39) + cast(@NewRuleEndDate as varchar) + char(39) + ' >= dr.enddate '
	set @ssql = @ssql + 'and dr.ClientDepositID = ' + cast(@ClientDepositID as varchar) + ' and dr.RuleCheckId <> ' + cast(isnull(@ExcludeRuleId, 0) as varchar)  
	exec(@ssql)

END



 