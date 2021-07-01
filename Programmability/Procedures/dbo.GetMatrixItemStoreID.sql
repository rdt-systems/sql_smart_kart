SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[GetMatrixItemStoreID]
 (@ItemStoreID  uniqueidentifier,
 @StoreID uniqueidentifier)

as

Select ItemStoreID 
             FROM ItemMain inner Join 
             ItemStore On ItemNo=ItemID and StoreNo = @StoreID
             Where  ItemID=(Select LinkNo
                            From ItemMain 
                            where ItemID=
                           (Select ItemNo from ItemStore Where ItemStoreID=@ItemStoreID))
GO