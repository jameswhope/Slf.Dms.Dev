IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetMultiDepositRulesByCheckRuleID')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetMultiDepositRulesByCheckRuleID
	END

GO

create procedure [dbo].[stp_NonDeposit_GetMultiDepositRulesByCheckRuleID]
(
	@CheckRuleID int
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT dr.RuleCheckId, '
	set @ssql = @ssql + 'dr.DepositAmount, dr.DepositDay, dr.StartDate, dr.EndDate, '
	set @ssql = @ssql + 'dr.ClientDepositID, dr.DateUsed, '
	set @ssql = @ssql + 'LEFT(u.FirstName,1) + ''. '' + u.LastName As [uCreatedBy], '
	set @ssql = @ssql + 'dr.Created, '
	set @ssql = @ssql + 'LEFT(u1.FirstName,1) + ''. '' + u1.LastName as [uLastModifiedBy], ' 
	set @ssql = @ssql + 'dr.LastModified '
	set @ssql = @ssql + 'FROM tblDepositRuleCheck AS dr '
	set @ssql = @ssql + 'INNER JOIN tblUser u ON u.userid = dr.CreatedBy '
	set @ssql = @ssql + 'INNER JOIN tblUser u1 ON u1.userid = dr.LastModifiedBy '
	set @ssql = @ssql + 'WHERE dr.RuleCheckId = ' + cast(@CheckRuleID as varchar)
	exec(@ssql)
			
END




 




 