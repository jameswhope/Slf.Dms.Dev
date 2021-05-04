/****** Object:  StoredProcedure [dbo].[stp_DeleteRegister]    Script Date: 11/19/2007 15:27:00 ******/
DROP PROCEDURE [dbo].[stp_DeleteRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DeleteRegister]
	(
		@registerid int,
		@docleanup bit = 1
	)

as


-- discretionary variables
declare @registerpaymentid int
declare @registerpaymentdepositid int
declare @clientid int


-- find client now, before the register is deleted
select
	@clientid = clientid
from
	tblregister
where
	registerid = @registerid


declare @ids table
	(
		registerpaymentid int not null
	)

-- get all register payments paid for this register as a fee
insert into
	@ids
select
	registerpaymentid
from
	tblregisterpayment
where
	feeregisterid = @registerid


-- get all register payments through any payments this register has paid
insert into
	@ids
select
	registerpaymentid
from
	tblregisterpaymentdeposit
where
	depositregisterid = @registerid


-- delete any register payments
declare cursor_a cursor local for select registerpaymentid from @ids

open cursor_a

fetch next from cursor_a into @registerpaymentid
while @@fetch_status = 0
	begin

		exec stp_DeleteRegisterPayment @registerpaymentid, 0

		fetch next from cursor_a into @registerpaymentid
	end
close cursor_a
deallocate cursor_a


-- delete all attachment relationships
exec stp_DeleteRelation 4, @registerid



-- delete the register and any adjustments to this register
delete
from
	tblregister
where
	registerid = @registerid or
	adjustedregisterid = @registerid
	
	
	
-- if an associated transaction was not sent, its no longer needed so delete it
-- applies to checksite clients only 
delete
from 
	tblnacharegister2
where
	nachafileid = -1
	and registerid = @registerid
	and registerpaymentid is null
	and flow = 'debit'
	
-- or if the transaction was already sent, credit the shadow store
insert tblNachaRegister2
	(NachaFileId, [Name], Amount, IsPersonal, CompanyID, ShadowStoreId, ClientID, TrustId, RegisterID, RegisterPaymentID, Created, Flow)
select 
	-1, [Name], Amount, IsPersonal, CompanyID, ShadowStoreId, ClientID, TrustId, RegisterID, -1, getdate(), 'credit'
from 
	tblnacharegister2
where
	nachafileid > 0
	and registerid = @registerid
	and registerpaymentid is null
	and flow = 'debit'
	


if @docleanup = 1
	begin
		exec stp_DoRegisterCleanup @clientid
	end
GO
 