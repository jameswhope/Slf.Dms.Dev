/****** Object:  StoredProcedure [dbo].[stp_GetStatsRegisterForClient]    Script Date: 11/19/2007 15:27:16 ******/
DROP PROCEDURE [dbo].[stp_GetStatsRegisterForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetStatsRegisterForClient]
	(
		@clientid int
	)

as

-- discretionary variables
declare @numdebits int
declare @sumdebits money
declare @numcredits int
declare @sumcredits money

select
	@numdebits = count(registerid),
	@sumdebits = sum(abs(amount))
from
	tblregister
where
	clientid = @clientid and
	amount < 0

select
	@numcredits = count(registerid),
	@sumcredits = sum(abs(amount))
from
	tblregister
where
	clientid = @clientid and
	amount > 0

select @numdebits as numdebits, @sumdebits as sumdebits, @numcredits as numcredits, @sumcredits as sumcredits
GO
