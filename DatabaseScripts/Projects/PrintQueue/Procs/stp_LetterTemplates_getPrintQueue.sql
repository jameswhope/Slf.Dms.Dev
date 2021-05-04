IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_LetterTemplates_getPrintQueue')
	BEGIN
		DROP  Procedure  stp_LetterTemplates_getPrintQueue
	END

GO

CREATE Procedure stp_LetterTemplates_getPrintQueue

	(
		@QueueType int = 1
	)
AS
BEGIN
--WelcomeEmail
	if @QueueType = 0
		BEGIN
			select
			[QID] = c.clientid
			, [Display Name] = c.accountnumber
			, [Client Name] = p.firstname + ' ' + p.lastname
			, [Printed By] =  null
			, [Total Pages] = 0
			, [ActionDate] = v.statuscreated
			, [PrintDocumentPath] = null
			, [PrintDocumentID] = null
			, [DataClientID] = c.clientid
			,Creditor=null, SettlementAmount=null, SettlementDueDate=null
			from tblclient c with(nolock)
			join tblcompany cp  with(nolock) on cp.companyid = c.companyid
			join tblcompanyaddresses ca  with(nolock) on ca.companyid = cp.companyid and ca.addresstypeid = 3 -- Client
			join tblperson p  with(nolock) on p.personid = c.primarypersonid
			join vw_ClientCurrentStatusCreated v  with(nolock) on v.clientid = c.clientid
			where 1=1
			and c.currentclientstatusid = 14 -- active
			and v.minstatuscreated > '9/27/2010' -- 8.23.ug.new letter coming, clear queue.  date we started these emails
			and datediff(d,v.statuscreated,getdate()) > 0
			and c.clientid not in (select distinct printclientid from tblletters_printed where printdoctypeid = 'W0001' and printclientid = c.clientid)
			and p.emailaddress is null 
			order by v.statuscreated desc
			option (fast 100)
		END
--Reprint
	if @QueueType = 1
		BEGIN
			select 
			[QID] = lp.printid
			,[Display Name] = dt.displayname
			, [Client Name] = p.firstname + ' ' + p.lastname
			, [Printed By] =  cu.firstname + ' ' + cu.lastname
			, [Total Pages] = PrintDocumentPageCount
			, [ActionDate] = lp.PrintDate
			,PrintDocumentPath
			, [PrintDocumentID] = null
			, [DataClientID] = c.clientid
			,Creditor=null, SettlementAmount=null, SettlementDueDate=null
			from [tblLetters_Printed]  lp
			inner join tbldocumenttype dt with(nolock) on lp.printdoctypeid = dt.typeid
			inner join tblclient c with(nolock) on c.clientid = lp.printclientid
			inner join tblperson p with(nolock) on p.personid = c.primarypersonid
			inner join tbluser cu with(nolock) on cu.userid = lp.printby
			where year(printdate)=year(getdate()) and month(printdate)=month(getdate()) and day(printdate)=day(dateadd(d,-1,getdate()))
			and lp.reprintdate is null
			order by printdate desc
			option (fast 100)
		END
--AutomatedSettlementProcessing		
	if @QueueType = 2
		BEGIN
			declare @tblQ table (QID int,[Display Name] varchar(200),[Client Name] varchar(500),[Printed By] varchar(500),[Total Pages] int,ActionDate datetime
			,PrintDocumentPath varchar(max),PrintDocumentID varchar(200), DataClientID int,Creditor varchar(500), SettlementAmount money, SettlementDueDate smalldatetime)

			insert into @tblQ
			SELECT distinct    s.SettlementID AS QID, 'Settlement Acceptance Form' AS [Display Name], p.FirstName + ' ' + p.LastName AS [Client Name], '' AS [Printed By], 1 AS [Total Pages], 
			s.Created AS ActionDate, NULL AS PrintDocumentPath, NULL AS PrintDocumentID, c.ClientID, cg.Name AS Creditor, s.SettlementAmount, s.SettlementDueDate
			FROM         tblPhone AS ph WITH (nolock) RIGHT OUTER JOIN
			tblSettlements AS s WITH (nolock) INNER JOIN
			tblClient AS c WITH (nolock) ON c.ClientID = s.ClientID INNER JOIN
			tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID INNER JOIN
			tblCreditorGroup AS cg WITH (nolock) INNER JOIN
			tblCreditor AS cr WITH (nolock) ON cg.CreditorGroupID = cr.CreditorGroupID INNER JOIN
			tblCreditorInstance AS ci WITH (nolock) ON cr.CreditorID = ci.CreditorID INNER JOIN
			tblAccount AS a WITH (nolock) ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID ON s.CreditorAccountID = a.AccountID LEFT OUTER JOIN
			tblPersonPhone AS pp WITH (nolock) ON pp.PersonID = p.PersonID ON ph.PhoneID = pp.PhoneID
			where s.matterid in 
			(
			select m.matterid
			from tblmatter m with(nolock)
			inner join tblmattertask mt with(nolock) on m.matterid = mt.matterid
			inner join tbltask t with(nolock) on t.taskid = mt.taskid 
			where mattertypeid = 3 and matterstatusid in (1,3) and t.tasktypeid = 72 
			and t.resolved is null
			) and s.active = 1 and status = 'a' and s.SAFPrinted is null
			option (fast 5)
			
			--12.28.10.ug
			--used to turn off queue unti we get 
			--new saf in production
			select * from @tblQ where 1=2 order by actiondate desc
			--select * from @tblQ order by actiondate desc
		END
