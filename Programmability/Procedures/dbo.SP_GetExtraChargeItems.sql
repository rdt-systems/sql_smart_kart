SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetExtraChargeItems]
(
@StoreID uniqueidentifier)
AS 
SELECT     Name, BarcodeNumber, ItemStoreID, Price
FROM         ItemMainAndStoreGrid
WHERE     (StoreNo = @StoreID) AND (ItemType = 5) AND (Status > 0)
GO