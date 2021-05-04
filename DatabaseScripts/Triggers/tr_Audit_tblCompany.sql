IF OBJECT_ID ('dbo.tr_Audit_tblCompany', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblCompany
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.tr_Audit_tblCompany
   ON dbo.tblCompany
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCompany ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblCompany ([CompanyID],[Name],[Default],[ShortCoName],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Contact1],[Contact2],[BillingMessage],[WebSite],[SigPath],[DbName],[RowAddedBy],[Deleted])
		select [CompanyID],[Name],[Default],[ShortCoName],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Contact1],[Contact2],[BillingMessage],[WebSite],[SigPath],db_name(),SUSER_SNAME(),1
		from deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblCompany ([CompanyID],[Name],[Default],[ShortCoName],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Contact1],[Contact2],[BillingMessage],[WebSite],[SigPath],[DbName],[RowAddedBy])
		select [CompanyID],[Name],[Default],[ShortCoName],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Contact1],[Contact2],[BillingMessage],[WebSite],[SigPath],db_name(),SUSER_SNAME()
		from inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCompany OFF
END
GO