IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetCustomAni_CID')
	BEGIN
		DROP  Procedure  stp_Vici_GetCustomAni_CID
	END

GO

CREATE Procedure stp_Vici_GetCustomAni_CID
@PhoneNumber varchar(20)
AS
begin
	Declare @CustomAni varchar(20) Set @CustomANI = ''
	
	Select @CustomANI = DID From tblLeadAreaCodeDID Where AreaCode = left(ltrim(rtrim(isnull(@Phonenumber,''))),3)
	
	Select CustomANI = @CustomANI
End

GO



