SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerToGroupDelete]
(@CustomerToGroupID uniqueidentifier,
@ModifierID uniqueidentifier)
AS Update
 dbo.CustomerToGroup
   Set Status=-1,DateModified = dbo.GetLocalDATE()

WHere CustomerToGroupID = @CustomerToGroupID
GO