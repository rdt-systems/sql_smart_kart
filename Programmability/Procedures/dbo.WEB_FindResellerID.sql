SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_FindResellerID]
(@Domain nvarchar(50))

	
AS
	select resellerid from resellers
	where status>0
	and domainname=@Domain
GO