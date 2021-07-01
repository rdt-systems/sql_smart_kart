SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RestockingStores1]  
(  
@Filter nvarchar(4000)='',
@ItemFilter nvarchar(4000)='',  
@FromDate Datetime,  
@ToDate Datetime  
)  
as  
  
  exec tolog @Filter 
declare @MySelect nvarchar(4000)  
declare @MyWhere nvarchar(4000)  
Declare @MyGroupBy nvarchar(4000)  
  
declare @ItemSelect nvarchar(4000)  
Set  @ItemSelect='Select Distinct ItemStoreID   
      Into #ItemSelect   
                  From ItemsRepFilter   
                  Where (1=1) '  
  
set @MySelect= 'SELECT        Store.StoreID, Store.StoreName, ItemMain.Name, ItemMain.BarcodeNumber AS SKU, 
ItemMain.ModalNumber, ItemStore.ItemStoreID, ItemStore.ItemNo, ItemStore.OnHand,
ItemStore.ReorderPoint, ItemStore.RestockLevel,   
                         IsNull(Sales.SumQty,0)as SumQty  
FROM            Store INNER JOIN  
                         ItemStore ON Store.StoreID = ItemStore.StoreNo INNER JOIN  
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID 
						 LEFT OUTER JOIN  
                             (SELECT        SUM(TransactionEntry.Qty) AS SumQty, TransactionEntry.ItemStoreID  
                               FROM            [Transaction] INNER JOIN  
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID  
                               WHERE        ([Transaction].StartSaleTime >'''+CONVERT(VARCHAR(20),@FromDate,20)+''' ) AND ([Transaction].StartSaleTime <'''+CONVERT(VARCHAR(20),@ToDate+1,20)+''' ) AND ([Transaction].Status > 0) AND   
                                                         (TransactionEntry.Status > 0)  
                               GROUP BY TransactionEntry.ItemStoreID) AS Sales ON ItemStore.ItemStoreID = Sales.ItemStoreID  
 where  exists (Select 1 From #ItemSelect where #ItemSelect.ItemStoreID= ItemStore.ItemStoreID)  
 AND Store.Status>0 AND ItemMain.Status>0  
 ORDER BY NAME,StoreName'    
  
  
  
PRINT (@ItemSelect + @ItemFilter + @Filter +  @MySelect )  
  
Execute (@ItemSelect + @ItemFilter + @Filter+  @MySelect )
GO