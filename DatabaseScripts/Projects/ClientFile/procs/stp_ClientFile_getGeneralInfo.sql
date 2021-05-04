IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getGeneralInfo')
	BEGIN
		DROP  Procedure  stp_ClientFile_getGeneralInfo
	END

GO

CREATE procedure [dbo].[stp_ClientFile_getGeneralInfo]
(
	@clientID int
)
as
BEGIN

	/*
	declare @clientID int
	set @clientID = 1671
	*/
		--declare multi-deposit vars
	declare @multi bit
	declare @depmeth varchar 
	declare @depday varchar
	declare @depamt money

	--init vars
	set @depmeth = NULL
	set @depday = 0
	set @depamt = 0

	--check if client is multi-deposit
	select @multi = multideposit from tblclient where clientid = @clientid
	IF @multi = 1
		BEGIN
			--get multi-deposit info
			select top 1
				@depmeth = depositmethod
				,@depday = depositday
				,@depamt = depositamount
			from tblclientdepositday 
			where clientid = @clientid 
			order by created desc
			--check if we actually got data
			if @depmeth is null
				BEGIN
					--if not fall back on tblclients data
					select 
						@depmeth = isnull(depositmethod,'')
						,@depday = isnull(depositday,0)
						,@depamt = isnull(depositamount,0)
					from tblclient 
					where clientid = @clientid
				END
		END
	ELSE
		--non multi-deposit, use tblclient
		select 
			@depmeth = isnull(depositmethod,'')
			,@depday = isnull(depositday,0)
			,@depamt = isnull(depositamount,0)
		from tblclient 
		where clientid = @clientid

	SELECT TOP 1
		 [FirmAccount#] = c.AccountNumber
		, [FirmName] = isnull(co.Name,'') 
		, [EnrollmentDate] = isnull((select TOP 1 created as [EnrollmentDate] from tblroadmap where clientid = c.clientid and clientstatusid = 2 order by created),'') 
		, [AgencyName] = a.name 
		, [AgentName] = c.agentName
		, [BankName] = isnull(c.bankname,'')
		, [BankRoutingNumber] = isnull(c.BankRoutingNumber,'')
		, [BankAccountNumber] = isnull(c.BankAccountNumber,'')
		, [DepositStartDate] = isnull(c.depositstartdate,'')
		, [DepositMethod] = case @depmeth 
								when 'C' then 'Check'
								when 'S' then 'Saving'
								when 'A' then 'ACH'
								when null then 'None'
								else @depmeth end
		, [DepositDay] = @depday 
		, [DepositAmount] = @depamt
		
	FROM tblClient AS c 
		INNER JOIN tblCompany AS co ON c.CompanyID = co.CompanyID 
		inner join tblagency as a on a.agencyid = c.agencyid
	WHERE
		(c.ClientID = @clientID)   

END



GRANT EXEC ON stp_ClientFile_getGeneralInfo TO PUBLIC
