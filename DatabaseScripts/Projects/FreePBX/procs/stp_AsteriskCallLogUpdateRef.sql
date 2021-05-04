IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AsteriskCallLogUpdateRef')
	BEGIN
		DROP  Procedure  stp_AsteriskCallLogUpdateRef
	END

GO

CREATE Procedure stp_AsteriskCallLogUpdateRef
@CallId int,
@RefType varchar(50),
@RefId int,
@UserId int
AS
Begin

	Update tblAstCallLog Set
	RefType = @RefType,
	RefId = @RefId,
	RefDate = GetDate(),
	RefBy = @UserId
	Where CallId = @CallId

End 

GO

 