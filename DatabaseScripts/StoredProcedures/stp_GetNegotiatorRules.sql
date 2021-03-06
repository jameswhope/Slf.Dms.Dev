/****** Object:  StoredProcedure [dbo].[stp_GetNegotiatorRules]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetNegotiatorRules]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_GetNegotiatorRules]

AS

if exists (select * from tblrulenegotiation) begin
	select 
		u.userid,
		rangestart,
		rangeend,
		u.firstname + ' ' + u.lastname as fullname
	from
		tblrulenegotiation rn inner join
		tbluser u on rn.userid=u.userid
end else begin
	select
		u.userid,
		'' as rangeend,
		'' as rangestart,
		u.firstname + ' ' + u.lastname as fullname
	from
		tbluser u inner join 
		tbluserposition up on u.userid=up.userid 
	where 
		up.positionid=4
end
GO
