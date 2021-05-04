IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'wstp_UpdateWChargeBacks')
	BEGIN
		DROP  Procedure  wstp_UpdateWChargeBacks
	END

GO

CREATE Procedure wstp_UpdateWChargeBacks
AS
/*
This is the update/insert process for tblChargeBacks in the
LexxiomWarehouse database
Created by Jim Hope 12/08/2008
Updated by Jim Hope 06/30/2009
*/
declare @BatchDate smalldatetime
declare @AgencyID int
declare @AgencyName varchar(150)
declare @CommRecID int
declare @CommissionRecipient varchar(150)
declare @CompanyID int
declare @Company varchar(150)
declare @ClientName varchar(150)
declare @RegisterID int
declare @EntryTypeID int
declare @EntryType varchar(50)
declare @FeeAmount money
declare @PaymentAmount money
declare @InitialDraft bit
declare @StateChanged smalldatetime
declare @State varchar(50)
declare @BouncedReason varchar(200)
declare @AccountStatusID int
declare @AccountStatus varchar(150)
declare @AccountBalance money
declare @AccountNumber varchar(150)
declare @Creditor varchar(150)
declare @CommBatchID int
declare @CommScenID int
declare @CommissionPaid money
declare @RowAdded datetime

declare @Yesterday smalldatetime
declare @NewDay varchar(20)
declare @ClientID int
declare @BatchID int
declare @bounce smalldatetime
declare @void smalldatetime
declare @Exists int

set @Exists = -1

set @yesterday = dateadd(day, -1, getdate())
set @NewDay = cast(datepart(month, @yesterday) as varchar(2)) + '/' + cast(datepart(day, @yesterday) as varchar(2)) + '/' + cast(datepart(year, @yesterday) as varchar(4)) + ' 00:00:000'
set @yesterday = @newday

--Get the client ID, bounced or void for the cursor
declare c_ClientID cursor for
select c.clientid, b.commbatchid, r.Bounce, r.void
				from  [DMS].[dbo].[tblcommchargeback] cb
				join  [DMS].[dbo].[tblregisterpayment] rp on rp.registerpaymentid = cb.registerpaymentid
				join  [DMS].[dbo].[tblregister] r on r.registerid = rp.feeregisterid
				join  [DMS].[dbo].[tblentrytype] e on e.entrytypeid = r.entrytypeid
				join  [DMS].[dbo].[tblclient] c on c.clientid = r.clientid
				join  [DMS].[dbo].[tblperson] p on p.personid = c.primarypersonid
				join  [DMS].[dbo].[tblcommbatch] b on b.commbatchid = cb.commbatchid 
				join  [DMS].[dbo].[tblcommstruct] cs on cs.commstructid = cb.commstructid
				join  [DMS].[dbo].[tblcommrec] cr on cr.commrecid = cs.commrecid
				join  [DMS].[dbo].[tblcompany] comp on comp.companyid = cs.companyid
				join  [DMS].[dbo].[tblcommscen] s on s.commscenid = cs.commscenid
				join  [DMS].[dbo].[tblagency] a on a.agencyid = s.agencyid
				left join  [DMS].[dbo].[tblbouncedreasons] br on br.bouncedid = r.bouncedreason
				left join  [DMS].[dbo].[tblaccount] acct on acct.accountid = r.accountid
				left join  [DMS].[dbo].[tblcreditorinstance] ci on ci.creditorinstanceid = acct.currentcreditorinstanceid
				left join  [DMS].[dbo].[tblcreditor] cred on cred.creditorid = ci.creditorid
				left join  [DMS].[dbo].[tblaccountstatus] stat on stat.accountstatusid = acct.accountstatusid
				where cb.ChargebackDate >= @yesterday

/*loop through the clients and update the ones in the table
	already and insert ones that are not in the table*/
open c_ClientID

