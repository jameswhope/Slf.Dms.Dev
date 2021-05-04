//*** Add RelationTypeId =20 for client Request ***/
//**** 0 1/19/2010 *****/

IF NOT EXISTS (SELECT RelationTypeID FROM dbo.tblRelationType where RelationTypeId =20)

BEGIN

SET IDENTITY_INSERT dbo.tblRelationType ON
 
INSERT INTO tblRelationType 
(
RelationTypeID
,[Table]
,KeyField
,[Name]
,IconURL
,NavigateURL
,DocRelation
)

VALUES
(
20,
'tblClientRequest',
'ClientRequestId',
'Client Request',
'~/images/16x16_user.png',
'~/clients/client/?id=$x$',
NULL
)

SET IDENTITY_INSERT dbo.tblRelationType OFF

END