IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_insertdocument')
	BEGIN
		DROP  Procedure  stp_lexxsign_insertdocument
	END

GO

CREATE PROCEDURE stp_lexxsign_insertdocument
(
@ClientID                            int,
@DocumentId                          varchar(50),
@SigningBatchID						 varchar(50),
@SubmittedBy                         int,
@SignatoryEmail                      varchar(75),
@CurrentStatus                       varchar(50),
@DocumentTypeID                      varchar(10),
@RelationTypeID                      int,
@RelationID                          int
)
AS
BEGIN
   --Insert new row
	INSERT INTO tblLexxSignDocs(ClientID,DocumentId,Submitted,SubmittedBy,SignatoryEmail,SigningBatchID,CurrentStatus,DocumentTypeID,RelationTypeID,RelationID)
	VALUES(@ClientID,@DocumentId,getdate(),@SubmittedBy,@SignatoryEmail,@SigningBatchID,@CurrentStatus,@DocumentTypeID,@RelationTypeID,@RelationID)
END

