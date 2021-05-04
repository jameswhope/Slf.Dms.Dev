 if not exists(Select TypeId from tblDocumentType where TypeID = '9074')
 begin
	Insert Into tblDocumentType(TypeId, TypeName, DisplayName, DocFolder, Created, CreatedBy, LastModified,LastModifiedBy)
	Values('9074','Settlement Recorded Call', 'Settlement Recorded Call', 'ClientDocs', GetDate(), 785, GetDate(), 785)
 end