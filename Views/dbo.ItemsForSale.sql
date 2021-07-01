SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemsForSale]
AS
SELECT        ItemStoreID, SalePrice, Price, CASE WHEN SalePrice > 0 THEN SalePrice ELSE Price END AS RealPrice
FROM            (SELECT DISTINCT 
                                                    ItemStoreView.ItemStoreID, CAST(ISNULL(CASE WHEN (ItemStoreView.SaleType IN (1, 5, 12)) THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) 
                                                    > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                                                    THEN ItemStoreView.SalePrice END ELSE ItemStoreView.SalePrice END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND 
                                                    (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                                                    (ISNULL(ItemStoreView.AssignDate, 0) = 0)) AND ISNULL(ItemStoreView.SpecialPrice, 0) > 0 AND ISNULL(ItemStoreView.SpecialBuy, 0) 
                                                    > 0 THEN (ItemStoreView.SpecialPrice / ItemStoreView.SpecialBuy) WHEN ItemStoreView.SaleType = 3 AND ISNULL(MixAndMatchView.Amount, 0) > 0 AND ISNULL(MixAndMatchView.Qty, 0) 
                                                    > 0 THEN (MixAndMatchView.Amount / MixAndMatchView.Qty) WHEN (ItemStoreView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND 
                                                    (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                                                    (ISNULL(ItemStoreView.AssignDate, 0) = 0)) AND ISNULL(ItemStoreView.SpecialPrice, 0) > 0 AND ISNULL(ItemStoreView.SpecialBuy, 0) 
                                                    > 0 THEN (ItemStoreView.SpecialPrice / ItemStoreView.SpecialBuy) WHEN (ItemSpecialView.SaleType IN (1, 5, 12)) THEN CASE WHEN ISNULL(ItemSpecialView.AssignDate, 0) 
                                                    > 0 THEN CASE WHEN (dbo.GetDay(ItemSpecialView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                                                    THEN ItemSpecialView.SalePrice END ELSE ItemSpecialView.SalePrice END WHEN (ItemSpecialView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemSpecialView.AssignDate, 0) > 0) AND 
                                                    (dbo.GetDay(ItemSpecialView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                                                    (ISNULL(ItemSpecialView.AssignDate, 0) = 0)) AND ISNULL(ItemSpecialView.SpecialPrice, 0) > 0 AND ISNULL(ItemSpecialView.SpecialBuy, 0) 
                                                    > 0 THEN (ItemSpecialView.SpecialPrice / ItemSpecialView.SpecialBuy) WHEN (ItemSpecialView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemSpecialView.AssignDate, 0) > 0) AND 
                                                    (dbo.GetDay(ItemSpecialView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                                                    (ISNULL(ItemSpecialView.AssignDate, 0) = 0)) AND ISNULL(ItemSpecialView.SpecialPrice, 0) > 0 AND ISNULL(ItemSpecialView.SpecialBuy, 0) 
                                                    > 0 THEN (ItemSpecialView.SpecialPrice / ItemSpecialView.SpecialBuy) END, 0) AS money) AS SalePrice, ItemStoreView.Price
                          FROM            ItemMainView INNER JOIN
                                                    ItemStoreView ON ItemMainView.ItemID = ItemStoreView.ItemNo LEFT OUTER JOIN
                                                    MixAndMatchView ON ItemStoreView.MixAndMatchID = MixAndMatchView.MixAndMatchID LEFT OUTER JOIN
                                                    ItemSpecialView ON ItemStoreView.ItemStoreID = ItemSpecialView.ItemStoreID) AS TR
GO