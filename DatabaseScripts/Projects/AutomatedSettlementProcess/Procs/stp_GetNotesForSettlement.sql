IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNotesForSettlement')
	BEGIN
		DROP  Procedure  stp_GetNotesForSettlement
	END

GO

CREATE Procedure [dbo].[stp_GetNotesForSettlement]
	(
		@clientid int,
		@SettlementId int,
		@relationid int = null,
		@relationtypeid int = null,
		@clientonly bit=0
	)


AS BEGIN

CREATE TABLE #tblResults
(fieldid int,
[type] varchar(20),
[subject] varchar(255),
[Description] varchar(5000),
[by] varchar(255),
usergroup varchar(100),
bylatname varchar(50),
usertype varchar(50),
[date] datetime,
personid int,
userid int,
clientid int,
phonenumber varchar(20),
direction bit,
starttime datetime,
endtime datetime,
color varchar(50),
textcolor varchar(50),
relationid int,
relationtypeid int,
[Order] int
)

INSERT INTO #tblResults
SELECT 
	 n.noteid AS fieldid,
	'NOTE' AS [type]
	,isnull(n.subject, '') AS [Subject]
	,n.value AS [Description]
	,u.firstname + ' ' + u.lastname AS [by]
	,ug.name [usergroup]
	,u.lastname AS bylastname 
	,ut.name AS usertype
	,n.created AS [date]
	,null AS personid
	,u.userid
	,n.clientid
	,''  AS phonenumber
	,''  AS direction
	,''  AS starttime
	,''  AS endtime 
	,(CASE 
		WHEN not rc.color is null THEN rc.color 
		WHEN not uc.color is null THEN uc.color 
		WHEN not gc.color is null THEN gc.color 
		WHEN not tc.color is null THEN tc.color END ) AS color 
	,(CASE 
		WHEN not rc.textcolor is null THEN rc.textcolor 
		WHEN not uc.textcolor is null THEN uc.textcolor 
		WHEN not gc.textcolor is null THEN gc.textcolor 
		WHEN not tc.textcolor is null THEN tc.textcolor END ) AS textcolor 
	,nnr.RelationTypeId
	,nnr.RelationId
	,null AS [Order]
FROM 
	tblnote n left join tblNoteRelation nnr
	ON nnr.NoteId = n.NoteId inner join tbluser u 	
	ON n.createdby=u.userid inner join tblusertype ut 
	ON u.usertypeid=ut.usertypeid inner join tbluserGroup ug
	ON ug.UserGroupId = u.UserGroupId left outer join tblrulecommcolor tc 
	ON u.usertypeid=tc.entityid and tc.entitytype='User Type' left outer join tblrulecommcolor gc 
	ON u.usergroupid=gc.entityid and gc.entitytype='User Group' left outer join tblrulecommcolor uc 
	on u.userid=uc.entityid and uc.entitytype='User' left outer join 
	(SELECT 
		nn.noteid, 
		max(color) AS color,
		max(textcolor) AS textcolor 
	FROM tblnoterelation nr inner join tblnote nn 
		ON nr.noteid=nn.noteid inner join tblrulecommcolor rcc 
		ON rcc.entityid=nr.relationtypeid 
	WHERE 
		nn.clientid= @ClientId and rcc.entitytype='Relation Type' group by nn.noteid ) rc 
	ON rc.noteid=n.noteid 
WHERE
	 n.clientid= @ClientId
ORDER BY n.Created DESC



INSERT INTO #tblResults
SELECT 
		 pc.phonecallid AS fieldid
		,'PHONE' AS [Type]
		,isnull(pc.subject, '') AS [subject]
		,pc.body AS [Description]
		,u.firstname + ' ' + u.lastname AS [by]
		,ug.name [usergroup]
		, u.lastname AS bylastname 
		,ut.name AS usertype
		, pc.created AS [date]
		,pc.personid
		,pc.userid
		,pc.clientid
		,pc.phonenumber
		,pc.direction
		,pc.starttime
		,pc.endtime 
		,(CASE
			 WHEN not rc.color is null THEN rc.color 
			 WHEN not uc.color is null THEN uc.color 
			 WHEN not gc.color is null THEN gc.color 
			 WHEN not tc.color is null THEN tc.color END ) AS color 
		,(CASE 
			 WHEN not rc.textcolor is null THEN rc.textcolor 
			 WHEN not uc.textcolor is null THEN uc.textcolor 
			 WHEN not gc.textcolor is null THEN gc.textcolor 
			 WHEN not tc.textcolor is null THEN tc.textcolor END ) AS textcolor
		,pcr.RelationTypeId
		,pcr.RelationId 
		,null AS [Order]
