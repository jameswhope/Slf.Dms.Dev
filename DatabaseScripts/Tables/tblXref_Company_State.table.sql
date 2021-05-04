CREATE TABLE [dbo].[tblXref_Company_State]
(
	XrefId int identity(1,1) NOT NULL, 
	CompanyId int NOT NULL,
	StateId int NOT NULL,
	Accepting bit NOT NULL,
	Primary Key(XrefId)
)
