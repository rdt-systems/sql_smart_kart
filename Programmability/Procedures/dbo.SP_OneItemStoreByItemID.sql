SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_OneItemStoreByItemID](@ItemID uniqueidentifier,
@StoreID uniqueidentifier)
AS


SELECT     dbo.ItemStoreView.*
FROM       dbo.ItemStoreView
WHERE     (ItemNo = @ItemID) AND (StoreNo = @StoreID)
GO