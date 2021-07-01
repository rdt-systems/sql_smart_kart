SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <3/28/2016>
-- Description:	<Get items not in store but in other location>
-- =============================================
CREATE PROCEDURE [dbo].[SP_NotInstoreInventory](
	@Store Uniqueidentifier,
	@Wherhouse Uniqueidentifier = NULL)
AS
BEGIN
IF @Wherhouse IS NULL
BEGIN
SELECT     ITMS.Department,   ITMS.Name AS ItemName, ITMS.ModalNumber AS ModelNumber, ITMS.BarcodeNumber AS UPC, ITMS.[Supplier Item Code], ITMS.SupplierName, ITMS.MainSupplierID, ITMS.OnHand, 
                         notStore.WarehouseOnHand, ISNULL(Sales.Sold, 0) AS QtySold
FROM            ItemMainAndStoreGrid AS ITMS INNER JOIN
                             (SELECT        ItemNo AS ItemID, SUM(ISNULL(OnHand, 0)) AS WarehouseOnHand
                               FROM            ItemStore
                               WHERE        (Status > 0) AND (StoreNo <> @Store)
                               GROUP BY ItemNo) AS notStore ON ITMS.ItemNo = notStore.ItemID LEFT OUTER JOIN
                             (SELECT        ItemMainAndStoreGrid.ItemID, SUM(TransactionEntry.Qty) AS Sold
                               FROM            TransactionEntry INNER JOIN
                                                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID INNER JOIN
                                                         ItemMainAndStoreGrid ON TransactionEntry.ItemStoreID = ItemMainAndStoreGrid.ItemStoreID
                               WHERE        (TransactionEntry.Status > 0) AND ([Transaction].Status > 0) AND ([Transaction].StartSaleTime >= DATEADD(mm, - 3, dbo.GetLocalDATE()))
                               GROUP BY ItemMainAndStoreGrid.ItemID) AS Sales ON ITMS.ItemNo = Sales.ItemID
WHERE        (ITMS.Status > 0) AND (ITMS.StoreNo = @Store) AND (ITMS.OnHand <= 0) AND (notStore.WarehouseOnHand > 0)
ORDER BY QtySold DESC
END

ELSE BEGIN
SELECT      ITMS.Department,   ITMS.Name AS ItemName, ITMS.ModalNumber AS ModelNumber, ITMS.BarcodeNumber AS UPC, ITMS.[Supplier Item Code], ITMS.SupplierName, ITMS.MainSupplierID, ITMS.OnHand, 
                         notStore.WarehouseOnHand, ISNULL(Sales.Sold, 0) AS QtySold
FROM            ItemMainAndStoreGrid AS ITMS INNER JOIN
                             (SELECT        ItemNo AS ItemID, SUM(ISNULL(OnHand, 0)) AS WarehouseOnHand
                               FROM            ItemStore
                               WHERE        (Status > 0) AND (StoreNo = @Wherhouse)
                               GROUP BY ItemNo) AS notStore ON ITMS.ItemNo = notStore.ItemID LEFT OUTER JOIN
                             (SELECT        ItemMainAndStoreGrid.ItemID, SUM(TransactionEntry.Qty) AS Sold
                               FROM            TransactionEntry INNER JOIN
                                                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID INNER JOIN
                                                         ItemMainAndStoreGrid ON TransactionEntry.ItemStoreID = ItemMainAndStoreGrid.ItemStoreID
                               WHERE        (TransactionEntry.Status > 0) AND ([Transaction].Status > 0) AND ([Transaction].StartSaleTime >= DATEADD(mm, - 3, dbo.GetLocalDATE()))
                               GROUP BY ItemMainAndStoreGrid.ItemID) AS Sales ON ITMS.ItemNo = Sales.ItemID
WHERE        (ITMS.Status > 0) AND (ITMS.StoreNo = @Store) AND (ITMS.OnHand <= 0) AND (notStore.WarehouseOnHand > 0)
ORDER BY QtySold DESC
END
END
GO