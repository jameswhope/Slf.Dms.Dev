﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_CountsByTaskName')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_CountsByTaskName
	END

GO

CREATE Procedure stp_settlementimport_reports_CountsByTaskName
	(
		@year int,
		@month int
	)
AS
BEGIN
	
	declare @tblr table(rOrder int,TaskName varchar(200), TotalUnits int, TotalAmt money)

	insert into @tblr select 0,'Waiting on SIF - Offers Accepted',(select count(*) from tblsettlements with(nolock) where year(created) = @year and month(created) = @month and status='a'),(select sum(settlementfee + adjustedsettlementfee) from tblsettlements where year(created) = @year and month(created) = @month and status='a')
	insert into @tblr select 1,'Waiting on SIF - No SIF Attached',(select count(*) from tblsettlements with(nolock) where year(created) = @year and month(created) = @month and status='a' and active = 1 and matterid is null),(select sum(settlementfee + adjustedsettlementfee) from tblsettlements where year(created) = @year and month(created) = @month and status='a' and active = 1 and matterid is null)
	insert into @tblr select 3,'Waiting on Client - SIF Attached',(select count(*) from tblsettlements with(nolock) where year(created) = @year and month(created) = @month and matterid is not null and active = 1),(select sum(settlementfee + adjustedsettlementfee) from tblsettlements where year(created) = @year and month(created) = @month  and matterid is not null and active = 1)
	insert into @tblr select 4,'Waiting on Client - Client Approval/Rejection',isnull((select count(sca.SettlementId) from tblSettlements sca with(nolock) inner join tblMatter m with(nolock) on m.MatterId = sca.MatterId and m.MatterStatusCodeId = 23 inner join tblMatterSTatus ms with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMAtterActive = 1 where year(sca.created) = @year and month(sca.created) = @month and sca.active = 1 and sca.status = 'a'),0),isnull((select sum(sca.Settlementamount) from tblSettlements sca with(nolock) inner join tblMatter m with(nolock) on m.MatterId = sca.MatterId and m.MatterStatusCodeId = 23 inner join tblMatterSTatus ms with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMAtterActive = 1 where year(sca.created) = @year and month(sca.created) = @month and sca.active = 1 and sca.status = 'a'),0)
	insert into @tblr select 5,'Waiting on Accounting - SIF Attached',isnull((select count(swaa.SettlementId) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and swaa.active = 1 and swaa.status = 'a'),0),isnull((select sum(swaa.settlementfee + adjustedsettlementfee) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and swaa.active = 1 and swaa.status = 'a'),0)
	insert into @tblr select 6,'Waiting on Accounting - Client Approved',isnull((select count(saw.SettlementId) from tblSettlements saw with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = saw.MatterId inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(saw.created) = @year and month(saw.created) = @month and active =1 and status = 'a' ),0),isnull((select sum(saw.settlementfee + adjustedsettlementfee) from tblSettlements saw with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = saw.MatterId inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(saw.created) = @year and month(saw.created) = @month and active =1 and status = 'a'),0)
	insert into @tblr select 7,'Waiting on Accounting - Approval',isnull((select count(swaa.SettlementId) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and active =1 and status = 'a' ),0),isnull((select sum(swaa.settlementfee + adjustedsettlementfee) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and active =1 and status = 'a'),0)
	insert into @tblr select 8,'Waiting on Payment - SIF Attached',isnull((select count(swpp.SettlementId) from tblSettlements swpp with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swpp.MatterId and MatterStatusCodeId in(35,39,40) inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swpp.created) = @year and month(swpp.created) = @month and active =1 and status = 'a' ),0),isnull((select sum(swpp.settlementfee + adjustedsettlementfee) from tblSettlements swpp with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swpp.MatterId and MatterStatusCodeId in(35,39,40)  inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swpp.created) = @year and month(swpp.created) = @month and active =1 and status = 'a'),0)
	insert into @tblr select 9,'Waiting on Payment - Client Approved',isnull((select count(swpp.SettlementId) from tblSettlements swpp with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swpp.MatterId and MatterStatusCodeId in(35,39,40) inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(swpp.created) = @year and month(swpp.created) = @month and swpp.active =1 and status = 'a'),0),isnull((select sum(swpp.settlementfee + adjustedsettlementfee) from tblSettlements swpp with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swpp.MatterId and MatterStatusCodeId in(35,39,40)  inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(swpp.created) = @year and month(swpp.created) = @month and swpp.active =1 and status = 'a'),0)
	insert into @tblr select 10,'Waiting on Payment - Accounting Approved',isnull((select count(swaa.SettlementId) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and swaa.active =1 and status = 'a'),0),isnull((select sum(swaa.settlementfee + adjustedsettlementfee) from tblSettlements swaa with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swaa.MatterId and MatterStatusCodeId = 38 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swaa.created) = @year and month(swaa.created) = @month and swaa.active =1 and status = 'a'),0)
	--insert into @tblr select 11,'Waiting on Payment - Confirmation of Check Dispatch',isnull((select count(swccd.SettlementId) from tblSettlements swccd with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swccd.MatterId and MatterStatusCodeId = 36 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swccd.created) = @year and month(swccd.created) = @month ),0),isnull((select sum(swccd.settlementfee + adjustedsettlementfee) from tblSettlements swccd with(nolock) inner join tblMatter m  with(nolock) on m.MatterId = swccd.MatterId and MatterStatusCodeId = 36 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId and IsMatterActive = 1 where year(swccd.created) = @year and month(swccd.created) = @month ),0)
	insert into @tblr select 12,'Completed - SIF Attached',isnull((select count(scp.SettlementId) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId where year(scp.created) = @year and month(scp.created) = @month and scp.active =1 and status = 'a'),0),isnull((select sum(scp.settlementfee + adjustedsettlementfee) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId where year(scp.created) = @year and month(scp.created) = @month and m.matterid is not null and scp.active =1 and status = 'a') ,0)
	insert into @tblr select 13,'Completed - Client Approved',isnull((select count(scp.SettlementId) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(scp.created) = @year and month(scp.created) = @month and scp.active =1 and status = 'a'),0),isnull((select sum(scp.settlementfee + adjustedsettlementfee) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId inner join tblSettlementClientApproval sc  with(nolock) on m.MatterID = sc.MatterId and ApprovalType in ('Written','Verbal','LEXXSIGN') where year(scp.created) = @year and month(scp.created) = @month and m.matterid is not null and scp.active =1 and status = 'a' ),0)
	insert into @tblr select 14,'Completed - Accounting Approved',isnull((select count(*)from tblAccount_PaymentProcessing where deliverymethod in ('C','P','E') and isapproved = 1 and ischeckprinted = 1 and  year(created) = @year and month(created) = @month),0),isnull((select sum(checkamount)from tblAccount_PaymentProcessing where deliverymethod in ('C','P','E') and isapproved = 1 and ischeckprinted = 1 and  year(created) = @year and month(created) = @month),0)
	insert into @tblr select 15,'Completed - Payment Confirmed',isnull((select count(scp.SettlementId) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId where year(scp.created) = @year and month(scp.created) = @month and scp.active =1 and status = 'a'),0),isnull((select sum(scp.settlementfee + adjustedsettlementfee) from tblSettlements scp inner join tblMatter m  with(nolock) on m.MatterId = scp.MatterId and MatterStatusCodeId = 37 inner join tblMatterSTatus ms  with(nolock) on ms.MatterStatusId = m.MatterStatusId where year(scp.created) = @year and month(scp.created) = @month and scp.active =1 and status = 'a'),0)

	select * from @tblr order by rOrder,taskname
END

GO


GRANT EXEC ON stp_settlementimport_reports_CountsByTaskName TO PUBLIC

GO

