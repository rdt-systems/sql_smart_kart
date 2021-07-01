SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_SavePrice]
(   
    @ItemStoreID uniqueidentifier,
	@Price money,
	@SaveToAllStores bit,
	@ModifierID UniqueIdentifier
)
AS
  Declare @ID UniqueIdentifier
  SELECT @ID = ItemNo From ItemStore Where ItemStoreID = @ItemStoreID

  IF @SaveToAllStores = 1
	Update ItemStore Set Price = @Price, UserModified = @ModifierID, DateModified = dbo.GetLocalDate() Where ItemNo = @ID
  Else
	Update ItemStore Set Price = @Price, UserModified = @ModifierID, DateModified = dbo.GetLocalDate() Where ItemStoreID = @ItemStoreID
GO