--FinalSettlementKit		
	if @QueueType = 3
		BEGIN
			SELECT DISTINCT
				s.SettlementID AS QID,
				'Finalized Settlement Kit' AS [Display Name],
				p.FirstName + ' ' + p.LastName AS [Client Name],
				'' AS [Printed By],
				4 AS [Total Pages],
				s.LastModified AS ActionDate,
				p.EmailAddress AS PrintDocumentPath,
				NULL AS PrintDocumentID,
				c.ClientID AS DataClientId,
				cr.Name AS Creditor,
				s.SettlementAmount,
				s.SettlementDueDate
			FROM
				tblSettlements AS s WITH (NOLOCK)
				INNER JOIN
					tblMatter m
					ON m.MatterId = s.MatterId
				INNER JOIN
					tblClient AS c WITH (NOLOCK)
					ON c.ClientID = s.ClientID
				INNER JOIN
					tblPerson AS p WITH (NOLOCK)
					ON p.PersonID = c.PrimaryPersonID
				INNER JOIN
					tblAccount AS a WITH (NOLOCK)
					ON s.CreditorAccountID = a.AccountID
				INNER JOIN
					tblCreditorInstance AS ci WITH (NOLOCK)
					ON a.CurrentCreditorInstanceId = ci.CreditorInstanceId
				INNER JOIN
					tblCreditor AS cr WITH (NOLOCK)
					ON ci.CreditorID = cr.CreditorID
				WHERE MatterStatusId = 4 AND 
					MatterStatusCodeId = 37 AND 
					IsDeleted = 0 AND 
					a.AccountSTatusId = 54
					and s.Active = 1
					and s.Status = 'a'
					and s.ClientID not in (SELECT ClientId FROM tblDocRelation D with(nolock) WHERE RelationType = 'matter' AND DocTypeId = 'D5005'  AND  isnull(DeletedFlag,0) =0)
				option (fast 50)
		END
