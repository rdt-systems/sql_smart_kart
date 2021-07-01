SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAllUsersStoreView]
( @refreshTime  datetime output)
AS SELECT     dbo.UsersStoreView.*
FROM         dbo.UsersStoreView
WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
GO