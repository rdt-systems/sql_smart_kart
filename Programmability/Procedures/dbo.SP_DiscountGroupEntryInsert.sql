SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <3/19/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountGroupEntryInsert]
	(@DiscountGroupEntryID uniqueidentifier,
	 @DiscountGroupID uniqueidentifier ,
	 @DiscountID uniqueidentifier ,
	 @Status int=1,
	 @ModifierID uniqueidentifier,
	@DateCreated datetime = NULL,
 @UserCreated uniqueidentifier =NULL,
 @DateModified dateTime =NULL,
 @UserModified uniqueidentifier =NULL)
AS
BEGIN
INSERT INTO DiscountGroupEntry
                      (DiscountGroupEntryID, DiscountGroupID, DiscountID, Status, UserCreated, DateCreated, DateModified, UserModified)
VALUES     (@DiscountGroupEntryID,@DiscountGroupID,@DiscountID,@Status,@ModifierID, dbo.GetLocalDATE(), dbo.GetLocalDATE(),@ModifierID)
	
END
GO