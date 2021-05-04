IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_cancellation_getClientRulesAndAdhoc')
	BEGIN
		DROP  Procedure  stp_cancellation_getClientRulesAndAdhoc
	END

GO

CREATE Procedure stp_cancellation_getClientRulesAndAdhoc
(
	@clientid int,
	@OnlyNotDeposited bit,
	@OnlyCurrent bit
)
as
BEGIN
	declare @sSQL varchar(max)
--	declare @clientid int
--	declare @OnlyNotDeposited bit
--	declare @OnlyCurrent bit
--
--	set @clientid = 66217
--	set @OnlyNotDeposited = 1
--	set @OnlyCurrent = 1

	set @sSQL = 'SELECT * FROM (' + char(13)
	set @sSQL = @sSQL + 'SELECT AdhocACHId As FieldId,  ''ADHOC''[Type], ClientID, BankName, BankRoutingNumber, BankAccountNumber,DepositDate[StartDate],DepositDate[EndDate],day(DepositDate)[DepositDay], DepositAmount, isnull(BankType,''?'')[BankType], case when InitialDraftYN = 1 then ''Yes'' else ''No'' end[InitialDraftYN], created ' + char(13)
	set @sSQL = @sSQL + 'FROM  tblAdHocACH AS adhoc WHERE ClientID = ' + cast(@ClientID as varchar)
	set @sSQL = @sSQL + case when @OnlyNotDeposited = 1 then ' AND RegisterID is null' else '' end 
	set @sSQL = @sSQL + char(13) + ' UNION ' + char(13)
	set @sSQL = @sSQL + 'SELECT RuleACHId As FieldId, ''RULE''[Type],  ClientId, BankName, BankRoutingNumber, BankAccountNumber, StartDate, EndDate, DepositDay, DepositAmount, BankType, ''N/A''[InitialDraftYN], created '
	set @sSQL = @sSQL + 'FROM tblRuleACH WHERE ClientID = ' + cast(@ClientID as varchar) 
	set @sSQL = @sSQL + case when @OnlyCurrent = 1 then ' AND StartDate <= ' + char(39) + convert(varchar(10), getdate(),101) + char(39) + ' AND (EndDate is null OR EndDate >= ' + char(39) + convert(varchar(10), getdate(),101) + char(39) + ')' else '' end  + char(13)
	set @sSQL = @sSQL + ') as rules_adhoc ORDER BY created '

	exec(@sSQL)
END


GRANT EXEC ON stp_cancellation_getClientRulesAndAdhoc TO PUBLIC

