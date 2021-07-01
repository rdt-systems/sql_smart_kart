SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[RPT_TotalSaleAndReceive]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)


declare @ItemSelect nvarchar(4000)
--declare @MyGroup nvarchar(4000)
declare @MyGroup1 nvarchar(4000)
declare @MyGroup2 nvarchar(4000)



Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From dbo.ItemsRepFilter 
                  Where (1=1) '


				  
SET @MySelect='SELECT        IsNull(ItemMain.Name,ItemMainAndStoreView.Name)As Name, ItemMainAndStoreView.StoreName, IsNull(ItemMainAndStoreView.BarcodeNumber,ItemMain.BarcodeNumber) As BarcodeNumber, ItemMainAndStoreView.SupplierName, ItemMainAndStoreView.Department, 
                         ItemMainAndStoreView.Groups, ItemMainAndStoreView.Matrix1, ItemMainAndStoreView.Matrix2, ItemMainAndStoreView.OnHand, ISNULL(Sale.SaleQty, 0) 
                         AS SaleQty, ISNULL(Sale.SaleTotal, 0) AS SaleTotal, ISNULL(Receive.ExtPrice, 0) AS ExtPrice, ISNULL(Receive.Qty, 0) AS Qty,  ISNULL(ItemMainAndStoreView.OnOrder,0) AS OnOrder 
FROM           ItemMainAndStoreGrid AS ItemMainAndStoreView  LEFT OUTER JOIN
                         ItemMain ON ItemMainAndStoreView.LinkNo = ItemMain.ItemID LEFT OUTER JOIN
(SELECT ItemStoreNo, SUM(Qty) AS Qty, SUM(ExtPrice) AS ExtPrice
  FROM  ReceveHistoryView WHERE 1=1'

SET @MyGroup1 ='GROUP BY ItemStoreNo) AS Receive ON ItemMainAndStoreView.ItemStoreID = Receive.ItemStoreNo LEFT OUTER JOIN
 (SELECT        ItemStoreID, SUM(Qty) AS SaleQty, SUM(Total) AS SaleTotal
 FROM            TransactionEntryItem WHERE 1=1 ' 

SET @MyGroup2 ='GROUP BY ItemStoreID) AS Sale ON ItemMainAndStoreView.ItemStoreID = Sale.ItemStoreID'

SET @MyWhere=	' where (1=1) And exists (Select 1 From #ItemSelect where ItemStoreID=ItemMainAndStoreView.ItemStoreID)'

--SET @MyGroup ='GROUP BY BarcodeNumber, Matrix1, Matrix2,  Department, Groups, ParentName, SupplierName, Sales.SaleQty '

PRINT(@ItemSelect + @ItemFilter + @MySelect + @Filter + @MyGroup1 + @Filter + @MyGroup2 +@MyWhere)
Execute (@ItemSelect + @ItemFilter + @MySelect + @Filter + @MyGroup1 + @Filter + @MyGroup2 +@MyWhere)

drop table #ItemSelect
GO