FROM 
		tblphonecall pc left outer join tblperson p 
		ON pc.personid = p.personid inner join tbluser u 
		ON pc.userid = u.userid inner join tblusertype ut 
		ON u.usertypeid=ut.usertypeid inner join tblusergroup ug
		ON u.usergroupid = ug.usergroupid left outer join tblrulecommcolor tc 
		ON u.usertypeid=tc.entityid and tc.entitytype='User Type' left outer join tblrulecommcolor gc 
		ON u.usergroupid=gc.entityid and gc.entitytype='User Group' left outer join tblrulecommcolor uc 
		ON u.userid=uc.entityid and uc.entitytype='User' left outer join 
		(
		SELECT 
			npc.phonecallid
			,max(color) AS color
			,max(textcolor) AS textcolor 
		FROM tblphonecallrelation pcr inner join tblphonecall npc 
			ON pcr.phonecallid=npc.phonecallid inner join tblrulecommcolor rcc 
			ON rcc.entityid=pcr.relationtypeid 
		WHERE 
			npc.clientid= @ClientId	and rcc.entitytype='Relation Type' group by npc.phonecallid) rc 
		ON rc.phonecallid=pc.phonecallid 
		left outer join tblphonecallrelation pcr ON pc.phonecallid=pcr.phonecallid
WHERE
		pc.clientid= @ClientId
ORDER BY pc.Created DESC

IF @clientonly = 1 BEGIN
	DELETE FROM #tblResults WHERE RelationTypeId <> 1 
END

IF @relationid is not null and @relationtypeid is not null and @clientonly = 1 BEGIN
	DELETE FROM #tblResults WHERE RelationTypeId not in (@relationtypeid,1) and RelationId not in (@relationid, @clientid)
END

IF @relationid is not null and @relationtypeid is not null and @clientonly = 0 BEGIN
	DELETE FROM #tblResults WHERE RelationTypeId <> @relationtypeid and RelationId <> @relationid
END

IF @relationid is null and @relationtypeid is null and @clientonly = 1 BEGIN
	DELETE FROM #tblResults WHERE RelationTypeId <>1 and RelationId <> @clientid
END

INSERT INTO #tblResults 
SELECT 
	 sp.settlementid AS fieldid
	,'NOTE' AS [type]
	,'Special Instructions:' 
	,sp.SpecialInstructions AS [Description]
	,u.firstname + ' ' + u.lastname AS [by]
	,ug.name [usergroup]
	,u.lastname AS bylastname 
	,ut.name AS usertype
	,sp.created AS [date]
	,null AS personid
	,sp.CreatedBy
	,s.clientid
	,''  AS phonenumber
	,''  AS direction
	,''  AS starttime
	,''  AS endtime 
	,'' AS color
	,'' As Textcolor
	,0 As RelationId
	,0 AS RelationTypeId
	,1 AS [Order]
FROM 
	tblSettlements_SpecialInstructions sp inner join
	tblSettlements s ON s.SettlementId = sp.SettlementId inner join
	tblUser u ON u.Userid = sp.CreatedBy inner join
	tblUserType ut ON ut.userTypeId = u.UserTypeId inner join
	tblUsergroup ug ON ug.UserGroupId = u.UserGroupId
WHERE 
	sp.SettlementId = @SettlementId

SELECT distinct fieldid , [type] , [subject] , [Description], [by] , usergroup, bylatname , usertype , [date] , personid , userid ,
clientid , phonenumber , direction , starttime , endtime , color , textcolor, [Order] FROM #tblResults ORDER BY [Date] DESC

DROP TABLE #tblResults;

END

GO


GRANT EXEC ON stp_GetNotesForSettlement TO PUBLIC

GO


