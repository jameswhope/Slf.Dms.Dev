IF EXISTS (SELECT * FROM sysobjects 
WHERE type = 'P'
AND name = 'stp_getOldDepositRules') 
		DROP PROCEDURE [dbo].[stp_getOldDepositRules]
GO
/****** Object:  StoredProcedure [dbo].[stp_getOldDepositRules]    Script Date: 03/12/2009 16:10:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[stp_getOldDepositRules]
(
	@ClientID int 
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT RuleACHId, ' 
	set @ssql = @ssql + 'BankRoutingNumber, BankAccountNumber, BankType, DepositAmount, DepositDay, StartDate, EndDate '
	set @ssql = @ssql + 'FROM tblRuleAch '
	set @ssql = @ssql + 'WHERE ClientId = ' + cast(@ClientID as varchar) + ' ' 
	set @ssql = @ssql + 'AND StartDate <= ' + char(39) + cast(getdate() as varchar) + char(39) + ' AND (EndDate is null OR EndDate >= ' 
	set @ssql = @ssql + char(39) + cast(getdate() as varchar) + char(39) + ')'

	exec(@ssql)
			
END

