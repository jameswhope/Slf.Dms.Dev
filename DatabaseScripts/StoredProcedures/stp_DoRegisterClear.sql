/****** Object:  StoredProcedure [dbo].[stp_DoRegisterClear]    Script Date: 11/19/2007 15:27:01 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterClear]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterClear]
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
-- LOGIC FOR CLEARING A REGISTER
-- (1) Mark register as clear by updating fields
--     (a) Set clear = @when value passed in
--     (b) Set clearby = @by value passed in
----------------------------------------------------


-- (1) clear register
update
	tblregister
set
	clear = @when,
	clearby = @by
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
