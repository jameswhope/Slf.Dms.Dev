IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetClientSearches')
	BEGIN
		DROP  Procedure  stp_GetClientSearches
	END

GO

CREATE Procedure stp_GetClientSearches
(
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@where2 varchar(max) = '',
		@orderby varchar (8000) = '',
		@userid int
	)

as

declare @join varchar(2000)
declare @sSQL nvarchar(max)

-- filter search results if user belongs to specific company(s)
if exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	set @join = ' join tblusercompanyaccess uc on uc.companyid = tblClient.companyid and uc.userid = ' + cast(@userid as varchar(10))
end else
	set @join = ' '


set @sSQL = 'DECLARE @Search TABLE
			(
			ClientSearchID INT,
			ClientID INT,
			LeadApplicantID NVARCHAR(50),
			RepName NVARCHAR(250),
			RepExtension NVARCHAR(50),
			[Type] NVARCHAR(500),
			[Name] NVARCHAR(500),
			AccountNumber NVARCHAR(500),
			SSN NVARCHAR(500),
			[Address] NVARCHAR(MAX),
			ContactType NVARCHAR(MAX),
			ContactNumber NVARCHAR(MAX),
			ClientStatus NVARCHAR(MAX),
			Created DATETIME
			)
		INSERT INTO @Search
		SELECT TOP ' + @returntop + '
			tblclientsearch.clientsearchid, 
			tblclientsearch.clientid,
			NULL, 
			NULL, 
			NULL, 
			tblclientsearch.type,
			tblclientsearch.name,
			tblclientsearch.accountnumber,
			tblclientsearch.ssn,
			tblclientsearch.address,
			tblclientsearch.contacttype,
			tblclientsearch.contactnumber, 
			tblclientstatus.name [ClientStatus],
			tblClient.created
		FROM tblclientsearch
		JOIN tblclient ON tblClient.clientid = tblClientSearch.clientid
		JOIN tblclientstatus ON tblclientstatus.clientstatusid = tblClient.currentclientstatusid
		' + @join + ' ' + @where + ' ' + @orderby + ' ' +

		'INSERT INTO @Search
		SELECT TOP ' + @returntop + '
			NULL,
			NULL,
			tblLeadApplicant.leadapplicantid,
			tblUser.FirstName + '' '' + tblUser.LastName [Rep],
			tblUserExt.ext,
			NULL,
			tblLeadApplicant.fullname,
			''None'',
			tblLeadApplicant.SSN,
			tblLeadApplicant.address1 + '', '' + tblLeadApplicant.city + '', '' + tblState.name + '' '' + tblLeadApplicant.zipcode,
			''Rep: '' + tblUser.FirstName + '' '' + tblUser.LastName + '' '' + ''Ext: '' + '' '' + tblUserExt.ext,
			NULL,
			''Prospect: The LSA has not been signed.'',
			tblLeadApplicant.created	
		FROM vw_Enrollment_LSA_Complete
		JOIN tblLeadApplicant ON tblLeadApplicant.LeadApplicantID = vw_Enrollment_LSA_Complete.LeadApplicantID AND vw_Enrollment_LSA_Complete.completed IS NULL
		JOIN tblUser ON tblUser.userid = tblLeadApplicant.repid
		JOIN tblstate ON tblstate.stateid = tblLeadApplicant.stateid
		LEFT JOIN tblUserExt ON tblUserExt.fullname = tblUser.firstname + '' '' + tblUser.lastname
		' + @where2 + ' ' + @orderby + ' ' +
		'SELECT * FROM @Search ORDER BY CREATED DESC'
	
exec(@sSQL)


GO

/*
GRANT EXEC ON stp_GetClientSearches TO PUBLIC

GO
*/

