/****** Object:  StoredProcedure [dbo].[stp_GetNumAccountOverThresholdForClient]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetNumAccountOverThresholdForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetNumAccountOverThresholdForClient]
	(
		@clientid int,
		@availableamount money,
		@mediationthreshold money
	)

as


declare @vAvailableAmount varchar(255)
set @vAvailableAmount=convert(varchar(255),@availableamount)

declare @vMediationThreshold varchar(255)
set @vMediationThreshold=convert(varchar(255),@mediationthreshold)

exec
(
	'select
		count(tblaccount.accountid)
	from
		tblaccount inner join
		tblcreditorinstance on tblaccount.currentcreditorinstanceid = tblcreditorinstance.creditorinstanceid
	where
		not amount = 0 and
		clientid = ' + @clientid + ' and
		(' + @vavailableamount + ' / amount) >= ' + @vmediationthreshold
)
GO
