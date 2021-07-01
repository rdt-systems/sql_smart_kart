SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_SaveUserLogOut]
(@userId uniqueidentifier)
AS 

update Users 
set IsLogIn = 0
where UserId=@userId
GO