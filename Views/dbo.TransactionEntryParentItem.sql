SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionEntryParentItem]
AS
SELECT     M.ItemID,  dbo.TransactionEntry.ItemStoreID ,IsNull(ParentInfo.Name,IsNull(M.Name, '[MANUAL ITEM]')) AS Name, IsNull(ParentInfo.BarcodeNumber, M.BarcodeNumber) As BarcodeNumber ,IsNull(ParentInfo.ModalNumber,M.ModalNumber)As ModalNumber,IsNull(ParentInfo.ItemID, M.ItemID) As ParentItemID, IsNull(ParentInfo.ItemStoreID,dbo.TransactionEntry.ItemStoreID) As ParentItemStoreID,
                      S.OnOrder,TransactionEntry.TransactionEntryID , SysItemTypeView.SystemValueName AS ItemTypeName,  
					  (CASE WHEN IsNull(ParentInfo.SupplierName,'')='' THEN  ISNULL(Supplier.Name,'[No Supplier]') ELSE ParentInfo.SupplierName END) AS Supplier, 
					  S.MainSupplierID AS SupplierID,  Supp.ItemCode AS SupplierCode, 
                      ISNULL(D.Name, ISNULL(dbo.DepartmentStore.Name, '[No Department]')) AS Department, ISNULL(D.DepartmentStoreID, 
                      dbo.DepartmentStore.DepartmentStoreID) AS DepartmentID, M.ItemType, dbo.[Transaction].TransactionID, 
                      dbo.[Transaction].TransactionNo, dbo.[Transaction].StoreID, dbo.[Transaction].CustomerID, dbo.[Transaction].TransactionType, 
                      dbo.[Transaction].StartSaleTime, dbo.[Transaction].UserCreated AS UserID, dbo.TransactionEntry.Total, 
/*Ext Cost*/          ISNULL(dbo.TransactionEntry.AVGCost, 0) * ISNULL((SELECT     
                              CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE(
                              CASE WHEN TransactionEntry.UOMTYPE IS NULL THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty
                                                    * M.CaseQty END)END), 0) AS ExtCost, 
/*Cost*/              ISNULL(dbo.TransactionEntry.Cost, 0) * ISNULL(dbo.TransactionEntry.UOMQty, 0) AS Cost, 
/*ExtPrice*/          dbo.TransactionEntry.Total AS ExtPrice, 
                      ISNULL(dbo.TransactionEntry.Cost, 0) AS RegCost, 
                      ISNULL(dbo.TransactionEntry.AVGCost, 0) AS AVGCost, 
                      (CASE WHEN TransactionEntry.UOMQty = 0 THEN 0 ELSE ISNULL(dbo.TransactionEntry.UOMPrice, 1) / ISNULL(TransactionEntry.UOMQty, 1) 
                      * ISNULL(TransactionEntry.UOMQty, 1) END) AS Price,
/*Case Qty*/          (SELECT     CASE WHEN M.CaseQty IS NULL THEN dbo.TransactionEntry.UOMQty 
                                       WHEN (M.CaseQty = 0 )THEN dbo.TransactionEntry.UOMQty
  WHEN M.BarcodeType = 1 THEN dbo.TransactionEntry.Qty
                        ELSE (SELECT CASE WHEN (TransactionEntry.UOMTYPE IS NULL) THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.Qty ELSE dbo.TransactionEntry.UOMQty
                                                    * M.CaseQty END)/ M.CaseQty END AS Expr1) AS QtyCase, 
