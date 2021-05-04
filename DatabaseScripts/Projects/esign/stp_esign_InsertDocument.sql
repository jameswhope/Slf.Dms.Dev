IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_esign_InsertDocument')
	BEGIN
		DROP  Procedure  stp_esign_InsertDocument
	END

GO

CREATE Procedure stp_esign_InsertDocument
(
@LeadApplicantID int
,@DocumentId varchar(50)
,@Submitted datetime
,@SubmittedBy int
,@SignatoryEmail varchar(75)
,@CurrentStatus varchar(50)
,@Completed datetime
,@DocumentTypeID int
,@SigningBatchID varchar(50)
,@SigningIPAddress varchar(50)
)
as
BEGIN

INSERT INTO [tblLeadDocuments]
([LeadApplicantID],[DocumentId],[Submitted],[SubmittedBy],[SignatoryEmail],[CurrentStatus],[Completed],[DocumentTypeID],[SigningBatchID],[SigningIPAddress])
VALUES
(
@LeadApplicantID 
,@DocumentId
,@Submitted 
,@SubmittedBy 
,@SignatoryEmail
,@CurrentStatus 
,@Completed 
,@DocumentTypeID 
,@SigningBatchID 
,@SigningIPAddress 
)

END


GRANT EXEC ON stp_esign_InsertDocument TO PUBLIC

GO


