IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTasksForSettlementMatter')
	BEGIN
		DROP  Procedure  stp_GetTasksForSettlementMatter
	END

GO

CREATE Procedure [dbo].[stp_GetTasksForSettlementMatter]
(
	@CompanyXml XML = null,
	@ToDate DATETIME = null,
	@FromDate DATETIME = null,
	@NegotiatorID int = null
)
AS BEGIN
	SET ARITHABORT ON;
	IF @FromDate is null BEGIN
		SELECT @FromDate = min(SettlementDueDate) FROM tblSettlements WHERE MatterId is not null  
	END
	IF @ToDate is null BEGIN
		SELECT @ToDate = max(SettlementDueDate) FROM tblSettlements WHERE MatterId is not null 
	END
	IF @CompanyXml is null BEGIN
		SET @CompanyXml = (SELECT CompanyId "@id" FROM tblCompany FOR XML PATH('Company'))
	END

	SELECT
		t.TaskId,
		t.TaskTypeId,
		t.Description As Task, 
		t.Due As TaskDueDate,
		u.FirstName + ' ' + left(u.LastName,1) + '.' [TaskCreatedBy],
		(CASE 
			WHEN t.Due > getdate() THEN 'OPEN'
			ELSE 'PAST DUE'
		END) As TaskStatus,
		s.SettlementID,
		s.ClientID,
		s.SettlementDueDate,
		p.firstname +' '+ p.lastname AS clientname, 
		cr.Name AS creditorname, 
		s.SettlementAmount AS SettlementAmount, 
		s.Status, 
		s.CreditorAccountID, 
		c.AvailableSDA AS RegisterBalance, 
		c.AccountNumber AS ClientAccountNumber,
		com.shortconame, 
		a.AccountId,
		c.SDABalance,
		c.BankReserve,
		n.userid [NegotiatorID],
		n.firstname + ' ' + left(n.lastname,1) + '.' [Negotiator],
		dialerstats = (select convert(varchar,count(d.callmadeid)) + '\' + convert(varchar,coalesce(sum(case when d.resultid = 3 then 1 else 0 end),0))
					  from tbldialercall d
					  where d.clientid = c.clientid and d.started between m.createddatetime and getdate()),
		s.IsPaymentArrangement,
		s.IsClientStipulation
	FROM 
		tblSettlements s  inner join 
		tblMatter m ON m.MatterId = s.MatterId and m.IsDeleted = 0 and m.MatterStatusCodeId in (23,56)  left join 
		tblMatterTask mt ON mt.MatterId = m.MatterId inner join
		tblTask t ON t.TaskId = mt.TaskId and t.TaskResolutionId is null and t.TaskTypeId in (72,78,84) inner join
		tblclient c ON s.ClientID=c.ClientID inner join 
		tblcompany com ON c.companyid=com.companyid and com.CompanyId in (SELECT ParamValues.ParamId.value('@id','int') 
				FROM @CompanyXml.nodes('/Company') AS ParamValues(ParamId)) inner join 
		tblperson p ON c.primarypersonid=p.personid left join 
		tblAccount a ON a.AccountId = s.CreditorAccountId inner join 
		tblcreditorinstance ci ON ci.creditorinstanceid = a.OriginalCreditorInstanceId inner join 
		tblcreditor cr ON ci.creditorid=cr.creditorid inner join
		tblUser u ON u.UserId = t.CreatedBy join
		tbluser n on n.userid = s.createdby
	WHERE 
		s.SettlementDueDate between @FromDate and @ToDate
		and (@NegotiatorID is null or n.userid = @NegotiatorID)
	ORDER BY 
		s.SettlementDueDate ASC

	SET ARITHABORT OFF;
	
END
