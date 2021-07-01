SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_UpdateResellerPassword]
(@ResellerId uniqueidentifier, @Password nvarchar(50))
as
update  resellers
set password=@Password
where status>0
and resellerid=@ResellerId
GO