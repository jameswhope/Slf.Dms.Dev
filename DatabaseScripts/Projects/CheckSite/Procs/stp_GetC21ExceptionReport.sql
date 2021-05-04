if exists (select * from sysobjects where name = 'stp_GetC21ExceptionReport')
	drop procedure stp_GetC21ExceptionReport
go
 
Create Procedure stp_GetC21ExceptionReport
@ReportId int
AS
Begin
Declare @report table(ReportDetailId int,
					 ReportId int,
					 TransactionId varchar(255),
 					 [Status] int,
 					 [State] int,
					 CheckNumber varchar(50),
					 CheckType int,
					 ShadowStoreId varchar(255),
					 DepositId int,
					 Amount money,
					 ClientId int,
					 ClientName varchar(255),
					 ReasonCode varchar(255),
					 ReasonDescription varchar(255),
					 CreatedDate varchar(50),
					 ReceivedDate varchar(50),
					 ProcessedDate varchar(50),
					 FrontImagePath varchar(255),
					 ToDo varchar(255))
					 
--Insert C21 Records					 
Insert Into @report(ReportDetailId, ReportId,  TransactionId, 
					[Status], [State], CheckNumber, CheckType,
					ShadowStoreId, DepositId, Amount,
					ClientId, ClientName,
					ReasonCode, ReasonDescription, CreatedDate, ReceivedDate, ProcessedDate, FrontImagePath, ToDo)
Select r.ReportDetailId, 
	   r.ReportId,  
	   r.TransactionId,  
	   t.Status,
	   t.State,
	   t.CheckNumber,
	   t.CheckType,
	   t.AccountNumber,
	   t.DepositId,
	   t.Amount, 
	   c.clientid,
	   p.firstname + ' ' + p.lastname,
	   t.ExceptionCode AS [ReasonCode],
	   isnull(CASE WHEN t.Status in (1,2)  THEN (Select top 1 ReasonDescription From tblChecksiteStatusReason Where ReasonCode = t.ExceptionCode)
				   WHEN t.Status = 3 THEN (Select top 1 BouncedDescription From tblBouncedReasons Where BouncedCode = t.ExceptionCode)
   				   WHEN t.Status = 0 THEN 'Match not found'
				   ELSE t.Notes END, '') AS [ReasonDescription],
	   convert(varchar,t.Created,101),
	   convert(varchar,t.ReceivedDate,101), 
	   convert(varchar,t.ProcessedDate,101),
  	   isnull(t.FrontImagePath, '') AS [FrontImagePath],
  	   CASE WHEN t.Status = 2  THEN 'Match Manually/ Void if needed'
	   ELSE 'Match Manually/ Clear if needed' END
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblC21BatchTransaction t on t.transactionid = r.transactionid
left join tblclient c on c.accountnumber = t.accountnumber
left join tblperson p on p.personid = c.primarypersonid
Where r.ReportId = @ReportId 
And s.StateGroupId = 3
And r.StateId in (4,5)
And r.TransactionType in (5,7)

--Return Data
Select * from @report
Order By  ReportDetailId

--Return all C21 that have not been assigned yet
Select 
	   b.TransactionId as TransactionId,  
	   b.Status as [Status],
	   b.State as [State],
	   b.CheckNumber as [CheckNumber],
	   b.CheckType as [CheckType],
	   b.AccountNumber as [AccountNumber],
	   b.Amount as [Amount], 
  	   c.clientid as [ClientId],
	   p.firstname + ' ' + p.lastname as [ClientName],
	   b.ExceptionCode AS [ReasonCode],
	   isnull(CASE WHEN b.Status in (1,2)  THEN (Select top 1 ReasonDescription From tblChecksiteStatusReason Where ReasonCode = b.ExceptionCode)
				   WHEN b.Status = 3 THEN (Select top 1 BouncedDescription From tblBouncedReasons Where BouncedCode = b.ExceptionCode)
   				   WHEN b.Status = 0 THEN 'Match not found'
				   ELSE b.Notes END, '') AS [ReasonDescription],
	   convert(varchar, b.Created, 101) as [CreatedDate],
	   convert(varchar, b.ReceivedDate, 101) as [ReceivedDate], 
	   convert(varchar, b.ProcessedDate, 101) as [ProcessedDate],
  	   isnull(b.FrontImagePath, '') AS [FrontImagePath],
  	   DateDiff(d, b.Created, GetDate()) as [Days]  
from tblc21batchtransaction  b
left join tblclient c on c.accountnumber = b.accountnumber
left join tblperson p on p.personid = c.primarypersonid
where b.hide = 0 and b.depositid is null and b.closed = 1
and DateDiff(d, b.Created, GetDate()) > 0

--Return all deposits that are pending for assignment
Select 
r.registerid as [DepositId], 
r.clientid as [ClientId],
c.accountnumber as [AccountNumber],
p.firstname + ' ' + p.lastname as [ClientName],
r.checknumber as [CheckNumber],
convert(varchar,r.created, 101) as [CreatedDate],
u1.username as [CreatedBy],
r.amount  as [Amount],
convert(varchar, r.hold, 101) as [HoldDate],
u2.username as [HoldBy],
convert(varchar, r.clear, 101) as [ClearDate],
u3.username as [ClearBy],
DateDiff(d, r.created, GetDate()) as Days
from tblregister r
inner join tblclient c on c.clientid = r.clientid and c.trustid = 22
inner join tblperson p on p.personid = c.primarypersonid
left join tblc21batchtransaction b on b.depositid = r.registerid
left join 
(select pk, max(dc) as DateChange from tblaudit where auditcolumnid = 4 and value = 22 group by pk) a on a.pk = c.clientid
left join tbluser u1 on u1.userid = r.createdby
left join tbluser u2 on u2.userid = r.holdby
left join tbluser u3 on u3.userid = r.clearby
where r.checknumber is not null
and r.entrytypeid = 3
and r.importid is null
and b.depositid is null
and (r.created >= a.DateChange or a.DateChange is null)
and r.bounce is null
and r.void is null
and DateDiff(d, r.created, GetDate()) > 2
and isnull(r.notC21,0) = 0 
Order by r.created

End

Go