IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CleanupCreditor_CombineCreditors')
	BEGIN
		DROP  Procedure  stp_CleanupCreditor_CombineCreditors
	END

GO

CREATE Procedure stp_CleanupCreditor_CombineCreditors
@NewCreditorId int,
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

-- Update creditorid in tables

--tblCreditorInstance
/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, CreditorId, 'tblCreditorInstance', 'CreditorId', CreditorInstanceId, @UserId
From tblCreditorInstance
Where CreditorId in (Select CreditorId From #t)
*/

Update tblCreditorInstance Set
CreditorId = @NewCreditorId,
LastModified = GetDate(),
LastModifiedBy = @UserId
Where CreditorId in (Select CreditorId From #t)

/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, ForCreditorId, 'tblCreditorInstance', 'ForCreditorId', CreditorInstanceId, @UserId
From tblCreditorInstance
Where ForCreditorId in (Select CreditorId From #t)
*/

Update tblCreditorInstance Set
ForCreditorId = @NewCreditorId,
LastModified = GetDate(),
LastModifiedBy = @UserId
Where ForCreditorId in (Select CreditorId From #t)

--tblHarassmentClient
/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, OriginalCreditorId, 'tblHarassmentClient', 'OriginalCreditorId', ClientSubmissionId, @UserId
From tblHarassmentClient
Where OriginalCreditorId in (Select CreditorId From #t)
*/

Update tblHarassmentClient Set
OriginalCreditorId = @NewCreditorId
Where OriginalCreditorId in (Select CreditorId From #t)

/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, CurrentCreditorId, 'tblHarassmentClient', 'CurrentCreditorId', ClientSubmissionId, @UserId
From tblHarassmentClient
Where CurrentCreditorId in (Select CreditorId From #t)
*/

Update tblHarassmentClient Set
CurrentCreditorId = @NewCreditorId 
Where CurrentCreditorId in (Select CreditorId From #t)

/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, CreditorId, 'tblLeadCreditorInstance', 'CreditorId', LeadCreditorInstance, @UserId
From tblLeadCreditorInstance
Where CreditorId in (Select CreditorId From #t)
*/

--tblLeadCreditorInstance
Update tblLeadCreditorInstance Set
CreditorId = @NewCreditorId,
Modified = GetDate(),
ModifiedBy = @UserId
Where CreditorId in (Select CreditorId From #t)


update tblleadcreditorinstance
set creditorgroupid = c.creditorgroupid, name = c.name, street = c.street, street2 = c.street2, city = c.city, stateid = c.stateid, zipcode = c.zipcode
from tblleadcreditorinstance ci
join tblcreditor c on c.creditorid = ci.creditorid
	and c.creditorid = @NewCreditorId
	

/*
Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, CreditorId, 'tblCreditorPhone', 'CreditorId', CreditorPhoneId, @UserId
From tblCreditorPhone
Where CreditorId in (Select CreditorId From #t)
*/

--tblCreditorPhone
Update tblCreditorPhone Set
CreditorId = @NewCreditorId,
LastModified = GetDate(),
LastModifiedBy = @UserId
Where CreditorId in (Select CreditorId From #t)


update tblcreditorhistory
set newcreditorid = @NewCreditorId
where creditorid in (Select CreditorId From #t)


update tblcreditliabilitylookup
set creditorid = @NewCreditorId, CreditorIdUpdated = getdate(), CreditorIdUpdatedBy = @UserId
where creditorid in (Select CreditorId From #t)


Insert Into tblCreditorCleanupLog([NewValue], [OldValue], TableName, FieldName, KeyId, [By])
Select @NewCreditorId, CreditorId, 'tblCreditor', 'CreditorId', CreditorId, @UserId
From tblCreditor
Where CreditorId in (Select CreditorId From #t)
and CreditorId <> @NewCreditorId 

--combined creditors 
Delete from tblCreditor
Where CreditorId in (Select CreditorId From #t)
and CreditorId <> @NewCreditorId 

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

