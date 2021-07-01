SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[MoveCharacter](@d varchar(max))
RETURNS  varchar(max)  AS  
BEGIN 
return  Substring(@d,len(@d),1)  + Substring (@d,0,len(@d))

END
GO