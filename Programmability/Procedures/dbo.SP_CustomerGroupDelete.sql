SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerGroupDelete]
(@CustomerGroupID uniqueidentifier,
@ModifierID uniqueidentifier)
AS Update
 dbo.CustomerGroup
   Set Status=-1,DateModified = dbo.GetLocalDATE()

WHere CustomerGroupID = @CustomerGroupID
GO