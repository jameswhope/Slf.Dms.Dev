IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetClientPhoneNumbers')
	BEGIN
		DROP  Procedure  stp_Dialer_GetClientPhoneNumbers
	END

GO

CREATE Procedure stp_Dialer_GetClientPhoneNumbers
@ClientId int
AS
Begin

Select h.phoneId, h.phonetypeid, isnull(t.name,'other') as phonetype, h.areacode + h.number as phonenumber, p.clientid, 
relationship = case p.relationship when 'prime' then 1
when 'spouse' then 2
else 3 end
from tblpersonphone pp
inner join tblphone h on h.phoneId = pp.phoneid
inner join tblperson p on p.personid = pp.personid
left join tblphonetype t on t.phonetypeid = h.phonetypeid
where clientid = @ClientId
--and t.phonetypeid in (27,28,31,35)
and t.phonetypeid not in (23,29,33)
and h.excludefromdialer = 0
and isnull(p.isdeceased,0)= 0
order by 6

End

GO

