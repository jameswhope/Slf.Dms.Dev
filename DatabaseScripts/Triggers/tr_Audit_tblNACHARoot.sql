IF OBJECT_ID ('dbo.tr_Audit_tblNACHARoot', 'TR') IS NOT NULL
   DROP TRIGGER dbo.tr_Audit_tblNACHARoot
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
CREATE TRIGGER dbo.tr_Audit_tblNACHARoot
   ON dbo.tblNACHARoot
   AFTER INSERT,UPDATE,DELETE
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblNACHARoot ON

	if (select count(*) from deleted) > 0 and (select count(*) from inserted) = 0 begin
		insert dms_warehouse.dbo.AUDIT_tblNACHARoot ([tblNACHARoot],[CompanyID],[CommRecID],[Bank],[DestinationRoutingNo],[OriginTaxID],[OriginName],[ConnectionString],[ftpServer],[ftpControlPort],[ftpUpload],[ftpFolder],[ftpUserName],[ftpPassword],[Passphrase],[CreateFile],[GPGDir],[PublicKeyRing],[PrivateKeyring],[FileLocation],[LogPath],[LogFile],[DataProvider],[LogMailTo],[SMTPServer],[Encrypt],[BlackBoxKey],[OperatingAcct],[ClearingAcct],[GenClearing],[IOLTATrust],[LastModified],[ModifiedByUserNo],[Created],[CreatedBy],[DbName],[RowAddedBy],[Deleted])
		select [tblNACHARoot],[CompanyID],[CommRecID],[Bank],[DestinationRoutingNo],[OriginTaxID],[OriginName],[ConnectionString],[ftpServer],[ftpControlPort],[ftpUpload],[ftpFolder],[ftpUserName],[ftpPassword],[Passphrase],[CreateFile],[GPGDir],[PublicKeyRing],[PrivateKeyring],[FileLocation],[LogPath],[LogFile],[DataProvider],[LogMailTo],[SMTPServer],[Encrypt],[BlackBoxKey],[OperatingAcct],[ClearingAcct],[GenClearing],[IOLTATrust],[LastModified],[ModifiedByUserNo],[Created],[CreatedBy],db_name(),SUSER_SNAME(),1
		from deleted
	end
	else begin
		insert dms_warehouse.dbo.AUDIT_tblNACHARoot ([tblNACHARoot],[CompanyID],[CommRecID],[Bank],[DestinationRoutingNo],[OriginTaxID],[OriginName],[ConnectionString],[ftpServer],[ftpControlPort],[ftpUpload],[ftpFolder],[ftpUserName],[ftpPassword],[Passphrase],[CreateFile],[GPGDir],[PublicKeyRing],[PrivateKeyring],[FileLocation],[LogPath],[LogFile],[DataProvider],[LogMailTo],[SMTPServer],[Encrypt],[BlackBoxKey],[OperatingAcct],[ClearingAcct],[GenClearing],[IOLTATrust],[LastModified],[ModifiedByUserNo],[Created],[CreatedBy],[DbName],[RowAddedBy])
		select [tblNACHARoot],[CompanyID],[CommRecID],[Bank],[DestinationRoutingNo],[OriginTaxID],[OriginName],[ConnectionString],[ftpServer],[ftpControlPort],[ftpUpload],[ftpFolder],[ftpUserName],[ftpPassword],[Passphrase],[CreateFile],[GPGDir],[PublicKeyRing],[PrivateKeyring],[FileLocation],[LogPath],[LogFile],[DataProvider],[LogMailTo],[SMTPServer],[Encrypt],[BlackBoxKey],[OperatingAcct],[ClearingAcct],[GenClearing],[IOLTATrust],[LastModified],[ModifiedByUserNo],[Created],[CreatedBy],db_name(),SUSER_SNAME()
		from inserted
	end
	
	SET NOCOUNT OFF
	SET IDENTITY_INSERT dms_warehouse.dbo.AUDIT_tblNACHARoot OFF
END
GO