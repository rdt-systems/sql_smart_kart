SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderToDiscountInsert]
(@TenderToDiscountID uniqueidentifier,
@DiscountID uniqueidentifier,
@TenderID int,
@ModifierID uniqueidentifier,
@Status smallint)
AS INSERT INTO dbo.TenderToDiscount
                      (TenderToDiscountID, DiscountID,TenderID, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@TenderToDiscountID, @DiscountID,@TenderID, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO