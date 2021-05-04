IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_GetInfo')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_GetInfo
	END

GO

CREATE Procedure stp_PaymentArrangement_GetInfo
@SettlementId int
AS
select distinct w.*, 
[CreatedByUser] = u.[firstname] + ' ' + u.[lastname],
[LastModifiedByUser] = u1.[firstname] + ' ' + u1.[lastname],
[status] = case when w.registerid is not null then 'Paid on ' + Convert(varchar(10),PmtRecdDate,101)
				when c.currentclientstatusid not in (14,16) or s.active = 0 or isnull(m.matterstatusid,0) in (2) then 'Closed'
				when convert(varchar(10),PmtDate,112) < convert(varchar(10),Getdate(),112) Then 'Past Due'
				else 'Open' End
from vw_paymentschedule_ordered w 
join tbluser u on w.createdby = u.userid
join tbluser u1 on w.lastmodifiedby = u1.userid
join tblsettlements s on s.settlementid = w.settlementid
join tblclient c on c.clientid = s.clientid
left join tblmatter m on m.matterid = s.matterid
where w.settlementid = @settlementId
GO
 
