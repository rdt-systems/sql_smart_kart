SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[RPT_InvetoryWithSale]
(@FILTER nvarchar(4000)=null,
@FromDate DateTime,
@ToDate DateTime)
AS 

--IF @FILTER is null
--BEGIN
declare @MySelect as nvarchar(4000)
SET @MySelect =
'SELECT        ItemMainAndStoreView.StoreName, ItemMainAndStoreView.StoreNumber, ItemMainAndStoreView.Name, ItemMainAndStoreView.BarcodeNumber, ItemMainAndStoreView.ModalNumber, ItemMainAndStoreView.CustomerCode, 
                         ItemMainAndStoreView.[Pc Cost], ItemMainAndStoreView.Price, ItemMainAndStoreView.Markup, ItemMainAndStoreView.Margin, ISNULL(ItemMainAndStoreView.OnHand, 0) AS OnHand, ISNULL(SaleHistory.Total, 0) 
                         AS Total, ISNULL(SaleHistory.Qty, 0) AS Qty, ItemMainAndStoreView.Department, ItemMainAndStoreView.Brand, ItemMainAndStoreView.[YTD Pc Qty] AS YTDQty, ISNULL([90Days].Last90Days, 0) AS Last90Days, 
                         ISNULL(ReceiveHistory.SumReceive, 0) AS SumReceive, ItemMainAndStoreView.ParentCode, ItemMainAndStoreView.SupplierName ,ItemMainAndStoreView.LastReceivedDate,ItemMainAndStoreView.LastReceivedQty
FROM           
                         ItemMainAndStoreView  LEFT OUTER JOIN
                             (SELECT        SUM(ReceiveEntry.Qty) AS SumReceive, ReceiveEntry.ItemStoreNo
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
                               WHERE        (ReceiveOrder.Status > 0) AND (ReceiveEntry.Status > 0) AND (dbo.GetDay(ReceiveOrder.ReceiveOrderDate) >= '''+CONVERT(nvarchar(10),@FromDate,120)+''') AND 
                                                         (dbo.GetDay(ReceiveOrder.ReceiveOrderDate) <= '''+CONVERT(nvarchar(10),@ToDate,120)+''')
                               GROUP BY ReceiveEntry.ItemStoreNo) AS ReceiveHistory ON ItemMainAndStoreView.ItemStoreID = ReceiveHistory.ItemStoreNo LEFT OUTER JOIN
                             (SELECT        SUM(QTY) AS Last90Days, ItemStoreID
                               FROM            TransactionEntryItem AS TransactionEntryItem_1
                               WHERE        (StartSaleTime > DATEADD(DAY, - 90, dbo.GetLocalDATE()))
                               GROUP BY ItemStoreID) AS [90Days] ON ItemMainAndStoreView.ItemStoreID = [90Days].ItemStoreID LEFT OUTER JOIN
                             (SELECT        ItemStoreID, SUM(TotalAfterDiscount) AS Total, SUM(QTY) AS Qty
                               FROM            TransactionEntryItem
                               WHERE        (StartSaleTime >= '''+CONVERT(nvarchar(10),@FromDate,120)+''') AND (StartSaleTime <= '''+CONVERT(nvarchar(10),@ToDate,120)+''')
                               GROUP BY ItemStoreID) AS SaleHistory ON ItemMainAndStoreView.ItemStoreID = SaleHistory.ItemStoreID
WHERE        1=1
 '

--END
print @mySelect
execute (@mySelect+@Filter)

--ELSE 
--BEGIN
--	SELECT        Store.StoreName, Store.StoreNumber, ItemMainAndStoreView.Name, ItemMainAndStoreView.BarcodeNumber, ItemMainAndStoreView.ModalNumber, 
--							 ItemMainAndStoreView.CustomerCode, ItemMainAndStoreView.[Pc Cost], ItemMainAndStoreView.Price, ItemMainAndStoreView.Markup, 
--							 ItemMainAndStoreView.Margin, ItemMainAndStoreView.OnHand, IsNull(SaleHistory.Total,0)as Total, IsNull(SaleHistory.Qty,0)As Qty
--	FROM            Store INNER JOIN
--							 ItemMainAndStoreView ON Store.StoreID = ItemMainAndStoreView.StoreNo LEFT OUTER JOIN
--								 (SELECT        ItemStoreID, SUM(Total) AS Total, SUM(QTY) AS Qty
--	FROM            TransactionEntryItem
--	WHERE        (StartSaleTime >= '''+@FromDate+''') AND (StartSaleTime <= '''+@ToDate+''')
--	GROUP BY ItemStoreID) AS SaleHistory ON ItemMainAndStoreView.ItemStoreID = SaleHistory.ItemStoreID
--  WHERE        (Store.Status = 1)
--	WHERE Store.StoreID =@StoreID   
--END
GO