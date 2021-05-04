 /*** drop tblWorkflow  ****/
/*** Revision 01/06/2010 ****/

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblWorkFlow')
BEGIN
 

drop table dbo.tblWorkFlow

END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblStatusCode')
BEGIN
 

drop table dbo.tblStatusCode

END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblStaffGroup')
BEGIN
 

drop table dbo.tblStaffGroup

END