SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sp_GetItemsList_Feb20_2018]  
(@StoreID nvarchar(50)=null,  
 @OnlyDiffPrice bit=0,  
 @Date Datetime =null )  
AS   
  
  
if @Date is null   
begin   
  
  
 IF @OnlyDiffPrice=0    
 BEGIN  
  
  SELECT        ItemPiece.ItemID, ItemPiece.Name, ItemPiece.ModalNumber, ItemPiece.BarcodeNumber, ItemPiece.OnOrder, ItemPiece.OnHand, ItemPiece.Department,   
         ItemPiece.OnHandCase, ItemPiece.Cost, ItemPiece.Price, ItemPiece.Cost * ItemPiece.OnHand AS ExtCost, ItemPiece.Price * ItemPiece.OnHand AS ExtPrice,   
         Store.StoreName, Store.StoreID, ItemPiece.SupplierName, ItemPiece.OnTransfer, ParentInfo.[Supplier Item Code] AS ParentCode,   
         ItemPiece.[Supplier Item Code] As SupplierCode, Brand,MainDepartment  
  FROM            ItemPiece Inner JOIN  
         Store ON Store.StoreID = ItemPiece.StoreNo LEFT OUTER JOIN  
          (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code]  
            FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemPiece.StoreNo = ParentInfo.StoreNo AND   
         ItemPiece.LinkNo = ParentInfo.ItemID  
        WHERE ItemPiece.ItemType <> 2 AND (ItemPiece.StoreNo =@StoreID  or @StoreID is null) AND ISNULL(OnHand,0) <> 0  
  
 END   
 ELSE  
 BEGIN  
  SELECT     dbo.ItemPiece.ItemID,  
      Name,   
     ModalNumber,  
     BarcodeNumber,   
     OnOrder,   
     OnHand,    
     Department,  
     OnHandCase,   
     Cost,  
     Price,   
     Cost * OnHand AS ExtCost,   
     Price * OnHand AS ExtPrice,  
     Store.StoreName,  
     ItemPiece.SupplierName,  
     Store.StoreID,  
     MainDepartment  
  FROM       dbo.ItemPiece inner join   
     (SELECT ItemID FROM (SELECT ItemID FROM dbo.ItemPiece  
     GROUP BY ItemID,Price) AS Items   
     GROUP BY ItemID HAVING count(*)>1) AS AllItems  
     ON AllItems.ItemID=dbo.ItemPiece.ItemID inner join   
     Store ON Store.StoreID=dbo.ItemPiece.StoreNo  
  WHERE   ItemPiece.ItemType <> 2 AND  (StoreNo = @StoreID Or @StoreID is null) AND ISNULL(OnHand,0) <> 0  
 END  
  
 end  
  
 else  
  
 begin   
  
   
if @Date is null   
begin   
set @Date =dbo.GetLocalDATE()  
end  
  
 IF @OnlyDiffPrice=0    
 BEGIN  
  
 select   
  
  ta.ItemID, ta.Name, ta.ModalNumber, ta.BarcodeNumber, ta.OnOrder, ta.OnHandCalc as OnHand, ta.Department,   
  
   (SELECT        CASE WHEN (ta.CaseQty IS NULL) THEN ta.OnHandCalc  
    WHEN (CaseQty = 0)   
   THEN ta.OnHandCalc ELSE ta.OnHandCalc / CaseQty END AS Expr1) AS OnHandCase,  
         ta.Cost, ta.Price, ta.Cost * ta.OnHandCalc AS ExtCost, ta.Price * ta.OnHandCalc AS ExtPrice,   
         ta.StoreName, ta.StoreID, ta.SupplierName, ta.OnTransfer, ta.ParentCode,   
         ta.SupplierCode, Brand,ta.MainDepartment  
 from (  
  SELECT        ItemPiece.ItemID, ItemPiece.Name, ItemPiece.ModalNumber, ItemPiece.BarcodeNumber, dbo.GetItemOnOrder(ItemPiece.itemStoreId,@Date) as OnOrder, dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHand, ItemPiece.Department,ItemPiece.Cost, ItemPiece.Price,   
         Store.StoreName, Store.StoreID, ItemPiece.SupplierName, ItemPiece.OnTransfer, ParentInfo.[Supplier Item Code] AS ParentCode,   
         ItemPiece.[Supplier Item Code] As SupplierCode, Brand,  
         dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHandCalc,CaseQty,MainDepartment  
  FROM            ItemPiece inner JOIN  
         Store ON Store.StoreID = ItemPiece.StoreNo LEFT OUTER JOIN  
          (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code]  
            FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemPiece.StoreNo = ParentInfo.StoreNo AND   
         ItemPiece.LinkNo = ParentInfo.ItemID  
        WHERE ItemPiece.ItemType <> 2 AND (ItemPiece.StoreNo =@StoreID  or @StoreID is null) AND ISNULL(OnHand,0) <> 0  
  ) as ta  
 END   
 ELSE  
 BEGIN  
  
 SELECT     ta.ItemID,  
      ta.Name,   
     ta.ModalNumber,  
     ta.BarcodeNumber,   
     ta.OnOrder,   
     ta.OnHandCalc as OnHand ,    
     ta.Department,  
     (SELECT        CASE WHEN (ta.CaseQty IS NULL) THEN ta.OnHandCalc  
    WHEN (ta.CaseQty = 0)   
   THEN ta.OnHandCalc ELSE ta.OnHandCalc / ta.CaseQty END AS Expr1)  OnHandCase,   
     ta.Cost,  
     ta.Price,   
     ta.Cost * ta.OnHandCalc AS ExtCost,   
     ta.Price * ta.OnHandCalc AS ExtPrice,  
     ta.StoreName,  
     ta.SupplierName,  
     ta.StoreID,  
     ta.MainDepartment  
     from (  
  SELECT     dbo.ItemPiece.ItemID,  
      Name,   
     ModalNumber,  
     BarcodeNumber,   
     dbo.GetItemOnOrder(ItemPiece.itemStoreId,@Date) as OnOrder,   
     dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHandCalc,    
     Department,  
     Cost,  
     Price,   
     Store.StoreName,  
     ItemPiece.SupplierName,  
     Store.StoreID,  
     CaseQty,  
     MainDepartment  
  FROM       dbo.ItemPiece Inner join   
     (SELECT ItemID FROM (SELECT ItemID FROM dbo.ItemPiece  
     GROUP BY ItemID,Price) AS Items   
     GROUP BY ItemID HAVING count(*)>1) AS AllItems  
     ON AllItems.ItemID=dbo.ItemPiece.ItemID inner join   
     Store ON Store.StoreID=dbo.ItemPiece.StoreNo  
  WHERE   ItemPiece.ItemType <> 2 AND  (StoreNo = @StoreID Or @StoreID is null) AND ISNULL(OnHand,0) <> 0) as ta  
 END  
  
 end
GO