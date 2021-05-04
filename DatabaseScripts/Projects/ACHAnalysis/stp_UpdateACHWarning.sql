IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ExcludeACHWarning')
	BEGIN
		DROP  Procedure  stp_ExcludeACHWarning
	END

GO

CREATE Procedure stp_ExcludeACHWarning
@ItemId int,
@ItemType varchar(50),
@IsMulti bit,
@Scheduled datetime,
@Exclude bit
AS
BEGIN
If @Exclude = 1
	Begin
		if Not Exists(select top 1 WarningId from tblACHWarning  Where ItemId = @ItemId and  ItemType = @ItemType and  MultiDeposit = @IsMulti and Scheduled = @Scheduled)
			Insert into tblACHWarning(ItemId, ItemType, MultiDeposit, Scheduled) Values(@ItemId, @ItemType, @IsMulti, @Scheduled)
	End
Else
	Delete From tblACHWarning
	Where ItemId = @ItemId and  ItemType = @ItemType and  MultiDeposit = @IsMulti and Scheduled = @Scheduled
END

GO


