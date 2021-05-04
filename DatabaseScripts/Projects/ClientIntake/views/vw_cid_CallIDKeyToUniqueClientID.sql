IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_cid_CallIDKeyToUniqueClientID')
	BEGIN
		DROP  View vw_cid_CallIDKeyToUniqueClientID
	END
GO

CREATE View vw_cid_CallIDKeyToUniqueClientID AS

	/*Select column from table where */
select * 
from(
Select callidkey,[UniqueClientID]=ClientID From tblCallClient  with(readpast)
union 
Select callidkey,[UniqueClientID]=ClientID From tblDialerCall  with(readpast)
union 
Select callidkey,[UniqueClientID]=LeadApplicantID From tblLeadApplicant  with(readpast)
union 
Select callidkey,[UniqueClientID]=LeadApplicantID From tblLeadCall  with(readpast)
union 
Select callidkey,[UniqueClientID]=LeadApplicantID From tblLeadDialerCall  with(readpast)
union 
Select callidkey,[UniqueClientID]=ClientID From tblVerificationCall with(readpast)
) as sData
where callidkey is not null and [UniqueClientID] is not null 

GO


GRANT SELECT ON vw_cid_CallIDKeyToUniqueClientID TO PUBLIC

GO

