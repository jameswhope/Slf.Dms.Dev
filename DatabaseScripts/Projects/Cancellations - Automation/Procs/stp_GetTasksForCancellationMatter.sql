IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTasksForCancellationMatter')
	BEGIN
		DROP  Procedure  stp_GetTasksForCancellationMatter
	END

GO

CREATE Procedure stp_GetTasksForCancellationMatter
(
@CompanyXml XML = null,
@MatterSubStatusId INT= 80
)
AS BEGIN
	SET ARITHABORT ON;
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER ON;
	SET ANSI_PADDING ON;

	IF @CompanyXml is null BEGIN
		SET @CompanyXml = (SELECT CompanyId "@id" FROM tblCompany FOR XML PATH('Company'))
	END

	SELECT
		ms.MatterSubStatus As Task, 
		cl.Created As TaskCreatedDate,		
		u.FirstName + ' ' + left(u.LastName,1) + '.' [MatterCreatedBy],		
		cl.CancellationId,
		cl.MatterId,
		cl.ClientID,
		p.firstname +' '+ p.lastname AS clientname, 
		c.AvailableSDA AS RegisterBalance, 
		c.AccountNumber AS ClientAccountNumber,
		com.shortconame, 
		c.PFOBalance,
		c.BankReserve
	FROM 
		tblCancellation cl  inner join 
		tblMatter m ON m.MatterId = cl.MatterId and m.IsDeleted = 0 and 
				m.MatterTypeId = 4 and m.MatterSubStatusId = @MatterSubStatusId inner join
		tblMatterSubStatus ms ON ms.MatterSubStatusId = m.MatterSubStatusId inner join
		tblMatterStatus mst ON mst.MatterStatusId = ms.MatterStatusId and mst.IsMatterActive = 1 inner join
		tblclient c ON m.ClientID=c.ClientID inner join 
		tblcompany com ON c.companyid=com.companyid and com.CompanyId in (SELECT ParamValues.ParamId.value('@id','int') 
				FROM @CompanyXml.nodes('/Company') AS ParamValues(ParamId)) inner join 
		tblperson p ON c.primarypersonid=p.personid left join 
		tblUser u ON u.UserId = cl.LastModifiedBy
	ORDER BY cl.Created ASC

	SET ARITHABORT OFF;
	
END
GO

