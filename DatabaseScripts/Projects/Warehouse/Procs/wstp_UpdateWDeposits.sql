IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'wstp_UpdateWDeposits')
	BEGIN
		DROP  Procedure  wstp_UpdateWDeposits
	END

GO

CREATE Procedure wstp_UpdateWDeposits

AS
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		    Jim Hope
-- Modified date: 07/01/2009
-- Description:	    Warehouse update of Deposits
-- =============================================
CREATE PROCEDURE wstp_UpdateWDeposits 
	AS
BEGIN

	SET NOCOUNT ON;

/*
This is the update/insert process for tblDeposits in the
LexxiomWarehouse database
Created by Jim Hope 12/05/2008
Updated by Jim Hope 06/30/2009
*/

declare @RegisterID int
declare @CompanyID int
declare @Company varchar(150)
declare @AgencyID int
declare @Agency varchar(150)
declare @ClientName varchar(250)
declare @DepositDate datetime
declare @Initialdraftdate datetime
declare @InitialDraftYN bit
declare @InitialDraftAmount money
declare @StateChanged datetime
declare @State varchar(50)
declare @BounceReason varchar(200)
declare @EntryTypeID int
declare @EntryType varchar(150)
declare @DepositAmount money
declare @RowAdded datetime
declare @Yesterday smalldatetime
declare @NewDay varchar(20)
declare @ClientID int
declare @bounce smalldatetime
declare @void smalldatetime
declare @Exists int

set @Exists = -1
set @yesterday = dateadd(day, -1, getdate())
set @NewDay = cast(datepart(month, @yesterday) as varchar(2)) + '/' + cast(datepart(day, @yesterday) as varchar(2)) + '/' + cast(datepart(year, @yesterday) as varchar(4)) + ' 00:00:000'
set @yesterday = @newday

--Get the client ID, bounced or void for the cursor
declare c_ClientID cursor for
select r.clientid, r.bounce, r.void
from [DMS].[dbo].[tblregister] as r
join [DMS].[dbo].[tblclient] as c on c.clientid = r.clientid
join [DMS].[dbo].[tblagency] as a on a.agencyid = c.agencyid
join [DMS].[dbo].[tblcompany] as comp on comp.companyid = c.companyid
join [DMS].[dbo].[tblentrytype] as e on e.entrytypeid = r.entrytypeid
join [DMS].[dbo].[tblcompany] as co on co.companyid = c.companyid
join [DMS].[dbo].[tblperson] as p on p.clientid = c.clientid
      and p.relationship = 'Prime'
left join [DMS].[dbo].[tblbouncedreasons] as br on br.bouncedid = r.bouncedreason
where (r.entrytypeid in (3, 20, 27, 29) 
or r.entrytypeid between 7 and 15)
and (r.transactiondate = @yesterday
or r.Bounce >= @yesterday
or r.void >= @yesterday)

--loop through the clients and update the ones in the table
--already and insert ones that are not in the table
open c_ClientID

fetch next from c_ClientID into @ClientID, @bounce, @void
while @@fetch_status = 0
	--Insert/Update routines
	begin
		 select @Exists = clientid from [LexxiomWarehouse].[dbo].[tbldeposits] where clientid = @ClientID
			if @Exists > 1
				begin
					if @bounce > '01/01/1900'
						begin
							update [LexxiomWarehouse].[dbo].[tblDeposits] set [StateChanged] = @bounce, [State] = 'Bounced' where clientid = @ClientID
						end
					if @Void > '01/01/1900'
						begin
							update  [LexxiomWarehouse].[dbo].[tblDeposits] set [StateChanged] = @void, [State] = 'Void' where clientid = @ClientID
						end
			end
			if @Exists <= 0 
				begin
					select @RegisterID = r.registerid,
					@ClientID = c.clientid,
					@CompanyID = c.companyid,
					@Company = comp.name,
					@AgencyID = a.agencyid,
					@Agency = a.name,
					@ClientName = p.firstname + ' ' + p.lastname,
					@DepositDate = convert(varchar, r.transactiondate,101),
					@InitialDraftDate = c.initialdraftdate,
					@InitialDraftYN = r.initialdraftyn,
					@InitialDraftAmount = c.initialdraftamount,
					@StateChanged = case When r.void is not null then r.void else (case when  r.bounce is not null then r.bounce end) end,
					@State = case when r.void is not null then 'Void' else (case when r.bounce is not null then 'Bounced' end) end,
					@BounceReason = br.bounceddescription,
					@EntryTypeID = r.entrytypeid,
					@EntryType = e.name,
					@DepositAmount = r.amount,
					@RowAdded = getdate()
					from [DMS].[dbo].[tblregister] r
					join [DMS].[dbo].[tblclient] c on c.clientid = r.clientid
					join [DMS].[dbo].[tblagency] a on a.agencyid = c.agencyid
					join [DMS].[dbo].[tblcompany] comp on comp.companyid = c.companyid
					join [DMS].[dbo].[tblentrytype] e on e.entrytypeid = r.entrytypeid
					join [DMS].[dbo].[tblcompany] co on co.companyid = c.companyid
					join [DMS].[dbo].[tblperson] p on p.clientid = c.clientid
						  and p.relationship = 'Prime'
					left join [DMS].[dbo].[tblbouncedreasons] br on br.bouncedid = r.bouncedreason
					where (r.entrytypeid in (3, 20, 27, 29) 
					or r.entrytypeid between 7 and 15)
					and (r.transactiondate = @yesterday
					or r.Bounce >= @yesterday
					or r.void >= @yesterday)

					Insert into [LexxiomWarehouse].[dbo].[tblDeposits](
						RegisterID,
						ClientID,
						CompanyID,
						Company,
						AgencyID,
						Agency,
						ClientName,
						DepositDate,
						InitialDraftDate,
						InitialDraftYN,
						InitialDraftAmount,
						StateChanged,
						[State],
						BounceReason,
						EntryTypeID,
						EntryType,
						DepositAmount,
						RowAdded)
						VALUES(
						@RegisterID, 
						@ClientID,
						@CompanyID, 
						@Company,
						@AgencyID, 
						@Agency,
						@ClientName,
						@DepositDate,
						@Initialdraftdate,
						@InitialDraftYN,
						@InitialDraftAmount, 
						@StateChanged,
						@State,
						@BounceReason,
						@EntryTypeID, 
						@EntryType,
						@DepositAmount, 
						@RowAdded)
				end
		set @Exists = -1
fetch next from c_ClientID into @ClientID, @bounce, @void
	end
close c_ClientID
deallocate c_ClientID
END

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

