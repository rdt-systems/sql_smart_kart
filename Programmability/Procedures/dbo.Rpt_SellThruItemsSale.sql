SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt_SellThruItemsSale]
(@Filter nvarchar(4000),
 @FromDate DateTime,
 @ToDate DateTime)
as
declare @MySelect nvarchar(3000)
declare @MyGroup nvarchar(3000)


SET @MySelect ='SELECT    TransactionEntryItem.Name, TransactionEntryItem.BarcodeNumber AS SKU, TransactionEntryItem.ModalNumber, SUM(TransactionEntryItem.ExtCost) AS ExtCost, 
                         SUM(TransactionEntryItem.TotalAfterDiscount) AS TotalAfterDiscount, SUM(TransactionEntryItem.Profit) AS Profit, SUM(TransactionEntryItem.Total) AS ExtSale, 
                         SUM(TransactionEntryItem.QTY) AS SaleQty, TransactionEntryItem.Department, TransactionEntryItem.OnHand, TransactionEntryItem.StoreName, 
                         TransactionEntryItem.SupplierCode, TransactionEntryItem.Supplier, (CASE WHEN (IsNull(FnGetItemOnHand.Qty, 0) > 0 AND ISNULL(SUM(TransactionEntryItem.QTY), 
                         0) > 0) THEN ((100/(FnGetItemOnHand.Qty + SUM(TransactionEntryItem.QTY))*SUM(TransactionEntryItem.QTY)) / 100) ELSE 0 END) AS SellThru ,FnGetItemOnHand.Qty,
                         TransactionEntryItem.ParentCode 
FROM            TransactionEntryItem LEFT OUTER JOIN
                         dbo.FnGetItemOnhand('''+CONVERT(VARCHAR, @ToDate, 23)+''') AS FnGetItemOnhand ON TransactionEntryItem.ItemStoreID = FnGetItemOnhand.ItemStoreID
						 Where (dbo.getday(StartSaleTime) >='''+CONVERT(VARCHAR, .dbo.getDay(@FromDate), 23)+''') AND  (dbo.getday(StartSaleTime) <='''+CONVERT(VARCHAR, @ToDate, 23)+''')'

set @MyGroup ='GROUP BY TransactionEntryItem.Name, TransactionEntryItem.BarcodeNumber, TransactionEntryItem.ModalNumber, TransactionEntryItem.Department, 
                         TransactionEntryItem.OnHand, TransactionEntryItem.StoreName, TransactionEntryItem.SupplierCode, TransactionEntryItem.Supplier,FnGetItemOnHand.Qty, 
                         TransactionEntryItem.ParentCode'

print (@MySelect +@Filter+@MyGroup)

exec(@MySelect +@Filter+@MyGroup)
GO