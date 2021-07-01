SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountItemDelete]
(@ItemDiscountID uniqueidentifier
,@ModifierID uniqueidentifier)
AS
 UPDATE DiscountItem Set Status =-1,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
 --DELETE FROM DiscountItem WHERE [ItemDiscountID] = @ItemDiscountID
GO