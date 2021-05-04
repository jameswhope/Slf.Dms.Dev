IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ReassignCreditorGroup')
	BEGIN
		DROP  Procedure  stp_ReassignCreditorGroup
	END

GO

CREATE Procedure stp_ReassignCreditorGroup
@CreditorGroupId int,
@XMLCreditorIdList varchar(max),
@UserId int
AS
BEGIN
-- Creditor Id Table
declare @hXML int
EXEC sp_xml_preparedocument @hXML OUTPUT, @XMLCreditorIdList
Select *
into #t
From OPENXML(@hXML, '/creditors/creditor', 2)
With (creditorid varchar(10) '@creditorid')

-- get creditor groups
Select distinct CreditorGroupId 
Into #c
From tblCreditor
Where creditorid in (Select CreditorId From #t)
and  CreditorGroupId  is not null


/*
-- Save Log
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @CreditorGroupId, CreditorGroupId, 'tblCreditor', 'CreditorGroupId', CreditorId, @UserId
From tblCreditor
Where CreditorId in (Select CreditorId From #t)
*/

-- Update creditors
Update tblCreditor Set 
CreditorGroupId = @CreditorGroupId,
LastModified = GetDate(),
LastModifiedBy = @UserId
Where CreditorId in (Select CreditorId From #t)

--Delete Creditor Groups with no creditors
Delete from tblCreditorGroup 
Where CreditorGroupId in 
(Select c.CreditorGroupId from #c c 
left join (Select CreditorGroupId as [CreditorGroupId] from tblCreditor Union Select CreditorGroupId from tblLeadCreditorInstance) t on t.CreditorGroupId = c.CreditorGroupId
where t.CreditorGroupId is null)

Drop table #c
Drop table #t

END

GO

