IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Harassment_SearchSubmissions')
	BEGIN
		DROP  Procedure  stp_Harassment_SearchSubmissions
	END

GO

CREATE Procedure stp_Harassment_SearchSubmissions
	(
		@searchColumn  varchar(50),
		@searchTerm varchar(500)
	)
AS
BEGIN

	declare @sSQL varchar(max)
	declare @sColType varchar(20)

	SELECT    @sColType = DATA_TYPE 
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE     TABLE_NAME = 'tblHarassmentClient' and column_name = @searchColumn
	ORDER BY   ORDINAL_POSITION ASC

	set @sSQL = 'SELECT distinct ClientSubmissionID,ClientAccountNumber,ClientName,ClientState,DateFormSubmitted,OriginalCreditorName,CurrentCreditorName,Created,CreatedByUser,NoticeOfRepMailDate,NoticeOfCeaseAndDesist,CreditorUnAuthorizedCharges,IndividualCallingName,IndividualCallingIdentity,IndividualCallingPhone,IndividualCallingDateOfCall,IndividualCallingNumTimesCalled,IndividualCallingTimeOfCall,IndividualCallingNumberDialed,ReasonData,docPath,HarassmentStatusID,StatusDescription,HarassmentStatusDate, HarassmentDeclineReasonID,HarassmentDeclineReason,HarassmentType,acctnumber,refnumber,AbuseBeginDate, EstNumberDailyCalls, FirmName from ('    
	set @sSQL = @sSQl + 'SELECT  hc.ClientSubmissionID, [ClientAccountNumber] = hc.clientaccountnumber, [ClientName]= p.firstname + '' '' + p.lastname '
	set @sSQL = @sSQl + ', [ClientState] = s.abbreviation, convert(varchar(10),DateFormSubmitted,101)[DateFormSubmitted], [OriginalCreditorName] = oc.name, [CurrentCreditorName] = cc.name '
	set @sSQL = @sSQl + ', [Created] = convert(varchar(10),hc.created,101), [CreatedByUser] = cu.firstname + '' '' + cu.lastname, hc.NoticeOfRepMailDate, hc.NoticeOfCeaseAndDesist'
	set @sSQL = @sSQl + ', hc.CreditorUnAuthorizedCharges, hc.IndividualCallingName, hc.IndividualCallingIdentity, hc.IndividualCallingPhone'
	set @sSQL = @sSQl + ', CAST(MONTH(hc.IndividualCallingDateOfCall) AS varchar) + ''/'' + CAST(DAY(hc.IndividualCallingDateOfCall) AS varchar) + ''/'' + CAST(YEAR(hc.IndividualCallingDateOfCall) AS varchar) AS IndividualCallingDateOfCall'
	set @sSQL = @sSQl + ', hc.IndividualCallingNumTimesCalled, RIGHT(hc.IndividualCallingTimeOfCall, 8) AS IndividualCallingTimeOfCall, hc.IndividualCallingNumberDialed'
	set @sSQL = @sSQl + ', [ReasonData] = (select top 1 reasondata from tblharassmentdata where clientsubmissionid = hc.clientsubmissionid and reasonid = 32)'
	set @sSQL = @sSQl + ', [docPath] =  ''\\'' + c.StorageServer + ''\'' + c.StorageRoot + ''\'' + c.AccountNumber + ''\creditordocs\'' + dr.SubFolder + c.AccountNumber + ''_'' + dr.DocTypeID + ''_'' + dr.DocID + ''_'' + dr.DateString + ''.pdf'' '
	set @sSQL = @sSQl + ', hc.HarassmentStatusID, hsr.StatusDescription, convert(varchar(10),hc.HarassmentStatusDate,101)[HarassmentStatusDate], hc.HarassmentDeclineReasonID '
	set @sSQL = @sSQl + ', [HarassmentType]=(select top 1 reasonheadervalue from dbo.tblHarassmentReasonHeader where reasonheaderid in (select top 1 headerid from tblharassmentdata where clientsubmissionid = hc.clientsubmissionid))'
	set @sSQL = @sSQl + ', [HarassmentDeclineReason] = CASE WHEN hdr.DeclineReasonDescription IS NULL AND hc.HarassmentStatusID = 1 THEN ''Decline reason needed'' WHEN hdr.DeclineReasonDescription IS NOT NULL AND hc.HarassmentStatusID in (1,2,6) THEN hdr.DeclineReasonDescription ELSE ''NA'' END '
	set @sSQL = @sSQl + ', [acctnumber] = ci.AccountNumber, [refNumber] = ci.ReferenceNumber,[AbuseBeginDate] = hc.AbuseBeginDate, [EstNumberDailyCalls] = isnull(hc.EstNumberDailyCalls,0) '
	set @sSQL = @sSQl + ', [FirmName] = co.name '
	set @sSQL = @sSQl + 'FROM tblHarassmentClient AS hc with(nolock) INNER JOIN tblHarassmentStatusReasons AS hsr with(nolock) ON hsr.HarassmentStatusID = hc.HarassmentStatusID '
	set @sSQL = @sSQl + 'LEFT OUTER JOIN tblHarassmentDeclineReasons AS hdr with(nolock) ON hdr.HarassmentDeclineReasonID = hc.HarassmentDeclineReasonID '
	set @sSQL = @sSQl + 'INNER JOIN tblperson p with(nolock)  on p.personid= hc.personid '
	set @sSQL = @sSQl + 'INNER JOIN tblstate s with(nolock)  on s.stateid = p.stateid '
	set @sSQL = @sSQl + 'left join tblcreditor oc with(nolock)  on oc.creditorid = hc.originalcreditorid '
	set @sSQL = @sSQl + 'left join tblcreditor cc with(nolock)  on cc.creditorid = hc.currentcreditorid '
	set @sSQL = @sSQl + 'left join tbluser cu with(nolock)  on cu.userid = hc.createdby '
	set @sSQL = @sSQl + 'INNER JOIN tblclient c with(nolock)  on c.clientid = hc.clientid '
	set @sSQL = @sSQl + 'INNER JOIN tblDocRelation AS dr with(nolock) ON c.ClientID = dr.ClientID and dr.DocTypeID = ''D8008'' '
	set @sSQL = @sSQl + 'INNER JOIN tblAccount AS a ON hc.CreditorAccountID = a.AccountID '
	set @sSQL = @sSQl + 'INNER JOIN tblCreditorInstance AS ci ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID '
	set @sSQL = @sSQl + 'INNER JOIN tblCompany co with(nolock) on c.companyid= co.companyid '
	set @sSQL = @sSQl + 'where dr.relationid = hc.creditoraccountid  '
	set @sSQL = @sSQl + 'and dr.docid = hc.documentid '
	set @sSQL = @sSQl + 'and year(dr.relateddate) = year(hc.created) and month(dr.relateddate) = month(hc.created) and day(dr.relateddate) = day(hc.created) and datepart(hh,dr.relateddate) = datepart(hh,hc.created) AND (dr.DeletedFlag = 0)	'
	set @sSQL = @sSQl + ') as searchData '
	if @sColType = 'datetime'
		BEGIN
			--set @searchColumn = 'convert(varchar(10),' + @searchColumn + ',101)'
			declare @start SMALLDATETIME
			declare @end SMALLDATETIME
			declare @pos int

			select @pos = charindex('|',@searchTerm,1)
			
			if @pos <> 0
				BEGIN
					select @start = left(@searchTerm,@pos-1)
					select @end = substring(@searchTerm,@pos+1,len(@searchTerm)-@pos)
					
					DECLARE @StartD SMALLDATETIME
					DECLARE @EndD SMALLDATETIME
					SET @StartD = @start
					SET @EndD = @end
					
					set @sSQL = @sSQl + 'where ' + @searchColumn + ' between cast(''' +  cast(@StartD as varchar) + ''' as smalldatetime) '
					set @sSQL = @sSQl + 'and cast(''' +  convert(varchar(10),@end,101) +  ''' as smalldatetime) '
					
					--set @sSQL = @sSQl + 'where ' + @searchColumn + ' >= cast(''' +  cast(@StartD as varchar) + ''' as smalldatetime) and ' 
					--set @sSQL = @sSQl + @searchColumn + ' < ' + char(39)  + cast(@EndD as varchar) + char(39)  + ' ' 
				END
			ELSE
				BEGIN
					set @sSQL = @sSQl + 'where Year(' + @searchColumn + ') = Year(' + char(39) + convert(varchar(10),@start,101) + char(39) + ') '
					set @sSQL = @sSQl + 'AND Month(' + @searchColumn + ') = Month(' + char(39) + convert(varchar(10),@start,101) + char(39) + ') '
					set @sSQL = @sSQl + 'AND Day(' + @searchColumn + ') = Day(' + char(39) + convert(varchar(10),@start,101) + char(39) + ') '
				END
		END
	else
		BEGIN
			set @searchTerm = '%' + @searchTerm  + '%'
			set @sSQL = @sSQl + 'where ' + @searchColumn + ' like ' + char(39) + @searchTerm + char(39) + ' '
		END		
	
	set @sSQL = @sSQl + ' ORDER BY ' + @searchColumn + ' DESC, ClientSubmissionID '
	set @sSQL = @sSQl + 'OPTION (FAST 100) '
	exec(@ssql)
END

GO


GRANT EXEC ON stp_Harassment_SearchSubmissions TO PUBLIC


