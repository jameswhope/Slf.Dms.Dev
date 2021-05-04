DROP PROCEDURE [dbo].[stp_LetterTemplates_getPracticingStates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_LetterTemplates_getPracticingStates]
(
	@companyid int
)

AS

Select
	xcs.StateId, 
	s.Abbreviation, 
	s.Name
From
	tblXref_Company_State xcs
	join tblState s on s.stateID = xcs.StateId
Where
	xcs.CompanyID = @companyid and Accepting = 1
