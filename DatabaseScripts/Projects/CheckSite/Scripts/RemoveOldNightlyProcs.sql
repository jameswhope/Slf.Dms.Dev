 
 -- Removing procs no longer used for nightly processing
 

if exists (select * from sysobjects where name = 'stp_IssueCommBatch_P')
	drop procedure stp_IssueCommBatch_P
go

if exists (select * from sysobjects where name = 'stp_IssueCommBatch_S')
	drop procedure stp_IssueCommBatch_S
go


if exists (select * from sysobjects where name = 'stp_CollectACHCommission_P')
	drop procedure stp_CollectACHCommission_P
go

if exists (select * from sysobjects where name = 'stp_CollectACHCommission_S')
	drop procedure stp_CollectACHCommission_S
go


if exists (select * from sysobjects where name = 'stp_CollectACHDeposits_P')
	drop procedure stp_CollectACHDeposits_P
go

if exists (select * from sysobjects where name = 'stp_CollectACHDeposits_S')
	drop procedure stp_CollectACHDeposits_S
go


if exists (select * from sysobjects where name = 'stp_CollectAdHocACHDeposits_P')
	drop procedure stp_CollectAdHocACHDeposits_P
go

if exists (select * from sysobjects where name = 'stp_CollectAdHocACHDeposits_S')
	drop procedure stp_CollectAdHocACHDeposits_S
go


if exists (select * from sysobjects where name = 'stp_PayCommissionRec_P')
	drop procedure stp_PayCommissionRec_P
go

if exists (select * from sysobjects where name = 'stp_PayCommissionRec_S')
	drop procedure stp_PayCommissionRec_S
go