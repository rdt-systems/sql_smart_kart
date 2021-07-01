SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <3/28/2016>
-- Description:	<Get items not in store but in other location>
-- =============================================
CREATE PROCEDURE [dbo].[SP_OutOfStock]

AS
BEGIN


SELECT  DISTINCT   ITMS.Department,    ITMS.Name AS ItemName, ITMS.ModalNumber AS ModelNumber, ITMS.BarcodeNumber AS UPC, ITMS.[Supplier Item Code], ITMS.SupplierName, Stock.TotalStock, ISNULL(Sales.Sold, 0) AS QtySold
FROM            ItemMainAndStoreGrid AS ITMS INNER JOIN
                             (SELECT        ItemNo AS ItemID, SUM(ISNULL(OnHand, 0)) AS TotalStock
                               FROM            ItemStore
                               WHERE        (Status > 0)
                               GROUP BY ItemNo) AS Stock ON ITMS.ItemNo = Stock.ItemID INNER JOIN
                             (SELECT        ItemMainAndStoreGrid.ItemID, SUM(TransactionEntry.Qty) AS Sold
                               FROM            TransactionEntry INNER JOIN
                                                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID INNER JOIN
                                                         ItemMainAndStoreGrid ON TransactionEntry.ItemStoreID = ItemMainAndStoreGrid.ItemStoreID
                               WHERE        (TransactionEntry.Status > 0) AND ([Transaction].Status > 0) AND ([Transaction].StartSaleTime >= DATEADD(mm, - 3, dbo.GetLocalDATE()))
                               GROUP BY ItemMainAndStoreGrid.ItemID) AS Sales ON ITMS.ItemNo = Sales.ItemID
WHERE        (ITMS.Status > 0) AND (Stock.TotalStock <= 0) AND (ISNULL(Sales.Sold, 0) > 0)
ORDER BY QtySold DESC
END
GO