fetch next from c_ClientID into @ClientID, @BatchID, @bounce, @void
while @@fetch_status = 0
	--Insert/Update routines
	begin
		 select @Exists = CommBatchID from [LexxiomWarehouse].[dbo].[tblChargeBacks] where CommBatchID = @BatchID
			if @Exists > 1
				begin
					if @bounce > '01/01/1900'
						begin
							update [LexxiomWarehouse].[dbo].[tblChargeBacks] set [StateChanged] = @bounce, [State] = 'Bounced' where CommBatchID = @BatchID
						end
					if @Void > '01/01/1900'
						begin
							update  [LexxiomWarehouse].[dbo].[tblChargeBacks] set [StateChanged] = @void, [State] = 'Void' where CommBatchID = @BatchID
						end
			end
			if @Exists <= 0 
				begin
					select @BatchDate = convert(varchar,b.batchdate,101), 
					@AgencyID = a.agencyid, 
					@AgencyName  =a.name,
					@CommRecID = cr.commrecid, 
					@CommissionRecipient = cr.display, 
					@CompanyID = comp.companyid, 
					@Company = comp.name,
					@ClientName = p.firstname + ' ' + p.lastname,
					@RegisterID = r.registerid, 
					@EntrytypeID = r.entrytypeid, 
					@EntryType = e.name,
					@FeeAmount = r.amount, 
					@PaymentAmount = rp.amount, 
					@InitialDraft = r.initialDraftYN, 
					@StateChanged = case When r.void is not null then r.void else (case when  r.bounce is not null then r.bounce end) end,
					@State = case
						when r.void is not null then 'Void'
						when r.bounce is not null then 'Bounced'
						else 
							(case 
								when rp.bounced is not null then 'Bounced' 
							    when rp.voided is not null then 'Void'
							 end)
					end,
					@BouncedReason = r.bouncedreason,  
					@AccountStatusID = stat.accountstatusid, 
					@AccountStatus = stat.description, 
					@AccountBalance = ci.amount, 
					@AccountNumber = ci.accountnumber, 
					@Creditor = cred.name,
					@CommbatchID = b.commbatchid, 
					@CommScenID = cs.commscenid, 
					@CommissionPaid = -cb.amount, 
					@RowAdded = getdate()
					from  [DMS].[dbo].[tblcommchargeback] cb
					join  [DMS].[dbo].[tblregisterpayment] rp on rp.registerpaymentid = cb.registerpaymentid
					join  [DMS].[dbo].[tblregister] r on r.registerid = rp.feeregisterid
					join  [DMS].[dbo].[tblentrytype] e on e.entrytypeid = r.entrytypeid
					join  [DMS].[dbo].[tblclient] c on c.clientid = r.clientid
					join  [DMS].[dbo].[tblperson] p on p.personid = c.primarypersonid
					join  [DMS].[dbo].[tblcommbatch] b on b.commbatchid = cb.commbatchid 
					join  [DMS].[dbo].[tblcommstruct] cs on cs.commstructid = cb.commstructid
					join  [DMS].[dbo].[tblcommrec] cr on cr.commrecid = cs.commrecid
					join  [DMS].[dbo].[tblcompany] comp on comp.companyid = cs.companyid
					join  [DMS].[dbo].[tblcommscen] s on s.commscenid = cs.commscenid
					join  [DMS].[dbo].[tblagency] a on a.agencyid = s.agencyid
					left join  [DMS].[dbo].[tblbouncedreasons] br on br.bouncedid = r.bouncedreason
					left join  [DMS].[dbo].[tblaccount] acct on acct.accountid = r.accountid
					left join  [DMS].[dbo].[tblcreditorinstance] ci on ci.creditorinstanceid = acct.currentcreditorinstanceid
					left join  [DMS].[dbo].[tblcreditor] cred on cred.creditorid = ci.creditorid
					left join  [DMS].[dbo].[tblaccountstatus] stat on stat.accountstatusid = acct.accountstatusid
					where cb.ChargebackDate >= @yesterday
					
					insert into [LexxiomWarehouse].[dbo].[tblchargebacks](
						BatchDate,
						AgencyID,
						AgencyName,
						CommRecID,
						CommissionRecipient,
						CompanyID,
						Company,
						ClientName,
						RegisterID,
						EntryTypeID,
						FeeAmount,
						PaymentAmount,
						InitialDraftYN,
						StateChanged,
						[State],
						BouncedReason,
						AccountStatusID,
						AccountStatus,
						AccountBalance,
						AccountNumber,
						Creditor,
						CommBatchID,
						CommScenID,
						ComissionPaid,
						RowAdded)
					VALUES(
						@BatchDate, 
						@AgencyID,
						@AgencyName, 
						@CommRecID,
						@CommissionRecipient, 
						@CompanyID, 
						@Company, 
						@ClientName, 
						@RegisterID, 
						@EntryTypeID, 
						@FeeAmount,
						@PaymentAmount,  
						@InitialDraft,
						@StateChanged, 
						@State, 
						@BouncedReason, 
						@AccountStatusID,
						@AccountStatus, 
						@AccountBalance, 
						@AccountNumber, 
						@Creditor, 
						@CommBatchID, 
						@CommScenID, 
						@CommissionPaid, 
						@RowAdded) 
				end
		set @Exists = -1
fetch next from c_ClientID into @ClientID, @BatchID, @bounce, @void
	end

close c_ClientID
deallocate c_ClientID 
END

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

