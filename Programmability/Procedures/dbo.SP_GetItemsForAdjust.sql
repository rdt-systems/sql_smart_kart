SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Eziel Fleischman>
-- ALTER date: <3/20/2013>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetItemsForAdjust] 
@CountedOnly bit,
@DiscrepancyOnly bit,
@StoreID uniqueidentifier,
@ClearCount bit = null
AS
BEGIN

SET NOCOUNT ON;

UPDATE       ItemStore
SET                LastCount = Cont.Total, CountOnHand = Cont.OnHand, CountDate = dbo.GetLocalDATE()
FROM            ItemStore INNER JOIN
                             (SELECT        SUM(Total) AS Total, ItemStoreID, OnHand
                               FROM            CountInventoryEntry
                               WHERE        (Status > 0)
                               GROUP BY ItemStoreID, OnHand) AS Cont ON ItemStore.ItemStoreID = Cont.ItemStoreID
WHERE        (ItemStore.LastCount <> Cont.Total) OR
                         (ISNULL(ItemStore.CountOnHand, 0) <> ISNULL(Cont.OnHand, 0))

Update ItemStore Set OnHand = 0 where OnHand IS NULL

if @ClearCount = 1 
	BEGIN
   Update ItemStore Set CountDate = null, LastCount = null, CountOnHand = null Where storeno = @StoreID 
   
   update CountInventory Set Status = -1, DateModified = dbo.GetLocalDATE() where StoreID = @StoreID AND status > 0
   update CountInventoryEntry set status = -1 , DateModified = dbo.GetLocalDATE() from CountInventoryEntry cie inner join CountInventory ci on cie.CountInventoryID = ci.CountInventoryID
   where ci.StoreID = @StoreID and cie.Status > 0

   return
   END

   
  if @DiscrepancyOnly = 1 begin
SELECT     im.ItemID,   im.CustomerCode, its.ItemStoreID, its.Price, its.Cost, im.Name, im.BarcodeNumber, im.ModalNumber, its.OnHand as CurrentOnHand, (CASE WHEN (its.LastCount IS NOT NULL AND its.CountOnHand IS NOT NULL) THEN Its.CountOnHand ELSE Its.OnHand END) As OnHand, its.CountDate, its.LastCount, 
                         DepartmentStore.Name AS Department
FROM            ItemMain AS im INNER JOIN
                         ItemStore AS its ON im.ItemID = its.ItemNo LEFT OUTER JOIN
                         DepartmentStore ON its.DepartmentID = DepartmentStore.DepartmentStoreID
	Where its.StoreNo = @StoreID and its.LastCount <> its.OnHand and its.Status > 0
	RETURN
  END
  if @CountedOnly = 1 begin
	SELECT  im.ItemID, im.CustomerCode, its.ItemStoreID, Price, Cost, im.Name, BarcodeNumber, ModalNumber, its.OnHand as CurrentOnHand, its.CountDate , its.LastCount,(CASE WHEN (its.LastCount IS NOT NULL AND its.CountOnHand IS NOT NULL) THEN Its.CountOnHand ELSE Its.OnHand END) As OnHand, DepartmentStore.Name AS Department
	From ItemMain im inner join itemstore its on im.itemid = its.itemno LEFT OUTER JOIN
                         DepartmentStore ON its.DepartmentID = DepartmentStore.DepartmentStoreID
	Where its.StoreNo = @StoreID and its.LastCount is not null and its.Status > 0
	RETURN
  END
    if @CountedOnly = 0 begin
	SELECT  im.ItemID, im.CustomerCode, its.ItemStoreID, Price, Cost, im.Name, BarcodeNumber, ModalNumber, ISNULL(its.OnHand,0) as CurrentOnHand, its.CountDate , its.LastCount, ISNULL((CASE WHEN (its.LastCount IS NOT NULL AND its.CountOnHand IS NOT NULL) THEN Its.CountOnHand ELSE Its.OnHand END),0) As OnHand , DepartmentStore.Name AS Department
	From ItemMain im inner join itemstore its on im.itemid = its.itemno LEFT OUTER JOIN
                         DepartmentStore ON its.DepartmentID = DepartmentStore.DepartmentStoreID
	Where its.StoreNo = @StoreID and its.Status > 0
	RETURN
  END

END
GO