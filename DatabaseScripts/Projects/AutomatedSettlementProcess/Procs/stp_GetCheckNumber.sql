IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCheckNumber')
	BEGIN
		DROP  Procedure  stp_GetCheckNumber
	END

GO

CREATE Procedure [dbo].[stp_GetCheckNumber]
(
@ClientId INT,
@CheckNumber VARCHAR(10) OUTPUT
)
as

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

begin tran myTran

declare @checknum bigint
declare @newchecknum bigint, @FirmId int, @PropName varchar(30);

select @FirmId = (SELECT CompanyId FROM tblClient WHERE ClientId = @ClientId);

SET @PropName = (CASE 
					WHEN @FirmId = 1 THEN 'SeidamanCheckNumber'
					WHEN @FirmId = 2 THEN 'PalmerCheckNumber'
					ELSE 'BOFACheckNumber'
				 END);

select @checknum = cast([Value] as bigint)
from tblProperty
where [NAME] = @PropName

set @newchecknum = @checknum + 1

update tblProperty
set [Value] = right(replicate('0',7)+ convert(varchar(10),@newchecknum),7) , LastModified = getdate()
where [NAME] = @PropName

SET @CheckNumber = (select right(replicate('0',7)+ convert(varchar(10),@checknum),7))

commit tran myTran
GO


GRANT EXEC ON stp_GetCheckNumber TO PUBLIC

GO


