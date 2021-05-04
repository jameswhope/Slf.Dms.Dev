IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AsteriskCallLogUniqueIdUpdate')
	BEGIN
		DROP  Procedure  stp_AsteriskCallLogUniqueIdUpdate
	END

GO

CREATE Procedure stp_AsteriskCallLogUniqueIdUpdate
@CallId int,
@UniqueId varchar(20),
@LeadCall bit = 0
AS
Begin

If @LeadCall = 0
	UPDATE tblAstCallLog Set 
	CallIdKey = Case When Inbound = 0 Then @UniqueId
				Else Left(@UniqueId, CharIndex('.',@UniqueId) - 1) + '.'+ cast(Right(@UniqueId, Len(@UniqueId) - CharIndex('.',@UniqueId)) - 1 as varchar(10))
				End
	WHERE callid = @callid
Else
	UPDATE tblAstCallLog Set 
	CallIdKey = Case When l.Inbound = 0 Then @UniqueId
				Else Left(@UniqueId, CharIndex('.',@UniqueId) - 1) + '.'+ cast(Right(@UniqueId, Len(@UniqueId) - CharIndex('.',@UniqueId)) - 1 as varchar(10))
				End 
	from tblAstCallLog l 
	inner join tblLeadDialerCall d on d.CallId = l.CallId 
	WHERE d.callmadeid = @callid

End

GO

 
