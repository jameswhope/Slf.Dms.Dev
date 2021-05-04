IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CleanupCreditor_DeleteCreditorPhone')
	BEGIN
		DROP  Procedure  stp_CleanupCreditor_DeleteCreditorPhone
	END

GO

CREATE Procedure stp_CleanupCreditor_DeleteCreditorPhone
@CreditorId int
AS
BEGIN

--tblPhone
delete from tblphone where phonetypeid not in (57,58) and phoneid in 
	(select phoneid from tblcreditorphone
	 where creditorid = @CreditorId
	 and phoneid not in 
		(Select phoneid from tblcreditorphone where  creditorid <> @creditorid
		union
		select phoneid from tblcontactphone
		union
		select phoneid from tblagencyphone
		union
		select phoneid from tblagentphone
		union
		select phoneid from tblpersonphone
		)
	)

--tblCreditorPhones
Delete from tblCreditorPhone
Where CreditorId = @CreditorId
and phoneid not in (select phoneid from tblphone where phonetypeid in (57,58))

END
GO

