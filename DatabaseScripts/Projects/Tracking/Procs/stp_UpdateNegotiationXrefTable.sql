IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateNegotiationXrefTable')
	BEGIN
		DROP  Procedure  stp_UpdateNegotiationXrefTable
	END
GO

CREATE Procedure [dbo].[stp_UpdateNegotiationXrefTable]
(
	@EntityID int = null,
	@Hours int = 3
)
as
begin

-- Using same procs that Assign Criteria interface uses

-- Note: If the output of stp_NegotiationEntityFilterSelect or stp_NegotiationDashboardGetByID changes,
-- this procedure will fail until the declared temp tables are updated to match.

declare @FilterID int
declare @vtblFilterIDs table (FilterID int,[Description] varchar(200),FilterClause varchar(max),FilterText varchar(max),FilterType varchar(50),ParentFilterId int)
declare @vtblDashboard table (ClientID int,AccountID int,SSN varchar(20),ApplicantFullName varchar(200),ApplicantLastName varchar(100),ApplicantFirstName varchar(100),ApplicantState varchar(30),ApplicantCity varchar(50),ApplicantZipCode varchar(20),SDAAccount varchar(20),FundsAvailable money,OriginalCreditor varchar(100),CurrentCreditor varchar(100),CurrentCreditorState varchar(20),CurrentCreditorAccountNumber varchar(30),LeastDebtAmount money,CurrentAmount money,AccountStatus varchar(100),AccountStatusID int,AccountAge int,ClientAge int,LastSettled int,NextDepositDate varchar(20),NexDepositAmount money,LastOffer datetime,OfferDirection varchar(20))

set nocount on
set @hours = 3


-- only update if their last refresh was more than x hours ago
declare cur cursor for select NegotiationEntityID from tblNegotiationEntity where UserID is not null and Deleted = 0 and (@EntityID is null or @EntityID = NegotiationEntityID) and ParentNegotiationEntityID is not null and LastRefresh < dateadd(hh,-@hours,getdate())
open cur
fetch next from cur into @EntityID
while @@fetch_status = 0
	begin
		-- clear filter ids from previous entity
		delete from @vtblFilterIDs where 1=1

		-- clear entity's current assignments
		delete from tblAccountEntityXref where EntityID = @EntityID

		-- get entity's filter ids
		insert into @vtblFilterIDs
		exec stp_NegotiationEntityFilterSelect @EntityID, 'base'
		
		-- get entity's assignments by filter
		declare cur2 cursor for select FilterID from @vtblFilterIDs
		open cur2
		fetch next from cur2 into @FilterID
		while @@fetch_status = 0
			begin
				-- clear accounts ids from previous filter
				delete from @vtblDashboard where 1=1
		
				-- get account ids
				insert into @vtblDashboard
				exec stp_NegotiationDashboardGetByID @FilterID
				
				-- add assignments
				insert tblAccountEntityXref (AccountID,EntityID)
				select AccountID, @EntityID
				from @vtblDashboard
				
				-- get next filter
				fetch next from cur2 into @FilterID
			end
			
		close cur2
		deallocate cur2
		
		-- log when entity was refreshed
		update tblNegotiationEntity set LastRefresh = getdate() where NegotiationEntityID = @EntityID

		-- get next entity
		fetch next from cur into @EntityID
	end

close cur
deallocate cur


-- the root entity (Oscar) does not get assigned by the cursor
--if @EntityID is null begin
	if exists (select 1 from tblNegotiationEntity where UserID is not null and Deleted = 0 and ParentNegotiationEntityID is null and LastRefresh < dateadd(hh,-@hours,getdate())) begin	
		select @EntityID = NegotiationEntityID from tblNegotiationEntity where UserID is not null and Deleted = 0 and ParentNegotiationEntityID is null and LastRefresh < dateadd(hh,-@hours,getdate())
		
		delete from tblAccountEntityXref where EntityID = @EntityID

		insert tblAccountEntityXref (AccountID,EntityID) select distinct AccountID, @EntityID from tblAccountEntityXref
		
		update tblNegotiationEntity set LastRefresh = getdate() where NegotiationEntityID = @EntityID
	end
--end


set nocount off

end
go
