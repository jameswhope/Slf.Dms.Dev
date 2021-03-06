/****** Object:  StoredProcedure [dbo].[stp_GetNewUniqueID]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetNewUniqueID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_GetNewUniqueID]
as

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

begin tran myTran

declare @newid bigint

select @newid = cast([Value] as bigint) + 1
from tblProperty
where [Name] = 'NewUniqueID'

update tblProperty
set [Value] = cast(@newid as varchar(15)),
	LastModified = getdate()
where [Name] = 'NewUniqueID'

select @newid

commit tran myTran

return @newid
GO