/*		
--PendingCancellationNotice
	if @QueueType = 4
		BEGIN
			SELECT distinct    
				cl.MatterId AS QID, 
				'Cancellation Pending Notice' AS [Display Name], 
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				'' AS [Printed By], 
				2 AS [Total Pages], 
				t.Resolved AS ActionDate, 
				NULL AS PrintDocumentPath, 
				NULL AS PrintDocumentID, 
				cl.ClientID As DataClientId, 
				NULL AS Creditor, 
				cl.TotalRefund AS SettlementAmount, 
				dateadd(d, 10, m.MatterDate) As SettlementDueDate
			FROM 
			tblCancellation AS cl WITH (nolock) INNER JOIN
			tblMatter m ON m.MatterId = cl.MatterId AND m.MatterStatusCodeId = 49 
					AND m.IsDeleted = 0  inner join
			tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join
			tblMatterTask mt ON mt.MatterId = m.MatterId inner join
			tblTask t ON t.TaskId= mt.TaskId  inner join
			tblClient AS c WITH (nolock) ON c.ClientID = cl.ClientID INNER JOIN
			tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
			WHERE cl.ClientRequestedRefund = 1 AND NOT Exists (select ClientId From tblDocRelation d where d.RelationId = cl.MatterId and RelationType = 'matter' and DocTypeId = 'D5015' and DeletedFlag = 0 and RelatedDate > m.MatterDate)
			option (fast 5)
		END
--PendingBankruptcyRequest		
	if @QueueType = 5
		BEGIN
			SELECT distinct    
				cl.MatterId AS QID, 
				'Bankruptcy Request Letter' AS [Display Name], 
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				'' AS [Printed By], 
				1 AS [Total Pages], 
				t.Resolved AS ActionDate, 
				NULL AS PrintDocumentPath, 
				NULL AS PrintDocumentID, 
				cl.ClientID As DataClientId, 
				NULL AS Creditor, 
				cl.TotalRefund AS SettlementAmount, 
				dateadd(d, 10, m.MatterDate) As SettlementDueDate
			FROM 
			tblCancellation AS cl WITH (nolock) INNER JOIN
			tblMatter m ON m.MatterId = cl.MatterId AND m.MatterStatusCodeId = 51 
					AND m.IsDeleted = 0  inner join
			tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join
			tblMatterTask mt ON mt.MatterId = m.MatterId inner join
			tblTask t ON t.TaskId= mt.TaskId inner join
			tblClient AS c WITH (nolock) ON c.ClientID = cl.ClientID INNER JOIN
			tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
			WHERE NOT Exists (select ClientId From tblDocRelation d where d.RelationId = cl.MatterId and RelationType = 'matter' and DocTypeId = 'D8019' and DeletedFlag = 0 and RelatedDate > m.MatterDate)
			option (fast 5)
		END
*/
--WelcomePackage
	IF @QueueType = 6
		BEGIN
			select 
			[QID]
			,[Display Name]
			,[Client Name]
			,[Printed By]
			,[Total Pages]
			,[ActionDate]
			,[PrintDocumentPath]
			,[PrintDocumentID]
			,[DataClientID]
			,[Creditor]
			,[SettlementAmount]
			,[SettlementDueDate]
			from
			(
			select distinct [QID] = c.PrimaryPersonID,[Display Name] = 'Welcome Package', [Client Name] = p.firstname + ' ' + p.lastname
			, [Printed By] =  null, [Total Pages] = null, [ActionDate] = acceptrejectdate, [PrintDocumentPath] = null, [PrintDocumentID] = c.accountnumber
			, [DataClientID] = c.clientid,Creditor=null, SettlementAmount=null, SettlementDueDate=null,
			[welpkgcnt]=(select count(*) from tblletters_printed where printclientid = c.clientid and printdoctypeid = 'D4000K')
			+ (select count(*) from tbldocrelation where clientid = c.clientid and doctypeid in ('C2000','C2001','C2002'))
			,VWUWResolved,accept,acceptrejectdate
			from tblclient c
			INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID
			left join tblletters_printed  lp on lp.printclientid = c.clientid and lp.printdoctypeid = 'D4000K'
			where VWUWResolved > '10/28/2010 15:30:00' and NOT c.CurrentClientStatusID IN(15,17)
			) as tdata
			where welpkgcnt = 0
			and (accept = 1  and datediff(day,acceptrejectdate,getdate()) = 0 
			or acceptrejectdate >= '10/28/2010 15:30:00')
			order by actiondate
		END		
--ClientStipulation		
	IF @QueueType = 7
		BEGIN
			SELECT distinct    
				s.SettlementID AS QID, 
				'Settlement Client Stipulation' AS [Display Name], 
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				u.firstname + ' ' + u.lastname AS [Printed By], 
				0 AS [Total Pages], 
				s.LastModified AS ActionDate, 
				'\\' + c.storageserver + '\' + c.storageroot + '\' + c.accountnumber + '\CreditorDocs\' + dr.subfolder + c.accountnumber + '_' + dr.doctypeid + '_' + dr.docid + '_' + dr.datestring + '.pdf' AS PrintDocumentPath, 
				dr.docid AS PrintDocumentID, 
				c.ClientID As DataClientId, 
				cr.Name AS Creditor, 
				s.SettlementAmount, 
				s.SettlementDueDate
			FROM 
			tblSettlements AS s WITH (nolock) 
			inner join tblDocRelation dr with(nolock) on dr.relationid = s.creditoraccountid and RelationType = 'account' and DocTypeId = 'D9012'
			INNER JOIN tblMatter m with(nolock) ON m.MatterId = s.MatterId and MatterStatusId =3 and mattersubstatusid in (87) AND IsDeleted = 0 
			inner join tblClient AS c WITH (nolock) ON c.ClientID = s.ClientID 
			INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
			INNER JOIN tblAccount AS a WITH (nolock) ON s.CreditorAccountID = a.AccountID 
			inner join tblCreditorInstance AS ci WITH (nolock) ON a.CurrentCreditorInstanceId = ci.CreditorInstanceId 
			INNER JOIN tblCreditor AS cr WITH (nolock) ON ci.CreditorID = cr.CreditorID 
			inner join tbluser u with(nolock) on u.userid = dr.relatedby
			where s.active = 1 and status = 'a'
			option (fast 5)
		END
