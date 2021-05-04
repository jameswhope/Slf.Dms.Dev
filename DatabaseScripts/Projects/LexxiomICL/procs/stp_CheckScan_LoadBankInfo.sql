IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_LoadBankInfo')
	BEGIN
		DROP  Procedure  stp_CheckScan_LoadBankInfo
	END

GO 

CREATE Procedure [dbo].[stp_CheckScan_LoadBankInfo]
AS
SELECT     
[ICLBankID]=NACHABankID
, BankName
, ICLFileLocation
, ICLImmediateOrigin
, ICLOriginContactPhoneNumber
, ICLContactname
, ICLConnectionString
, ICLftpControlPort
, ICLftpFolder
, ICLUserName
, ICLftpPassword
, ICLLogPath
, ICLLogFile
, ICLBankClientID
, ICLCustomerID
, ICLInputFileTransmissionID
, ICLReceiptAckTransmissionID
, ICLAdjustmentAckTransmission
, ICLLocationName
, ICLAccountNumber
, ICLACKPassword
, ICLRECPassword
, ICLftpServer
, ICLftpPort
, ICLImmediateDestinationRouting
, ICLImmediateOriginRouting
, [ICLImmediateDestinationName]=ImmediateDestinationName
FROM         tblBank_NACHA


GRANT EXEC ON stp_CheckScan_LoadBankInfo TO PUBLIC