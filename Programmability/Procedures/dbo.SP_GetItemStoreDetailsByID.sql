SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemStoreDetailsByID](@ItemID uniqueidentifier)
AS SELECT    [Name], OnHand, BarcodeNumber, CAST(Price AS decimal(18, 2)) AS price, ItemID
FROM         dbo.ItemMainAndStoreView
WHERE     (ItemID = @ItemID)
GO