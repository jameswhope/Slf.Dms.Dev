IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DoRegisterPaymentClear')
	BEGIN
		DROP  Procedure  stp_DoRegisterPaymentClear
	END

GO

CREATE procedure stp_DoRegisterPaymentClear
	(
		@registerPaymentid int,
		@by int,
		@when datetime = null
	)

as
begin

if @when is null
	begin
		set @when = getdate()
	end

----------------------------------------------------
-- LOGIC FOR CLEARING A REGISTER
-- (1) Mark register as clear by updating fields
--     (a) Set clear = @when value passed in
--     (b) Set clearby = @by value passed in
----------------------------------------------------


-- (1) clear register
update
	tblregisterpayment
set
	clear = @when,
	clearby = @by
where
	registerpaymentid = @registerpaymentid


end
GO
