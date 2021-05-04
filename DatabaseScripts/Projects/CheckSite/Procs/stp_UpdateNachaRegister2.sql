IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateNachaRegister2')
	BEGIN
		DROP  Procedure  stp_UpdateNachaRegister2
	END

GO

CREATE Procedure stp_UpdateNachaRegister2
@NachaRegisterId int  
,@NachaFileId int = NULL
,@Name varchar(50) = NULL
,@AccountNumber varchar(50) = NULL 
,@RoutingNumber varchar(50) = NULL
,@Type varchar(1) = NULL
,@Amount money = NULL
,@IsPersonal bit = NULL
,@CommRecId int = NULL
,@CompanyID int = NULL
,@ClientID int = NULL
,@ShadowStoreId varchar(20) = NULL
,@TrustId varchar(20) = NULL
,@RegisterID int = NULL
,@RegisterPaymentID int = NULL
,@Status int = NULL
,@State int = NULL
,@ReceivedDate DateTime = NULL
,@ProcessedDate DateTime = NULL
,@ExceptionCode varchar(255) = NULL
,@Notes varchar(max) = NULL
,@ExceptionResolved bit = NULL
AS
UPDATE tblNachaRegister2 SET
NachaFileId = isnull(@NachaFileId, NachaFileId)
,[Name] = isnull(@Name, [Name])
,AccountNumber = isnull(@AccountNumber, AccountNumber) 
,RoutingNumber = isnull(@RoutingNumber, RoutingNumber)
,[Type] = isnull(@Type, [Type])
,Amount = isnull(@Amount, Amount)
,IsPersonal = isnull(@IsPersonal, IsPersonal)
,CommRecId = isnull(@CommRecId, CommRecId)
,CompanyId = isnull(@CompanyId, CompanyId)
,ClientId = isnull(@ClientId, ClientId)
,ShadowStoreId = isnull(@ShadowStoreId, ShadowStoreId)
,TrustID = isnull(@TrustId, TrustId)
,RegisterID = isnull(@RegisterId, RegisterId)
,RegisterPaymentID = isnull(@RegisterPaymentId, RegisterPaymentId)
,[Status] = isnull(@Status, [Status])
,[State] = isnull(@State, [State])
,ReceivedDate = isnull(@ReceivedDate, ReceivedDate)
,ProcessedDate = isnull(@ProcessedDate, ProcessedDate)
,ExceptionCode = isnull(@ExceptionCode, ExceptionCode)
,Notes = isnull(@Notes, Notes)
,ExceptionResolved = isnull(@ExceptionResolved, ExceptionResolved)
WHERE NachaRegisterId = @NachaRegisterId

GO