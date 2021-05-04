
if exists (select * from sysobjects where name = 'stp_GetDepositExceptionReport')
	drop procedure stp_GetDepositExceptionReport
go
 
Create Procedure stp_GetDepositExceptionReport
@ReportId int
AS
Begin
--Insert Nacha Records					 
Select r.ReportDetailId as ReportDetailId, 
	   r.ReportId as  ReportId,  
	   r.TransactionId as TransactionId, 
	   'ACH' as DepositType,
	   n.Status as [Status],
	   n.ClientId as ClientId,
	   n.Name AS [ClientName],
	   cast('' as varchar(50)) AS CheckNumber,
	   n.ShadowStoreId as ShadowStoreId,
	   n.RegisterId as RegisterId,
	   n.Amount as Amount, 
	   n.ExceptionCode AS [ReasonCode],
	   isnull(CASE WHEN n.Status in (1,2)  THEN (Select top 1 ReasonDescription From tblChecksiteStatusReason Where ReasonCode = n.ExceptionCode)
				   WHEN n.Status = 3 THEN (Select top 1 BouncedDescription From tblBouncedReasons Where BouncedCode = n.ExceptionCode)
				   ELSE Null END, '') AS [ReasonDescription],
	   CASE WHEN r.StateId = 3 THEN convert(bit,1) ELSE convert(bit,0) END as [Bounced],
	   n.RoutingNumber as  BankRouting,
	   n.AccountNumber as  BankAccount,
	   Cast(null  as Varchar(max)) as FrontImagePath,
	   cp.ShortCoName as SA,
	   a.Code as Agency,
	   CIDRep = isnull(u.firstname,'') + ' ' + isnull(u.lastname,''),
	   n.Type as BankType,
	   Bank = (Select b.CustomerName from tblroutingnumber b where n.routingnumber = b.routingnumber)
into #report
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblNachaRegister2 n on r.TransactionId = convert(varchar, n.NachaRegisterid)
left join tblCommRec cr on n.CommRecId = cr.CommRecId
left join tblRegister t on t.RegisterId = n.RegisterId
left join tblEntryType e on e.EntryTypeId = t.EntryTypeId
left join tblcompany cp on cp.CompanyId = n.CompanyId
left join tblclient  c on c.clientid = n.clientid
left join tblagency a on a.agencyid = c.agencyid
left join vw_leadapplicant_client w on w.clientid = c.clientid
left join tblleadapplicant l on l.leadapplicantid = w.leadapplicantId
left join tbluser u on l.repid = u.userid
Where r.ReportId = @ReportId 
And s.StateGroupId = 3
And r.TransactionType in (3,5,7)

--Insert Check21 Records					 
Insert Into #report(ReportDetailId, ReportId, TransactionId, DepositType,
					[Status], ClientId, ClientName, CheckNumber,
					ShadowStoreId, RegisterId, Amount,
					ReasonCode, ReasonDescription, Bounced, FrontImagePath, SA, Agency, CIDRep)
Select r.ReportDetailId, 
	   r.ReportId,  
	   r.TransactionId, 'C21',
	   b.Status,
	   (Select ClientId From tblClient Where AccountNumber = b.AccountNumber),
	   p.FirstName + ' ' + p.LastName AS [ClientName],
	   b.CheckNumber,
	   b.AccountNumber,	
	   b.DepositId,
	   b.Amount, 
	   b.ExceptionCode AS [ReasonCode],
	   isnull(CASE WHEN b.Status in (1,2)  THEN (Select top 1 ReasonDescription From tblChecksiteStatusReason Where ReasonCode = b.ExceptionCode)
				   WHEN b.Status = 3 THEN (Select top 1 BouncedDescription From tblBouncedReasons Where BouncedCode = b.ExceptionCode)
				   ELSE Null END, '') AS [ReasonDescription],
	   CASE WHEN r.StateId = 3 THEN convert(bit,1) ELSE convert(bit,0) END as [Bounced],
	   isnull(b.FrontImagePath, '') AS [FrontImagePath],
	   cp.ShortCoName,
	   a.Code,
   	   CIDRep = isnull(u.firstname,'') + '' + isnull(u.lastname,'') 
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblC21BatchTransaction b on b.TransactionId = r.TransactionId
left join tblRegister t on t.RegisterId = b.DepositId
left join tblClient c on c.AccountNumber = b.AccountNumber
left join tblPerson p on p.ClientId = c.ClientId
left join tblcompany cp on cp.CompanyId = c.CompanyId
left join tblagency a on a.agencyid = c.agencyid
left join vw_leadapplicant_client w on w.clientid = c.clientid
left join tblleadapplicant l on l.leadapplicantid = w.leadapplicantId
left join tbluser u on l.repid = u.userid
Where r.ReportId = @ReportId
And (p.relationship is null or p.relationship = 'prime')
And s.StateGroupId = 3
And r.TransactionType in (3,5,7)

--Return Data
Select * from #report
Order By  ReportDetailId

drop table #report

End

Go