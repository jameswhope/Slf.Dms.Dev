IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetAudioFile')
	BEGIN
		DROP  Procedure  stp_Dialer_GetAudioFile
	END

GO

CREATE Procedure stp_Dialer_GetAudioFile
@FileType varchar(255),
@CompanyId int,
@LanguageId int = null,
@ReasonId int
AS
Select Top 1 
FileName
From tblDialerAudioFile
Where FileType = @FileType
and CompanyId = @CompanyId
and LanguageId = isnull(@LanguageId, 1)   
and ReasonId = @ReasonId

GO

 
