/****** Object:  StoredProcedure [dbo].[stp_GetAccountNumber_Fuzz]    Script Date: 11/19/2007 15:27:03 ******/
DROP PROCEDURE [dbo].[stp_GetAccountNumber_Fuzz]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_GetAccountNumber_Fuzz]
as

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

begin tran myTran

declare @accountnum bigint
declare @newaccountnum bigint

select @accountnum = cast([Value] as bigint)
from tblProperty
where PropertyID = 29

set @newaccountnum = @accountnum + 1

while ((select count(ClientID) from tblClient where AccountNumber in (@newaccountnum, @accountnum)) > 0)
begin
	set @newaccountnum = @newaccountnum + 1
	set @accountnum = @accountnum + 1
end

update tblProperty
set [Value] = cast(@newaccountnum as varchar(15)),
	LastModified = getdate() 
where PropertyID = 29

SELECT @accountnum

commit tran myTran
GO
