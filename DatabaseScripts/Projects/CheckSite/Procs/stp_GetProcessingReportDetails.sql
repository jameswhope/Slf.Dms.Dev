IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetProcessingReportDetails')
	BEGIN
		DROP  Procedure  stp_GetProcessingReportDetails
	END

GO

CREATE Procedure stp_GetProcessingReportDetails
@ReportId int,
@ExceptionOnly bit = 0
AS
BEGIN
SET NOCOUNT ON

declare @nacha table (NachaRegisterId int, reportdetailid int)
create table #reportp (ReportDetailId int not null primary key,
					 ReportId int,
					 StateId int,
					 StateDescription varchar(255),
					 StateGroupId int,
					 StateGroupDescription varchar(255),
					 CssClass varchar(255),
					 TransactionId varchar(255),
					 Notes varchar(max),
					 ClientName varchar(255),
					 AccountNumber varchar(50),
					 CheckNumber varchar(50),
					 Created datetime,
					 SentDate datetime,
					 ReceivedDate datetime,
					 ShadowStoreId varchar(255),
					 RegisterId int,
					 RegisterPaymentId int,
					 Amount money,
					 Recipient varchar(255),
					 TransactionType int,
					 Fee varchar(255),
					 GroupSeq int,
					 StateSeq int,
					 FrontImagePath varchar(255))

Insert into  @nacha(NachaRegisterId, ReportDetailId)
Select n.NachaRegisterId, r.ReportDetailId
From tblNachaRegister2 n
inner join tblProcessingReportDetail r on r.TransactionId = convert(varchar, n.nacharegisterid)
Where r.ReportId =  @ReportId

			 
--Insert Nacha Records					 
Insert Into #reportp(ReportDetailId, ReportId, StateId, StateDescription,
					StateGroupId, StateGroupDescription, CssClass, TransactionId,
					Notes, ClientName, AccountNumber, CheckNumber, Created, SentDate, ReceivedDate,
					ShadowStoreId, RegisterId, RegisterPaymentId, Amount,
					Recipient, TransactionType, Fee, GroupSeq, StateSeq)
Select r.ReportDetailId, 
	   r.ReportId,  
	   r.StateId, 
	   s.Description AS [StateDescription],
	   s.StateGroupId,
	   g.Description AS [StateGroupDescription],
	   g.CssClass,
	   r.TransactionId, 
	   r.Notes,
	   n.Name AS [ClientName],
	   n.AccountNumber,
	   '' AS CheckNumber,
	   n.Created,
	   f.DateSent,
	   n.ReceivedDate,
	   n.ShadowStoreId,
	   n.RegisterId,
	   n.RegisterPaymentId,
	   n.Amount, 
	   isnull(cr.Display, '') AS [Recipient],
	   r.TransactionType,
	   isnull(e.DisplayName, '') AS [Fee],
	   g.Seq as [GroupSeq],
	   s.Seq as [StateSeq]
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblProcessingReportStateGroup g on g.StateGroupId = s.StateGroupId
inner join @nacha p on p.ReportDetailId = r.ReportDetailId
inner join tblNachaRegister2 n on n.NachaRegisterId = p.NachaRegisterId 
left join tblCommRec cr on n.CommRecId = cr.CommRecId
left join tblRegister t on t.RegisterId = n.RegisterId
left join tblEntryType e on e.EntryTypeId = t.EntryTypeId
left join tblNachafile f on f.NachaFileId = n.NachaFileId
Where r.ReportId = @ReportId And (@ExceptionOnly = 0 or g.StateGroupId = 3)

--Insert Check21 Records					 
Insert Into #reportp(ReportDetailId, ReportId, StateId, StateDescription,
					StateGroupId, StateGroupDescription, CssClass, TransactionId,
					Notes, ClientName, AccountNumber, CheckNumber, Created, ReceivedDate,
					ShadowStoreId, RegisterId, RegisterPaymentId, Amount,
					Recipient, TransactionType, Fee, GroupSeq, StateSeq, FrontImagePath)
Select r.ReportDetailId, 
	   r.ReportId,  
	   r.StateId, 
	   s.Description AS [StateDescription],
	   s.StateGroupId,
	   g.Description AS [StateGroupDescription],
	   g.CssClass,
	   r.TransactionId, 
	   r.Notes,
	   p.FirstName + ' ' + p.LastName AS [ClientName],
	   b.AccountNumber,
	   b.CheckNumber,
	   b.Created,
	   b.ReceivedDate,
	   '',
	   b.DepositId,
	   NULL,
	   b.Amount, 
	   '',
	   r.TransactionType,
	   '',
	   g.Seq as [GroupSeq],
	   s.Seq as [StateSeq],
	   isnull(b.FrontImagePath, '') AS [FrontImagePath]
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblProcessingReportStateGroup g on g.StateGroupId = s.StateGroupId
inner join tblC21BatchTransaction b on b.TransactionId = r.TransactionId
left join tblRegister t on t.RegisterId = b.DepositId
left join tblClient c on c.AccountNumber = b.AccountNumber
left join tblPerson p on p.ClientId = c.ClientId
Where r.ReportId = @ReportId
And (p.relationship is null or p.relationship = 'prime')
And (@ExceptionOnly = 0 or g.StateGroupId = 3)

--Exceptions. Insert orphans if any
Insert Into #reportp(ReportDetailId, ReportId, StateId, StateDescription,
					StateGroupId, StateGroupDescription, CssClass, TransactionId,
					Notes, TransactionType, GroupSeq, StateSeq)
Select r.ReportDetailId, 
	   r.ReportId,  
	   r.StateId, 
	   s.Description AS [StateDescription],
	   s.StateGroupId,
	   g.Description AS [StateGroupDescription],
	   g.CssClass,
	   r.TransactionId, 
	   r.Notes,
	   r.TransactionType,
	   g.Seq as [GroupSeq],
	   s.Seq as [StateSeq]
From tblProcessingReportDetail r
inner join tblProcessingReportState s on s.StateId = r.StateId 
inner join tblProcessingReportStateGroup g on g.StateGroupId = s.StateGroupId
Where r.ReportId = @ReportId
And r.ReportDetailId not in (Select ReportDetailId from #reportp)
And (@ExceptionOnly = 0 or g.StateGroupId = 3)

--Return Data
Select * from #reportp
Order By GroupSeq, StateSeq, ReportDetailId

drop table #reportp

SET NOCOUNT OFF
END
GO


