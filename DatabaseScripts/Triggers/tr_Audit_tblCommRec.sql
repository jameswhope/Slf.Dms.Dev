IF OBJECT_ID ('dbo.tr_Audit_tblCommRec', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblCommRec
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
CREATE TRIGGER dbo.tr_Audit_tblCommRec
   ON dbo.tblCommRec
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCommRec ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblCommRec ([CommRecID],[CommRecTypeID],[Abbreviation],[Display],[IsCommercial],[IsLocked],[IsTrust],[Method],[BankName],[RoutingNumber],[AccountNumber],[Type],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[CompanyID],[AgencyID],[AccountTypeID],[DbName],[RowAddedBy],[Deleted])
		select [CommRecID],[CommRecTypeID],[Abbreviation],[Display],[IsCommercial],[IsLocked],[IsTrust],[Method],[BankName],[RoutingNumber],[AccountNumber],[Type],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[CompanyID],[AgencyID],[AccountTypeID],db_name(),SUSER_SNAME(),1
		from deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblCommRec ([CommRecID],[CommRecTypeID],[Abbreviation],[Display],[IsCommercial],[IsLocked],[IsTrust],[Method],[BankName],[RoutingNumber],[AccountNumber],[Type],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[CompanyID],[AgencyID],[AccountTypeID],[DbName],[RowAddedBy])
		select [CommRecID],[CommRecTypeID],[Abbreviation],[Display],[IsCommercial],[IsLocked],[IsTrust],[Method],[BankName],[RoutingNumber],[AccountNumber],[Type],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[CompanyID],[AgencyID],[AccountTypeID],db_name(),SUSER_SNAME()
		from inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblCommRec OFF
END
GO