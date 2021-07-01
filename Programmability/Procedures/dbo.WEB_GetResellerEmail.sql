SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetResellerEmail] 
	(@ResellerID uniqueidentifier)
AS
select email from resellers
where status>0
and resellerid=@ResellerID
GO