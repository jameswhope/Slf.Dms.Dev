/****** Object:  StoredProcedure [dbo].[stp_PayChargebackAmount]    Script Date: 11/19/2007 15:27:25 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PayChargebackAmount')
BEGIN
	DROP  Procedure  [stp_PayChargebackAmount]
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayChargebackAmount]
	(
		@registerpaymentid int
	)

as

--------------------------------------------------------------------------------
-- LOGIC FOR PAYING CHARGEBACKS AMOUNTS
-- (1) insert all commpayids into chargeback table from tblcommpay where
--     register payment matches
--------------------------------------------------------------------------------

declare @body nvarchar(3000)
declare @subject nvarchar(100)
declare @username nvarchar(50)
declare @clientid int
declare @accountnumber nvarchar(10)

SELECT @username = SYSTEM_USER

SELECT
	@clientid = c.ClientID,
	@accountnumber = c.AccountNumber
FROM
	tblRegisterPayment as rp inner join
	tblRegister as r on r.RegisterID = rp.FeeRegisterID inner join
	tblClient as c on c.ClientID = r.ClientID
WHERE
	rp.RegisterPaymentID = @registerpaymentid


if not EXISTS(SELECT * FROM tblCommChargeback WHERE RegisterPaymentID = @registerpaymentid)
begin
	insert into
		tblcommchargeback
		(
			commpayid,
			chargebackdate,
			registerpaymentid,
			commstructid,
			[percent],
			amount
		)
	select
		commpayid,
		getdate(),
		registerpaymentid,
		commstructid,
		[percent],
		amount
	from
		tblcommpay
	where
		registerpaymentid = @registerpaymentid

	set @subject = 'Chargeback Issued'
	set @body = 'A chargeback on payment ' + cast(@registerpaymentid as nvarchar(50)) + ' was issued for client ' + @accountnumber + ' (' + cast(@clientid as nvarchar(10)) + ') at ' + cast(getdate() as nvarchar(11)) + ' by ' + @username + '.'
end
else
begin
	set @subject = 'Duplicate Chargeback Attemped'
	set @body = 'A duplicate chargeback on payment ' + cast(@registerpaymentid as nvarchar(50)) + ' was attemped for client ' + @accountnumber + ' (' + cast(@clientid as nvarchar(10)) + ') at ' + cast(getdate() as nvarchar(11)) + ' by ' + @username + '.'
end

exec msdb.dbo.sp_send_dbmail @recipients = 'ctanner@dmsi.local; cnott@dmsi.local', @body = @body, @subject = @subject