/****** Object:  StoredProcedure [dbo].[stp_AgencyUpdateDetail]    Script Date: 11/19/2007 15:26:53 ******/
DROP PROCEDURE [dbo].[stp_AgencyUpdateDetail]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_AgencyUpdateDetail]
(
	@agentId int,
	@Location varchar(60),
	@ContactName varchar(50),
	@Address varchar(50),
	@AptSuite varchar(50),
	@City varchar(50),
	@State varchar(2),
	@Zip varchar(11),
	@HPhone varchar(50),
	@OPhone varchar(50),
	@CPhone varchar(50),
	@APhone varchar(50),
	@Fax varchar(50),
	@Pager varchar(50),
	@EMail varchar(50),
	@SSNTIN varchar(15),
	@LoginId varchar(50),
	@IsActive bit,
	@CheckNo int,
	@IsAttorney bit,
	@EnrollPer float(8),
	@MaintPer float(8),
	@SettPer float(8),
	@DMSEnrollPer float(8),
	@DMSMaintPer float(8),
	@DMSSettPer float(8)
)

AS

SET NOCOUNT ON

UPDATE SalesAgentHdr SET
	Location=@Location,
	ContactName=@ContactName,
	Address=@Address,
	AptSuite=@AptSuite,
	City=@City,
	State=@State,
	Zip=@Zip,
	HPhone=@HPhone,
	OPhone=@OPhone,
	CPhone=@CPhone,
	APhone=@APhone,
	Fax=@Fax,
	Pager=@Pager,
	EMail=@EMail,
	SSNTIN=@SSNTIN,
	LoginId=@LoginId,
	Suspend = CASE @IsActive
		WHEN 0 THEN 'Y'
		ELSE 'N'	
		END,
	CheckNo=@CheckNo,
	IsAttorney=@IsAttorney,
	EnrollPer=@EnrollPer,
	MaintPer=@MaintPer,
	SettPer=@SettPer,
	DMSEnrollPer=@DMSEnrollPer,
	DMSMaintPer=@DMSMaintPer,
	DMSSettPer=@DMSSettPer
WHERE
	SalesAgentHdr_Id=@agentId
GO
