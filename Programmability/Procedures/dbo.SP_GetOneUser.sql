SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetOneUser]
(@ID uniqueidentifier,
@StoreID uniqueidentifier)

AS

SELECT     dbo.UsersView.*
FROM         dbo.UsersView
WHERE     (UserID = @ID) AND (StoreID = @StoreID)
GO