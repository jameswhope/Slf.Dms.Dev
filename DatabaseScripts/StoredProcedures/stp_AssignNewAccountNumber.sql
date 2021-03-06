/****** Object:  StoredProcedure [dbo].[stp_AssignNewAccountNumber]    Script Date: 11/19/2007 15:26:54 ******/
DROP PROCEDURE [dbo].[stp_AssignNewAccountNumber]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AssignNewAccountNumber]
(
	@clientId int
)

AS

SET NOCOUNT ON

declare @newAccountNumber varchar(50)
declare @oldAccountNumber varchar(50)

set @oldAccountNumber = (select accountnumber from tblclient where clientid=@clientid)
exec @newAccountNumber = stp_GetAccountNumber

update 
	tblclient 
set 
	accountnumber = @newAccountNumber,
	trustid = (select top 1 trustid from tbltrust where [default] = 1)
where 
	clientid=@clientid

select 
	ClientID,
	accountNumber as NewAccountNumber,
	@oldaccountnumber as OldAccountNumber
from 
	tblclient 
where 
	clientid=@clientid
	
-- checking if this proc gets used
-- only place can find is in Clients\client\finances\sda\default.aspx.vb
insert _AssignNewAcctNumAudit (ClientID,OldAccountNumber,NewAccountNumber)
values (@clientid,@oldaccountnumber,@newAccountNumber)
	
GO