--NonDeposit		
	if @QueueType = 8
		BEGIN
			SELECT distinct    
				l.NonDepositLetterId AS QID, 
				'Non Deposit Letter' AS [Display Name], 
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				'' AS [Printed By], 
				1 AS [Total Pages], 
				l.Created AS ActionDate, 
				NULL AS PrintDocumentPath, 
				NULL AS PrintDocumentID, 
				n.ClientID As DataClientId, 
				NULL AS Creditor, 
				NULL AS SettlementAmount, 
				NULL As SettlementDueDate
			FROM 
			tblNonDepositLetter AS l WITH (nolock) 
			INNER JOIN tblnondeposit n on n.nondepositid = l.nondepositid
			INNER JOIN tblMatter m ON m.MatterId = n.MatterId AND m.IsDeleted = 0  
			--inner join tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 
			inner join tblClient AS c WITH (nolock) ON c.ClientID = n.ClientID 
			INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
			WHERE l.LetterType in ('D5030', 'D5031', 'D5013', 'D8022')
			and l.DoNotPrint = 0
			AND l.PrintedDate is null
			AND c.currentclientstatusid not in (15,16,17,18)	
			order by l.Created desc
			option (fast 5)
		END
--BouncedDeposit		
	if @QueueType = 9
		BEGIN
			SELECT distinct    
				l.NonDepositLetterId AS QID, 
				'NSF Letter' AS [Display Name], 
				p.FirstName + ' ' + p.LastName AS [Client Name], 
				'' AS [Printed By], 
				1 AS [Total Pages], 
				l.Created AS ActionDate, 
				NULL AS PrintDocumentPath, 
				NULL AS PrintDocumentID, 
				n.ClientID As DataClientId, 
				NULL AS Creditor, 
				0 AS SettlementAmount, 
				n.Created As SettlementDueDate
			FROM 
			tblNonDepositLetter AS l WITH (nolock) 
			INNER JOIN tblnondeposit n on n.nondepositid = l.nondepositid
			INNER JOIN tblMatter m ON m.MatterId = n.MatterId AND m.IsDeleted = 0  
			--inner join tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 
			inner join tblClient AS c WITH (nolock) ON c.ClientID = n.ClientID 
			INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
			WHERE l.LetterType in ('D5025')
			and l.DoNotPrint = 0
			AND l.PrintedDate is null
			AND c.currentclientstatusid not in (15,16,17,18)	
			order by l.Created desc
			option (fast 5)
		END
--LetterOfRepresentation
	if @QueueType = 10
		BEGIN
			select 
				QID
				,[Display Name]
				,[Client Name]
				,[Printed By]
				,[Total Pages]
				,[ActionDate]
				,[PrintDocumentPath]
				,[PrintDocumentID]
				,[DataClientID]
				,[Creditor]
				,[SettlementAmount]
				,[SettlementDueDate]
			from
				(
				select distinct [QID] = c.clientid,[Display Name] = 'Letters of Representation', [Client Name] = p.firstname + ' ' + p.lastname
				, [Printed By] =  null
				, [Total Pages] = (select count(*) from tblaccount with(nolock) where clientid = c.clientid and not accountstatusid in (170,171,55))
				, [ActionDate] = acceptrejectdate, [PrintDocumentPath] = null, [PrintDocumentID] = c.accountnumber
				, [DataClientID] = c.clientid,Creditor=null, SettlementAmount=null, SettlementDueDate=null
				,[edocssentcnt] = (select count(*) from tbldocrelation with(nolock) where clientid = c.clientid and doctypeid in ('C2000','C2001','C2002'))
				, [lorsprinted]=(select count(*) from tblletters_printed with(nolock) where printclientid = c.clientid and printdoctypeid = 'D4006')
				,VWUWResolved,accept,acceptrejectdate
				from tblclient c with(nolock)
				INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID
				where VWUWResolved > '10/28/2010 15:30:00' 
				) as tdata
			where [edocssentcnt] > 0 and [Total Pages]>0 and [lorsprinted] = 0
			order by actiondate
		END
END


GO


GRANT EXEC ON stp_LetterTemplates_getPrintQueue TO PUBLIC

GO


