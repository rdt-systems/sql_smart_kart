SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RestockingStores]    
(    
@Filter nvarchar(max)='',  
@ItemFilter nvarchar(max)='',    
@FromDate Datetime,    
@ToDate Datetime    
)    
as    
    
  exec tolog @Filter   
declare @MySelect nvarchar(max)    
declare @MyWhere nvarchar(max)    
Declare @MyGroupBy nvarchar(max)    
    
declare @ItemSelect nvarchar(max)    
Set  @ItemSelect='Select Distinct ItemNo     
      Into #ItemSelect     
                  From ItemsRepFilter     
                  Where (1=1) '    
    
set @MySelect= 'SELECT        Store.StoreID, Store.StoreName, ItemMain.Name, ItemMain.BarcodeNumber AS SKU,  
ItemMain.ModalNumber, ItemStore.ItemStoreID, ItemStore.ItemNo, ISNULL(ItemStore.OnHand,0) AS OnHand,  
ISNULL(ItemStore.ReorderPoint,0) AS ReorderPoint, ISNULL(ItemStore.RestockLevel,0) AS RestockLevel, Req.LastRequested AS LastFulfilled,      
                         IsNull(Sales.SumQty,0)as SumQty, ItemMain.ModalNumber    
FROM            Store INNER JOIN    
                         ItemStore ON Store.StoreID = ItemStore.StoreNo INNER JOIN    
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID   
       LEFT OUTER JOIN    
                             (SELECT        SUM(TransactionEntry.Qty) AS SumQty, TransactionEntry.ItemStoreID    
                               FROM            [Transaction] INNER JOIN    
                                                         TransactionEntry ON [Transaction].TransactionID = TransactionEntry.TransactionID      
                               WHERE        ([Transaction].StartSaleTime >'''+CONVERT(VARCHAR(20),@FromDate,20)+''' ) AND ([Transaction].StartSaleTime <'''+CONVERT(VARCHAR(20),@ToDate+1,20)+''' ) AND ([Transaction].Status > 0) AND     
                                                         (TransactionEntry.Status > 0)    
                               GROUP BY TransactionEntry.ItemStoreID) AS Sales ON ItemStore.ItemStoreID = Sales.ItemStoreID LEFT OUTER JOIN
(Select DISTINCT ItemId, R.ToStoreID AS StoreID, MAX(R.RequestDate) AS LastRequested from RequestTransferEntry E INNER JOIN RequestTransfer R ON E.RequestTransferID = R.RequestTransferID
Where R.Status > 0 and E.Status > 0
GROUP BY E.ItemId, R.ToStoreID) AS Req ON ItemStore.StoreNo = Req.StoreID AND ItemStore.ItemNo = Req.ItemId    
 where  exists (Select 1 From #ItemSelect where #ItemSelect.ItemNo= ItemStore.ItemNo)    
 AND Store.Status>0 AND ItemMain.Status>0 and ItemType <> 2    
 ORDER BY NAME,StoreName '      
    
    
    
PRINT (@ItemSelect + @ItemFilter  + @Filter +  @MySelect )  -- 
    
Execute (@ItemSelect + @ItemFilter + @Filter+  @MySelect )--
GO