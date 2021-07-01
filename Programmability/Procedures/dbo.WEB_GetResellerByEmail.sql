SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetResellerByEmail]
(@Email nvarchar(50))
as
select ResellerID from resellers
where status>0
and email=@Email
GO