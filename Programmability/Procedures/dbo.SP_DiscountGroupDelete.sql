SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountGroupDelete]
(@DiscountGroupID uniqueidentifier,
 @ModifierID uniqueidentifier)
AS Update
 dbo.DiscountGroup
   Set Status=-1,DateModified = dbo.GetLocalDATE()

WHere DiscountGroupID = @DiscountGroupID
GO