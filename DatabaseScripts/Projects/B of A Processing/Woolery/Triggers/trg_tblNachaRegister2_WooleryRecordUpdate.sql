IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trg_tblNachaRegister2_WooleryRecordUpdate')
	BEGIN
		DROP  Trigger trg_tblNachaRegister2_WooleryRecordUpdate
	END
GO

CREATE Trigger trg_tblNachaRegister2_WooleryRecordUpdate ON tblNachaRegister2 
AFTER UPDATE
AS 
-- =============================================
-- Author:		Jim Hope 05/13/2011
-- Create date: May-2011
-- Description:	This trigger updates the data for Woolery clients to Woolery database
-- Modified by Jim Hope to set trust ID instead of remittname as exist condition
-- =============================================

BEGIN

SET NOCOUNT ON;


IF EXISTS (
		select a.* from INSERTED a
		inner join DMS..tblClient b 
		on a.clientid=b.clientid
		Where b.trustid=24
			)
BEGIN

	IF TRIGGER_NESTLEVEL() > 1
		RETURN

UPDATE WOOLERY.[dbo].[tblNachaRegister2]
		SET [NachaFileId]			=a.[NachaFileId]
		,[Name]						=a.[Name]
		,[AccountNumber]			=a.[AccountNumber]
		,[RoutingNumber]			=a.[RoutingNumber]
		,[Type]						=a.[Type]
		,[Amount]					=a.[Amount]
		,[IsPersonal]				=a.[IsPersonal]
		,[CommRecId]				=a.[CommRecId]
		,[CompanyID]				=a.[CompanyID]
		,[ShadowStoreId]			=a.[ShadowStoreId]
		,[ClientID]					=a.[ClientID]
		,[TrustId]					=a.[TrustId]
		,[RegisterID]				=a.[RegisterID]
		,[RegisterPaymentID]		=a.[RegisterPaymentID]
		,[Created]					=a.[Created]
		,[Status]					=a.[Status]
		,[State]					=a.[State]
		,[ReceivedDate]				=a.[ReceivedDate]
		,[ProcessedDate]			=a.[ProcessedDate]
		,[ExceptionCode]			=a.[ExceptionCode]
		,[Notes]					=a.[Notes]
		,[ExceptionResolved]		=a.[ExceptionResolved]
		,[Flow]						=a.[Flow]
		,[ReferenceNachaRegisterID]	=a.[ReferenceNachaRegisterID]
		FROM [WOOLERY].[dbo].[tblNachaRegister2] i
		INNER JOIN INSERTED a
		on i.NachaRegisterId = a.[ReferenceNachaRegisterID]
	END
END

GO

