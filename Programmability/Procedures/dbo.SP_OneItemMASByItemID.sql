SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_OneItemMASByItemID](@ItemID uniqueidentifier,
@StoreID uniqueidentifier)
AS


SELECT     dbo.ItemMainAndStoreGrid.*
FROM       dbo.ItemMainAndStoreGrid
WHERE     (ItemID = @ItemID) AND (StoreNo = @StoreID)
GO