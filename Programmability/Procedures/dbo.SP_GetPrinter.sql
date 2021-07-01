SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrinter]
(@Feild nvarchar(50),
@Filter Nvarchar(4000))
as

Exec ('SELECT ' + @Feild +
	  ' FROM dbo.Computers
	   WHERE Status>-1 AND ' + @Filter )
GO