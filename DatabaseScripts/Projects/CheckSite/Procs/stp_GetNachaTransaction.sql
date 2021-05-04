IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNachaTransaction')
	BEGIN
		DROP  Procedure  stp_GetNachaTransaction
	END

GO

CREATE Procedure stp_GetNachaTransaction
(
	@NachaRegisterId int
)
AS
select 
n.NachaRegisterId 
,n.[Name] 
,n.AccountNumber  
,n.RoutingNumber 
,n.Type 
,n.Amount 
,n.IsPersonal 
,n.CommRecId 
,n.CompanyId 
,n.ClientId
,n.ShadowStoreId 
,n.TrustId
,n.RegisterId 
,n.RegisterPaymentId 
,n.[Status] 
,n.[State] 
,n.ReceivedDate 
,n.ProcessedDate
,n.ExceptionCode 
,n.Notes 
,n.ExceptionResolved 
,n.Flow
from 
	tblNachaRegister2 n
Where 
	n.NachaRegisterId = @NachaRegisterId

GO