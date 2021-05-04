IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_enrollement_firstdeposit')
	BEGIN
		DROP  View vw_enrollement_firstdeposit
	END
GO

CREATE VIEW vw_enrollement_firstdeposit
AS
select l.leadapplicantid, c.clientid,
firstdepositdate =     case when c.initialdraftdate is not null 
				   then c.initialdraftdate
				   else (case when cl.dateoffirstdeposit = '1900-01-01' 
						then NULL
						else cl.dateoffirstdeposit
						end)
				   end   
from tblleadapplicant l 
join tblleadcalculator cl on cl.leadapplicantid = l.leadapplicantid
left join vw_leadapplicant_client vw on l.leadapplicantid = vw.leadapplicantid
left join tblclient c on c.clientid = vw.clientid

GO

 