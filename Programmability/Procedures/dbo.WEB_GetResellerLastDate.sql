SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetResellerLastDate]
(@ResellerID uniqueidentifier)
AS
	select lastregistereddate
	from resellers
	where status>0
	and resellerid=@ResellerID
GO