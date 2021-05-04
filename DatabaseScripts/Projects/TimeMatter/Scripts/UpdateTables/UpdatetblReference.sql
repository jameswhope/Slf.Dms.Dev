--*** Update tblReference***
--**** 2 2/10/2010 ****
 
 IF NOT EXISTS (SELECT ReferenceId FROM dbo.tblReference where ReferenceId =20)

BEGIN

SET IDENTITY_INSERT dbo.tblReference ON
 
INSERT INTO tblReference
(
ReferenceId
,[Table]
,KeyField
,Title
,TitlePlural
,LastWord
,LastWordPlural
,IconSrc
,IconNewSrc
,[Add]
,[Edit]
,[Delete]
,[InfoBoxMessage]

)

VALUES
(
20,
'tblMatterStatusCode',
'MatterStatusCodeId',
'Matter Status Code',
'Matter Status Codes',
'Status Code',
'Status Codes',
'~/images/matter.jpg',
'~/images/matter.jpg',
'True',
'True',
'False',
NULL
)

SET IDENTITY_INSERT dbo.tblReference OFF

END

 
 IF NOT EXISTS (SELECT ReferenceId FROM dbo.tblReference where ReferenceId =21)

BEGIN

SET IDENTITY_INSERT dbo.tblReference ON
 
INSERT INTO tblReference
(
ReferenceId
,[Table]
,KeyField
,Title
,TitlePlural
,LastWord
,LastWordPlural
,IconSrc
,IconNewSrc
,[Add]
,[Edit]
,[Delete]
,[InfoBoxMessage]

)

VALUES
(
21,
'tblMatterType',
'MatterTypeId',
'MatterType',
'Matter Types',
'Type',
'Types',
'~/images/matter.jpg',
'~/images/matter.jpg',
'True',
'True',
'False',
NULL
)

SET IDENTITY_INSERT dbo.tblReference OFF

END

IF NOT EXISTS (SELECT ReferenceId FROM dbo.tblReference where ReferenceId =22)

BEGIN

SET IDENTITY_INSERT dbo.tblReference ON
 
INSERT INTO tblReference
(
ReferenceId
,[Table]
,KeyField
,Title
,TitlePlural
,LastWord
,LastWordPlural
,IconSrc
,IconNewSrc
,[Add]
,[Edit]
,[Delete]
,[InfoBoxMessage]

)

VALUES
(
22,
'tblClassifications',
'ClassificationId',
'Classification',
'Classifications',
'Classification',
'Classifications',
'~/images/matter.jpg',
'~/images/matter.jpg',
'True',
'True',
'False',
NULL
)

SET IDENTITY_INSERT dbo.tblReference OFF

END