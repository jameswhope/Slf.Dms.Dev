/****** Object:  StoredProcedure [dbo].[stp_DoRegisterHold]    Script Date: 11/19/2007 15:27:01 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterHold]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterHold]
	(
		@registerid int,
		@by int,
		@when datetime = null,
		@docleanup bit = 1
	)

as

if @when is null
	begin
		set @when = getdate()
	end

----------------------------------------------------
-- LOGIC FOR HOLDING A REGISTER
-- (1) Mark register as held by updating fields
--     (a) Set hold = @when value passed in
--     (b) Set holdby = @by value passed in
----------------------------------------------------


-- (1) hold register
update
	tblregister
set
	hold = @when,
	holdby = @by
where
	registerid = @registerid


if @docleanup = 1
	begin
		-- find and get the client on this register
		declare @clientid int

		select
			@clientid = clientid
		from
			tblregister
		where
			registerid = @registerid

		exec stp_DoRegisterCleanup @clientid
	end
GO
