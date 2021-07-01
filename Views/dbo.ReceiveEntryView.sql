SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[ReceiveEntryView]
AS
SELECT    ReceiveEntry.ReceiveEntryID, ReceiveEntry.ReceiveNo, ReceiveEntry.ItemStoreNo, ReceiveEntry.PurchaseOrderEntryNo, ReceiveEntry.Cost, ReceiveEntry.Qty, ReceiveEntry.UOMQty, ReceiveEntry.UOMType, 
                         ReceiveEntry.ExtPrice, ReceiveEntry.IsSpecialPrice, ReceiveEntry.ForApprove, ReceiveEntry.LinkNo, ReceiveEntry.Note, ReceiveEntry.SortOrder, ReceiveEntry.Taxable, ReceiveEntry.Status, 
                         ReceiveEntry.DateCreated, ReceiveEntry.UserCreated, ReceiveEntry.DateModified, ReceiveEntry.UserModified, ReceiveEntry.ListPrice, ReceiveEntry.NetCost, IMS.Brand, 
                         (CASE WHEN ReceiveEntry.UOMTYPE <> 2 THEN ReceiveEntry.Qty * isnull(ReceiveEntry.Cost,0) ELSE isnull(ReceiveEntry.Cost,0) END) / ISNULL(CASE WHEN ReceiveEntry.UOMQty <> 0 THEN ReceiveEntry.UOMQty ELSE 1 END,
                          CASE WHEN ReceiveEntry.Qty <> 0 THEN ReceiveEntry.Qty ELSE 1 END) AS UOMPrice, (CASE WHEN ReceiveEntry.UOMTYPE <> 2 THEN ReceiveEntry.Qty * ReceiveEntry.Cost ELSE ReceiveEntry.Cost END) 
                         / ISNULL(CASE WHEN ReceiveEntry.UOMQty <> 0 THEN ReceiveEntry.UOMQty ELSE 1 END, CASE WHEN ReceiveEntry.Qty <> 0 THEN ReceiveEntry.Qty ELSE 1 END) AS RealCost, 
                         PurchaseOrderEntry.PurchaseOrderNo, ReceiveEntry.CaseCost, ReceiveEntry.PcCost, ReceiveEntry.CaseQty, isnull(ReceiveEntry.LastNetCost,ReceiveEntry.PcCost)as LastNetCost, ReceiveEntry.PriceStatus, IMS.Price AS RetailUnitPrice, 
                         IMS.[SP Price] AS SaleSpecialPrice, ISNULL(IMS.Price, 0) AS RetailPrice, (CASE WHEN ISNULL(IMS.Price, 0) <> 0 AND IsNull(NetPcCost, ISNULL(PcCost, 0)) <> 0 THEN (IMS.Price - IsNull(NetPcCost, PcCost)) 
                         / (IsNull(NetPcCost, PcCost)) WHEN ISNULL(IMS.Price, 0) <> 0 AND ISNULL(PcCost, 0) <> 0 THEN ((IMS.Price - PcCost) / PcCost) ELSE 0 END) * 100 AS Markup, (CASE WHEN ISNULL(IMS.Price, 0) <> 0 AND 
                         IsNull(NetPcCost, ISNULL(PcCost, 0)) <> 0 THEN (IMS.Price - IsNull(NetPcCost, PcCost)) / IMS.Price ELSE 0 END) * 100 AS Margin, IMS.Name AS ItemName, IMS.BarcodeNumber AS ItemUPC, 
                         IMS.ModalNumber AS ItemModelNo, IMS.ItemID, 0 AS PriceChange, ItemSupply.ItemCode AS SupplierCode, IMS.Size, ReceiveEntry.Discount, IMS.Department, ISNULL(ParentCode,[Supplier Item Code]) AS ParentCode, 
                         IMS.RegSPPrice, IMS.CaseSPPrice, IMS.RegPkgPrice, IMS.[Reg SP Price Markup], IMS.[Reg SP Price Margin], IMS.[Pkg Price Markup], IMS.[Pkg Price Margin], IMS.[SP Markup], IMS.[SP Margin], IMS.StyleNo, 
                         IMS.Matrix1, IMS.Matrix2, (SELECT Name From ItemMain Where ItemID = IMS.LinkNo) AS ParentName, IMS.BinLocation, IMS.ItemAlias, IMS.[SP FROM] AS SPFrom, IMS.[SP To] as SPTo
FROM                     ItemMainAndStoreList AS IMS INNER JOIN
                         ReceiveEntry ON IMS.ItemStoreID = ReceiveEntry.ItemStoreNo INNER JOIN
                         ItemSupply ON IMS.ItemStoreID = ItemSupply.ItemStoreNo INNER JOIN
                         ReceiveOrder ON ItemSupply.SupplierNo = ReceiveOrder.SupplierNo AND ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID LEFT OUTER JOIN
                         PurchaseOrderEntry ON ReceiveEntry.PurchaseOrderEntryNo = PurchaseOrderEntry.PurchaseOrderEntryId
WHERE        (ItemSupply.Status > 0)
GO