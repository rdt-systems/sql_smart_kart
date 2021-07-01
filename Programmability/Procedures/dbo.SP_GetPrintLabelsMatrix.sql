SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPrintLabelsMatrix]
(@StoreID uniqueidentifier,
 @MatrixID  uniqueidentifier)
AS


SELECT        NEWID() AS PrintLabelsID, ItemMainAndStoreView.ItemStoreID, 1 AS Tag, 1 AS Status, 'A02C3E69-E1E0-4D63-A85D-4B9ABC9B8D1B' AS UserCreated, ItemMainAndStoreView.BarcodeNumber, 
                         ItemMainAndStoreView.ModalNumber, ItemMainAndStoreView.Name, 1 AS Qty, OnHand
FROM                                    ItemMainAndStoreView
WHERE        (ItemMainAndStoreView.StoreNo = @StoreID) AND (LinkNo =@MatrixID)
GO