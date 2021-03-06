/****** Object:  StoredProcedure [dbo].[stp_Merge2PctFee]    Script Date: 11/19/2007 15:27:24 ******/
DROP PROCEDURE [dbo].[stp_Merge2PctFee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 6/29/2007
-- Description:	Merge 2% fee to Retainer
-- =============================================
CREATE PROCEDURE [dbo].[stp_Merge2PctFee] 
	-- Add the parameters for the stored procedure here
	@date1 smalldatetime, 
	@date2 smalldatetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @RFee money
declare @WFee money
declare @RPmt money
declare @WPmt money
declare @PmtCount int
declare @AccountNo int
declare @ClientID int
declare @RegisterID int
declare @Name varchar(50)
declare @Amount money
declare @AccountID int
declare @RegAcctID int
declare @EntryTypeID int
declare @AdjRegEntryTypeID int
declare @SplitPmt money
--declare @date1 smalldatetime --**** used for testing
--declare @date2 smalldatetime --**** used for testing

declare @Retainers table
(
ClientID int,
RegisterID int,
TransactionDate smalldatetime,
[Amount] money,
[Description] varchar(50),
Creditor varchar(50),
EntryTypeID int,
AccountID int,
AdjRegAcctID int
)

declare @Payments table
(
ClientID int,
RegisterID int,
TransactionDate smalldatetime,
[Amount] money,
[Description] varchar(50),
Creditor varchar(50),
EntryTypeID int,
AccountID int,
AdjRegAcctID int,
AdjRegEntryTypeID int
)

insert @Retainers

select 
ClientID, 
RegisterID, 
TransactionDate, 
[Amount],
EntryTypeName, 
AdjRegAcctCreditorName,
EntryTypeID,
AccountID,
AdjRegAcctID 
from tblStatementResults 
where entrytypeid = 2 or EntryTypeID = 42 
and transactiondate >= @date1
and transactiondate <= @date2
order by TransactionDate

insert @Payments

select 
ClientID, 
RegisterID, 
TransactionDate, 
[Amount],
EntryTypeName, 
AdjRegAcctCreditorName,
EntryTypeID,
AccountID,
AdjRegAcctID,
AdjRegEntryTypeID 
from tblStatementResults 
where entrytypeid = -1
and (AdjRegEntryTypeID = 42 or AdjRegEntryTypeID = 2) 
and transactiondate >= @date1
and transactiondate <= @date2
order by TransactionDate

declare BigLoop_Cursor cursor for
select 
AccountID, count(*) as 'Records'
from @Retainers
where AccountID is not null
group by accountid
having count(*) > 1
order by AccountID

open BigLoop_Cursor

fetch next from BigLoop_Cursor 
into @AccountID, @Name
while @@fetch_status = 0

begin
	--Payments ***************************
	declare PaymentLoop_cursor cursor for
	select 
	ClientID,
	RegisterID,
	[Amount],
	AccountID,
	AdjRegAcctID,
	EntryTypeID,
	AdjRegEntryTypeID
	from @Payments
	order by AccountID

	open PaymentLoop_Cursor
	fetch next from PaymentLoop_Cursor
	into @ClientID, @RegisterID, @Amount, @AccountID, @RegAcctID, @EntryTypeID, @AdjRegEntryTypeID
	while @@fetch_Status = 0
	begin
		select @WPmt = Amount from @Payments where AdjRegAcctID = @RegAcctID and entrytypeid = -1 and AdjRegEntryTypeID = 42
		--Payments
		IF @WPmt is not null
			begin
				delete from tblStatementResults where adjregacctid = @RegAcctID and adjregentrytypeid = 42
				select @RPmt = Amount from @Payments where AdjRegAcctID = @RegAcctID and AdjRegEntryTypeID = 2
				select @PmtCount = count(Amount) from @Payments where AdjRegAcctID = @RegAcctID and EntrytypeID = -1
				
				if @PmtCount > 0
					begin

						set @SplitPmt = (@WPmt/@PmtCount)

						update tblStatementResults set Amount = Amount + @SplitPmt where adjRegAcctID = @RegAcctID and EntryTypeID = -1

					end

				set @RPmt = null
				set @WPmt = null
			end	
		fetch next from PaymentLoop_Cursor 
		into @ClientID, @RegisterID, @Amount, @AccountID, @RegAcctID, @EntryTypeID, @AdjRegEntryTypeID
	end
	
	close PaymentLoop_Cursor
	deallocate PaymentLoop_Cursor
fetch next from BigLoop_Cursor 
into @AccountID, @Name
end
close BigLoop_Cursor
deallocate BigLoop_Cursor

--Retainers

declare BigLoop2_Cursor cursor for
select 
AccountID, count(*) as 'Records'
from @Retainers
where AccountID is not null
and EntryTypeID = 42
group by accountid
having count(*) > 0
order by AccountID

open BigLoop2_Cursor

fetch next from BigLoop2_Cursor 
into @AccountID, @Name
while @@fetch_status = 0
begin
	--Retainer fee **********************
	declare RetainerLoop_cursor cursor for
	select 
	ClientID,
	RegisterID,
	[Amount],
	AccountID,
	AdjRegAcctID,
	EntryTypeID
	from @Retainers
	where AccountID = @AccountID
	order by AccountID

	open RetainerLoop_Cursor
	fetch next from RetainerLoop_Cursor
	into @ClientID, @RegisterID, @Amount, @AccountID, @RegAcctID, @EntryTypeID

	while @@fetch_Status = 0
		begin
			select @WFee = Amount from @Retainers where AccountID = @AccountID and EntryTypeID = 42

			if @WFee is not null  
				begin
					select @RFee = Amount from @Retainers where AccountID = @AccountID and EntryTypeID = 2
					
					update tblStatementResults set Amount = (@WFee +  @RFee) where AccountID = @AccountID and EntryTypeID = 2
					
					set @RFee = null
					set @WFee = null

					delete from tblStatementResults where AccountID = @AccountID and EntryTypeID = 42
				end

	fetch next from RetainerLoop_Cursor 
	into @ClientID, @RegisterID, @Amount, @AccountID, @RegAcctID, @EntryTypeID
		end
	close RetainerLoop_Cursor
	deallocate RetainerLoop_Cursor

fetch next from BigLoop2_Cursor 
into @AccountID, @Name
end
close BigLoop2_Cursor
deallocate BigLoop2_Cursor
END
GO
