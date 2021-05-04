IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SmartDebtor_GetAgentInfoFromUserID')
	BEGIN
		DROP  Procedure  stp_SmartDebtor_GetAgentInfoFromUserID
	END
GO 

CREATE Procedure [dbo].[stp_SmartDebtor_GetAgentInfoFromUserID]
(
	@userid int
)
as
BEGIN
	/* dev
	declare @userid int
	set @userid = 443
	*/

	declare @username varchar(50)
	Select @username = username from tbluser where userid = @userid
	select ext[ParaLegalExt],fullname[ParaLegalName] from tbluserext where login = @username

END