/****** Object:  UserDefinedFunction [dbo].[Piece]    Script Date: 11/19/2007 14:49:16 ******/
DROP FUNCTION [dbo].[Piece]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Piece] ( @CharacterExpression varchar(8000), 
							   @Delimiter char(1), 
							   @Position int)

RETURNS  VARCHAR(8000)
AS
BEGIN
	IF @Position<1 RETURN NULL 
		IF LEN(@Delimiter)<>1 RETURN NULL
			DECLARE @Start INTEGER
			SET @Start=1
			
			WHILE @Position>1
			BEGIN
				SET @Start=ISNULL(CHARINDEX(@Delimiter, @CharacterExpression, @Start),0)
				IF @Start=0 RETURN NULL
				SET @position= @position-1
				SET @Start=@Start+1
			END

			DECLARE @End INTEGER

			SET @End= ISNULL(CHARINDEX(@Delimiter, @CharacterExpression, @Start),0)

			IF @End=0 SET @End=LEN(@CharacterExpression)+1

		RETURN SUBSTRING(@CharacterExpression, @Start, @End-@Start)
END
GO
