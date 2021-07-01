SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCUsersDelete]
(@PPCUserID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.PPCUsers
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  PPCUserID  = @PPCUserID
GO