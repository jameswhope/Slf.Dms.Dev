/****** Object:  StoredProcedure [dbo].[stp_GetDocumentNumber]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetDocumentNumber]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_GetDocumentNumber]
as

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

begin tran myTran

declare @docnum bigint
declare @newdocnum bigint

select @docnum = cast([Value] as bigint)
from tblProperty
where [NAME] = 'CurrentDocumentNumber'

set @newdocnum = @docnum + 1

IF(@newdocnum > '9999999')
	BEGIN
		UPDATE tblProperty
		SET [Value] = char(ascii([Value]) + 1)
		WHERE [NAME] = 'DocumentNumberPrefix'
		
		SET @newdocnum = '0000001'
	END

update tblProperty
set [Value] = right(replicate('0',7)+ convert(varchar(10),@newdocnum),7) , LastModified = getdate()
where [NAME] = 'CurrentDocumentNumber'

select right(replicate('0',7)+ convert(varchar(10),@docnum),7)

commit tran myTran
GO
