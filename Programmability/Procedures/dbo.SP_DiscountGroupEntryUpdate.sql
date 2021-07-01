SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/19/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountGroupEntryUpdate]
	(@DiscountGroupEntryID uniqueidentifier,
	 @DiscountGroupID uniqueidentifier ,
	 @DiscountID uniqueidentifier ,
	 @Status int=1,
	 @ModifierID uniqueidentifier)
AS
BEGIN
   UPDATE    DiscountGroupEntry
SET              DiscountGroupID =@DiscountGroupID, DiscountID =@DiscountID, UserModified =@ModifierID, DateModified =dbo.GetLocalDATE(), Status =@Status
  	WHERE DiscountGroupEntryID =@DiscountGroupEntryID  
	
END
GO