IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNachaPendingTransactions')
	BEGIN
		DROP  Procedure  stp_GetNachaPendingTransactions
	END

GO

CREATE Procedure stp_GetNachaPendingTransactions
@DepositsOnly bit = Null
AS
BEGIN
	Select Distinct NachaRegisterId as [NachaRegisterId]
	From  tblNachaRegister2
	Where isnull([State],0) <> 1 and isnull([Status], 0) = 0
	and isnull(NachaFileId,-1) > 0
	and (isnull(@DepositsOnly, 0) = 0 or IsPersonal = @DepositsOnly)
	Order by NachaRegisterId
END
GO



