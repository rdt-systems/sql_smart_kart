SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountGroupEntryDelete]
(@DiscountGroupEntryID uniqueidentifier,
 @ModifierID uniqueidentifier)
AS Update
 dbo.DiscountGroupEntry
   Set Status=-1,DateModified = dbo.GetLocalDATE()

WHere DiscountGroupEntryID = @DiscountGroupEntryID
GO