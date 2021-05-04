IF OBJECT_ID ('dbo.tr_Audit_tblAttorney', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblAttorney
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
CREATE TRIGGER dbo.tr_Audit_tblAttorney
   ON dbo.tblAttorney
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAttorney ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblAttorney ([AttorneyID],[FirstName],[LastName],[MiddleName],[Suffix],[Address1],[Address2],[City],[State],[Zip],[Phone1],[Phone2],[Fax],[UserID],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[DbName],[RowAddedBy],[Deleted])
		select [AttorneyID],[FirstName],[LastName],[MiddleName],[Suffix],[Address1],[Address2],[City],[State],[Zip],[Phone1],[Phone2],[Fax],[UserID],[Created],[CreatedBy],[LastModified],[LastModifiedBy],db_name(),SUSER_SNAME(),1
		from deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblAttorney ([AttorneyID],[FirstName],[LastName],[MiddleName],[Suffix],[Address1],[Address2],[City],[State],[Zip],[Phone1],[Phone2],[Fax],[UserID],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[DbName],[RowAddedBy])
		select [AttorneyID],[FirstName],[LastName],[MiddleName],[Suffix],[Address1],[Address2],[City],[State],[Zip],[Phone1],[Phone2],[Fax],[UserID],[Created],[CreatedBy],[LastModified],[LastModifiedBy],db_name(),SUSER_SNAME()
		from inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblAttorney OFF
END
GO