SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UsersDelete]
(@UserID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
 UPDATE  dbo.Users
            SET     Status = -1,  DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE UserID = @UserID
GO