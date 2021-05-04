IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_StipulationLetterLogInsert')
	BEGIN
		DROP  Procedure  stp_StipulationLetterLogInsert
	END

GO

CREATE Procedure stp_StipulationLetterLogInsert
@SettlementId int,
@DocPath varchar(max),
@MethodUsed varchar(100),
@SentTo varchar(255),
@UserId int
AS
Begin

Insert Into tblStipulationLetterLog(datesent,sentby,settlementid,docfile,sendmethod,sentto)
values(GetDate(),@UserId,@SettlementId,@DocPath,@MethodUsed,@SentTo)
	
Select scope_identity()
End
GO
 
