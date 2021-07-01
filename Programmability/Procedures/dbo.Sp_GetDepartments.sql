SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sp_GetDepartments]
(@StoreID uniqueidentifier=null,
@Date Datetime =null)
AS 

if @Date is null 
begin 

IF (Select COUNT(*) from SetUpValues where OptionID = 100 and OptionValue = '1' And StoreID <> '00000000-0000-0000-0000-000000000000') >0
SELECT        Main.Sub3 AS MainDepartment, Main.Sub1 AS SubDepartment, Main.Sub2 AS SubSubDepartment, DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, SUM(ItemPiece.OnOrder) AS OnOrder, 
                         SUM(ItemPiece.OnHand) AS OnHand, SUM(ItemPiece.OnHand * ItemPiece.Cost) AS Cost, SUM(ItemPiece.OnHand * ItemPiece.Price) AS Price, SUM(ItemPiece.OnHand * ItemPiece.AVGCost) AS AVGCost, Store.StoreName, 
                         Store.StoreID
FROM            DepartmentStoreView RIGHT OUTER JOIN
                         ItemPiece ON DepartmentStoreView.DepartmentStoreID = ItemPiece.DepartmentID LEFT OUTER JOIN
                             (SELECT        DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName, CASE WHEN (tDepartment_3.Name IS NOT NULL) THEN tDepartment_2.Name WHEN (tDepartment_3.Name IS NULL AND 
                                                         tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name ELSE DepartmentStore.Name END AS Sub1, CASE WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) 
                                                         THEN DepartmentStore.Name WHEN (tDepartment_3.Name IS NOT NULL AND tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name END AS Sub2, COALESCE (tDepartment_3.Name, 
                                                         tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) AS Sub3
                               FROM            DepartmentStore LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
                                                         DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
                               WHERE        (DepartmentStore.Status > 0)) AS Main ON DepartmentStoreView.DepartmentStoreID = Main.DepartmentStoreID LEFT OUTER JOIN
                         Store ON Store.StoreID = ItemPiece.StoreNo
WHERE       ((ItemPiece.StoreNo = @StoreID) OR (@StoreID IS NULL)) AND(ItemPiece.ItemType <> 2) AND ItemPiece.ItemType <> 3  AND ItemPiece.ItemType <> 9 
GROUP BY Sub3, Sub1, Sub2,  DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, Store.StoreName, Store.StoreID

Else

SELECT       '' AS MainDepartment, '' AS SubDepartment, '' AS SubSubDepartment,  DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, SUM(ItemPiece.OnOrder) AS OnOrder, SUM(ItemPiece.OnHand) AS OnHand, SUM(ItemPiece.OnHand * ItemPiece.Cost) AS Cost, 
                         SUM(ItemPiece.OnHand * ItemPiece.Price) AS Price, SUM(ItemPiece.OnHand * ItemPiece.AVGCost) AS AVGCost, Store.StoreName, Store.StoreID
FROM            DepartmentStoreView  RIGHT OUTER JOIN
                         ItemPiece ON DepartmentStoreView.DepartmentStoreID = ItemPiece.DepartmentID LEFT OUTER JOIN
                         Store ON Store.StoreID = ItemPiece.StoreNo
WHERE       ((ItemPiece.StoreNo = @StoreID) OR (@StoreID IS NULL)) AND(ItemPiece.ItemType <> 2) AND ItemPiece.ItemType <> 3  AND ItemPiece.ItemType <> 9 
GROUP BY DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, Store.StoreName, Store.StoreID

end 

else 
begin 

IF (Select COUNT(*) from SetUpValues where OptionID = 100 and OptionValue = '1' And StoreID <> '00000000-0000-0000-0000-000000000000') >0

select      MainDepartment, SubDepartment, SubSubDepartment,  al.DepartmentStoreID, al.Name,
 SUM(al.OnOrder) AS OnOrder, SUM(al.OnHandCalc) AS OnHand, 
 SUM(al.OnHandCalc * al.Cost) AS Cost, 
SUM(al.OnHandCalc * al.Price) AS Price,
 SUM(al.OnHandCalc * al.AVGCost) AS AVGCost, 
 al.StoreName, al.StoreID
 from (
SELECT      sub3 AS MainDepartment, Main.Sub1 AS SubDepartment, Main.Sub2 AS SubSubDepartment,  DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, ItemPiece.OnOrder, 
(dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date)) AS OnHandCalc, ItemPiece.Cost, 
                       ItemPiece.Price, ItemPiece.AVGCost, Store.StoreName, Store.StoreID
FROM            DepartmentStoreView RIGHT OUTER JOIN
                         ItemPiece ON DepartmentStoreView.DepartmentStoreID = ItemPiece.DepartmentID LEFT OUTER JOIN
                             (SELECT        DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName, CASE WHEN (tDepartment_3.Name IS NOT NULL) 
                                                         THEN tDepartment_2.Name WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name ELSE DepartmentStore.Name END AS Sub1, 
                                                         CASE WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) THEN DepartmentStore.Name WHEN (tDepartment_3.Name IS NOT NULL AND 
                                                         tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name END AS Sub2, COALESCE (tDepartment_3.Name, tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) 
                                                         AS Sub3
                               FROM            DepartmentStore LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
                                                         DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON 
                                                         DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
                               WHERE        (DepartmentStore.Status > 0)) AS Main ON DepartmentStoreView.DepartmentStoreID = Main.DepartmentStoreID LEFT OUTER JOIN
                         Store ON Store.StoreID = ItemPiece.StoreNo
WHERE        ((ItemPiece.StoreNo = @StoreID) OR (@StoreID IS NULL)) AND(ItemPiece.ItemType <> 2) AND ItemPiece.ItemType <> 3  AND ItemPiece.ItemType <> 9 ) as al 
GROUP BY al.MainDepartment, al.SubDepartment, al.SubSubDepartment,  al.DepartmentStoreID, al.Name, al.StoreName, al.StoreID

Else
  
select        '' AS MainDepartment, '' AS SubDepartment, '' AS SubSubDepartment,  al.DepartmentStoreID, al.Name, 
SUM(al.OnOrder) AS OnOrder, 
SUM(al.OnHandCalc) AS OnHand,
 SUM(al.OnHandCalc * al.Cost) AS Cost, 
 SUM(al.OnHandCalc * al.Price) AS Price, 
 SUM(al.OnHandCalc * al.AVGCost) AS AVGCost,
  al.StoreName, al.StoreID
   from (
SELECT       '' AS MainDepartment, '' AS SubDepartment, '' AS SubSubDepartment,  DepartmentStoreView.DepartmentStoreID, DepartmentStoreView.Name, ItemPiece.OnOrder, 
(dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date)) as OnHandCalc, 
ItemPiece.Cost,
ItemPiece.Price,
ItemPiece.AVGCost,
Store.StoreName, 
Store.StoreID
FROM            DepartmentStoreView RIGHT OUTER JOIN
                         ItemPiece ON DepartmentStoreView.DepartmentStoreID = ItemPiece.DepartmentID LEFT OUTER JOIN
                         Store ON Store.StoreID = ItemPiece.StoreNo
WHERE         ((ItemPiece.StoreNo = @StoreID) OR (@StoreID IS NULL)) AND(ItemPiece.ItemType <> 2) AND ItemPiece.ItemType <> 3  AND ItemPiece.ItemType <> 9 
)as al
GROUP BY al.DepartmentStoreID, al.Name, al.StoreName, al.StoreID

end
GO