SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetOneUserStore]
(@ID uniqueidentifier,
@StoreID uniqueidentifier)

AS

SELECT     dbo.UsersStore.*
FROM         dbo.UsersStore
WHERE     (UserID = @ID) AND (StoreID = @StoreID)
GO