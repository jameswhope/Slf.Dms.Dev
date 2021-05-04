IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationInterfaceDefaultValues')
	BEGIN
		DROP  Procedure  stp_NegotiationInterfaceDefaultValues
	END

GO
/*
	Author: Bereket S. Data
	Description: Default Values to populate. This proc is manually run to pre-populate values before use. The values are mainly used by 
			     Structure and Criteria Assignment Interfaces

*/

CREATE Procedure stp_NegotiationInterfaceDefaultValues
AS

DECLARE @DashboardId int
INSERT INTO tblDashBoardItem
  SELECT
  '<design><div><b><sqlparam id="sql2" value="Description" /></b><br /><table style="font-family:Tahoma;font-size:11px;"><tr><td>Client Count:</td><td><sqlparam id="sql1" value="ClientCount" /><br /></td></tr><tr><td>Account Count:</td><td><sqlparam id="sql1" value="AccountCount" /><br /></td></tr><tr><td>State Count:</td><td><sqlparam id="sql1" value="StateCount" /><br /></td></tr><tr><td>Zip Code Count:</td><td><sqlparam id="sql1" value="ZipCodeCount" /><br /></td></tr><tr><td>Creditor Count:</td><td><sqlparam id="sql1" value="CreditorCount" /><br /></td></tr><tr><td>Status Count:</td><td><sqlparam id="sql1" value="StatusCount" /><br /></td></tr><tr><td>Total SDA:</td><td><sqlparam id="sql1" value="TotalSDAAmount" /><br /></td></tr></table></div></design>',
  '<sql><sqlparam id="sql1" value="exec stp_NegotiationDashboardGet ''{id}'', ''count(distinct ClientId) As ClientCount, count(AccountId) as AccountCount, count(distinct ApplicantState) as StateCount, count(distinct ApplicantZipCode) as ZipCodeCount, count(distinct CurrentCreditor) as CreditorCount, count(distinct AccountStatus) as StatusCount, ''''$'''' + cast(sum(isnull(SDABalance, 0)) as nvarchar(25)) as TotalSDAAmount''" /><sqlparam id="sql2" value="SELECT [Description] FROM tblNegotiationFilters WHERE FilterID in ({id})" isnull="NONE" /></sql>',
  null,
  null

SELECT @DashboardId = SCOPE_IDENTITY()

INSERT INTO tblDashboardPermission
 SELECT 'NegotiationInterface', null,null, @DashboardId


INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',531,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',493,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',750,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',773,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',785,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',787,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',820,0,0)
INSERT INTO tblDashboardProfile (DashboardItemId,Scenario, UserID,ClientX,ClientY) VALUES (@DashboardId,'NegotiationInterface',311,0,0)
 
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('State','ApplicantState','ApplicantState','count(ApplicantState)','sum',NULL,	NULL,1,0,1)
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('SDA Balance','SDABalance','SDABalance','sum(SDABalance)','sum',NULL,	'C',3,0,0)
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('Total Debt','CurrentAmount','CurrentAmount','sum(CurrentAmount)','sum',NULL,	'C',4,0,0)
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('Client Count','ClientID','DISTINCT ClientID','count(DISTINCT ClientID)','sum',NULL,	NULL,2,0,0)
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('Zip Code','ApplicantZipCode','substring(ApplicantZipCode, 1, 2)','count(ApplicantZipCode)','sum',NULL,	NULL,1,0,1)
INSERT INTO tblNegotiationAssignment (HeaderName,ColumnName,SQL,SQLAggregation,Aggregation,GroupedAggregation,Format,[Order],[Default],CanGroup) VALUES ('Last Name','ApplicantLastName','substring(ApplicantLastName, 1, 1)','count(ApplicantLastName)','sum',NULL,	NULL,0,1,1)
