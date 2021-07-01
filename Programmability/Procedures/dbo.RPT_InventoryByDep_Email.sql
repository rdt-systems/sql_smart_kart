SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <5/31/2015>
-- Description:	<RPT_InventoryByDep_Email>
-- =============================================

CREATE PROCEDURE [dbo].[RPT_InventoryByDep_Email]
@StoreID Uniqueidentifier = NULL

AS
BEGIN



SELECT        DEPT AS [Category Name], OnHand, TotalRetailValue AS [Total Retail Value], TotalCost AS [Total Cost]
FROM            (SELECT        1 AS No, ISNULL(ITMS.MainDepartment, '[No Department]') AS DEPT, CAST(SUM(ISNULL(ITMS.OnHand, 0)) AS int) AS OnHand, FORMAT(SUM(Totals.ExtPrice), 'C', 'en-US') AS TotalRetailValue, 
                         FORMAT(SUM(Totals.ExtCost), 'C', 'en-US') AS TotalCost
FROM            ItemMainAndStoreView AS ITMS INNER JOIN
                             (SELECT        ItemStore.ItemStoreID, ISNULL(ItemStore.OnHand,0) * ISNULL(ItemStore.Cost,0) AS ExtCost, ISNULL(ItemStore.OnHand,0) * ISNULL(ItemStore.Price,0) AS ExtPrice
                               FROM            ItemMain INNER JOIN
                                                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo Where ISNULL(OnHand,0) <> 0) AS Totals ON ITMS.ItemStoreID = Totals.ItemStoreID
WHERE        (ITMS.Status > 0) AND (ISNULL(ITMS.OnHand,0) <>0) AND (ITMS.StoreNo = @StoreID) OR
                         (ITMS.Status > 0) AND (ISNULL(ITMS.OnHand,0) <>0) AND (@StoreID IS NULL)
GROUP BY ITMS.MainDepartment
UNION
SELECT        2 AS No, 'Total' AS DEPT, CAST(SUM(ISNULL(ITMS.OnHand, 0)) AS int) AS OnHand, FORMAT(SUM(Totals.ExtPrice), 'C', 'en-US') AS TotalRetailValue, FORMAT(SUM(Totals.ExtCost), 'C', 'en-US') AS TotalCost
FROM            ItemMainAndStoreView AS ITMS INNER JOIN
                             (SELECT        ItemStore.ItemStoreID, ISNULL(ItemStore.OnHand,0) * ISNULL(ItemStore.Cost,0) AS ExtCost, ISNULL(ItemStore.OnHand,0) * ISNULL(ItemStore.Price,0) AS ExtPrice
                               FROM            ItemMain INNER JOIN
                                                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo Where ISNULL(OnHand,0) <> 0) AS Totals ON ITMS.ItemStoreID = Totals.ItemStoreID
WHERE        (ITMS.Status > 0) AND (ISNULL(ITMS.OnHand,0) <>0) AND (ITMS.StoreNo = @StoreID) OR
                         (ITMS.Status > 0) AND (ISNULL(ITMS.OnHand,0) <>0) AND (@StoreID IS NULL)) AS TR
ORDER BY No


END
GO