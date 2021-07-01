SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersStoreDelete]
(@UserStoreID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
 UPDATE  dbo.UsersStore
 
SET  Status = -1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE UserStoreID = @UserStoreID
GO