/*Discount*/          --ISNULL(dbo.TransactionEntry.DiscountOnTotal * dbo.TransactionEntry.Total / 100, 0) AS Discount,
/*Discount*/          ISNULL(dbo.TransactionEntry.DiscountOnTotal, 0) AS Discount,
/*Profit*/           
                      --dbo.TransactionEntry.Total -(ISNULL(dbo.TransactionEntry.AVGCost, 0) *ISNULL((SELECT CASE WHEN BARCODETYPE <> 'Standard' THEN dbo.TransactionEntry.Qty ELSE(CASE WHEN TransactionEntry.UOMTYPE IS NULL THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty
					  (CASE WHEN ISNULL(TotalAfterDiscount,0)=0 THEN dbo.TransactionEntry.Total ELSE dbo.TransactionEntry.TotalAfterDiscount END)-
					  (ISNULL(dbo.TransactionEntry.AVGCost, 0) *ISNULL((SELECT CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE(CASE WHEN TransactionEntry.UOMTYPE IS NULL THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty
                                                    * M.CaseQty END)END), 0))
                      /*ISNULL(dbo.TransactionEntry.DiscountOnTotal * dbo.TransactionEntry.Total / 100, 0) 
                      - ISNULL(dbo.TransactionEntry.AVGCost * dbo.TransactionEntry.UOMQty, 0)*/
                      AS Profit, 
/*TotalAfterDiscount*/--dbo.TransactionEntry.Total - ISNULL(dbo.TransactionEntry.DiscountOnTotal * dbo.TransactionEntry.Total / 100, 0) AS TotalAfterDiscount, 
/*TotalAfterDiscount*/--dbo.TransactionEntry.Total - ISNULL(dbo.TransactionEntry.DiscountOnTotal, 0) AS 
/*TotalAfterDiscount*/(CASE WHEN ISNULL(TotalAfterDiscount,0)=0 THEN dbo.TransactionEntry.Total ELSE dbo.TransactionEntry.TotalAfterDiscount END)AS TotalAfterDiscount, 

                      dbo.TransactionEntry.RegUnitPrice, dbo.TransactionEntry.UOMPrice, dbo.Store.StoreName, dbo.TransactionEntry.ReturnReason, 
                      
                      S.OnHand,
/*Qty*/             (SELECT     CASE WHEN TransactionEntry.UOMTYPE IS NULL THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty
                                                    * M.CaseQty END AS Qty) AS QTY,
B.ManufacturerName AS Brand,
M.CustomerCode,
ParentInfo.[Supplier Item Code] AS ParentCode,
TransactionEntry.Taxable  
FROM         dbo.TransactionEntry INNER JOIN
                      dbo.[Transaction] ON dbo.[Transaction].TransactionID = dbo.TransactionEntry.TransactionID INNER JOIN 
						 dbo.Store ON [Transaction].StoreID = dbo.Store.StoreID  LEFT OUTER JOIN
						 dbo.DepartmentStore ON dbo.TransactionEntry.DepartmentID = dbo.DepartmentStore.DepartmentStoreID  LEFT OUTER JOIN
				   dbo.ItemStore S ON TransactionEntry.ItemStoreID = S.ItemStoreID AND S.Status >-1 INNER JOIN ItemMain M ON S.ItemNo = M.ItemID  LEFT OUTER JOIN
                         dbo.SysItemTypeView ON M.ItemType = SysItemTypeView.SystemValueNo INNER JOIN
                   dbo.Manufacturers B ON M.ManufacturerID = B.ManufacturerID LEFT OUTER JOIN
				 dbo.DepartmentStore D ON S.DepartmentID = D.DepartmentStoreID LEFT OUTER JOIN
							   dbo.ItemHeadSupplierView Supp ON S.MainSupplierID = Supp.ItemSupplyID INNER JOIN
							   dbo.Supplier ON Supplier.SupplierID = Supp.SupplierNo LEFT OUTER JOIN
							   (SELECT DISTINCT ItemStore.ItemNo AS ItemID, Supplier.Name AS SupplierName, ItemStore.StoreNo, ItemMain.Name, ItemMain.ModalNumber, ItemSupply.ItemCode AS [Supplier Item Code], ItemMain.BarcodeNumber, ItemStore.ItemStoreID
                            FROM          dbo.ItemStore INNER JOIN dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
                                                   dbo.ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStore.MainSupplierID = ItemSupply.ItemSupplyID INNER JOIN
                                                   dbo.Supplier ON ItemSupply.SupplierNo = Supplier.SupplierID
                            WHERE      (ItemSupply.Status > 0)) AS ParentInfo ON S.StoreNo = ParentInfo.StoreNo AND 
                      M.LinkNo = ParentInfo.ItemID

WHERE     (dbo.TransactionEntry.Status > 0)AND 
          (dbo.TransactionEntry.TransactionEntryType <> 4)AND 
          (dbo.TransactionEntry.TransactionEntryType <> 5)AND 
          (dbo.[Transaction].Status > 0)
GO