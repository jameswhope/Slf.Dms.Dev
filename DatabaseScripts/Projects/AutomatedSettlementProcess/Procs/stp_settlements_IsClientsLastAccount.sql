IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_IsClientsLastAccount')
	BEGIN
		DROP  Procedure  stp_settlements_IsClientsLastAccount
	END

GO

CREATE Procedure stp_settlements_IsClientsLastAccount
	(
		@clientid int
	)

AS
BEGIN
	if exists(
	SELECT c.clientid
	FROM
		tblAccount AS a
	INNER JOIN tblClient AS c
		ON a.ClientID = c.ClientID
	WHERE
		(c.clientid = @clientid)
		AND (a.AccountStatusID IS NULL
		OR a.AccountStatusID NOT IN (54, 55))
	group by c.clientid having count(*) = 1)
		BEGIN
		SELECT 1
		END
	ELSE
		BEGIN
		SELECT 0
		END	
END

GO


GRANT EXEC ON stp_settlements_IsClientsLastAccount TO PUBLIC

GO


