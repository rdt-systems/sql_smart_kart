SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RPT_PVTSellThroghReport]
	(@StoreID Uniqueidentifier=NULL, 
	@FromDate DateTime ='01/01/1900',
	@ToDate DateTime = '12/31/2999')

AS

Select DISTINCT StoreName, StoreID, Department, LinkNo, StyleNo, Color, Size, SUM(OnHand) AS OnHand, SUM(QTY) AS SoldQty 
Into #Sales
From TransactionEntryItem 
WHERE (StoreID = @StoreID OR @StoreID IS NULL) AND EndSaleTime > = @FromDate AND EndSaleTime < @ToDate
GROUP BY StoreName, StoreID, Department, LinkNo, StyleNo, Color, Size

Select DISTINCT T.StoreName, O.StoreNo AS StoreID, M.LinkNo, M.StyleNo, M.Matrix1 AS Color, M.Matrix2 AS Size, SUM(E.QtyOrdered-ISNULL(A.Allocated,0)) AS PoQty  
Into #PO
from dbo.PurchaseOrderEntry AS E INNER JOIN 
dbo.PurchaseOrders AS O ON E.PurchaseOrderNo = O.PurchaseOrderId INNER JOIN Store T ON O.StoreNo = T.StoreID INNER JOIN 
dbo.ItemStore S ON E.ItemNo = S.ItemStoreID INNER JOIN 
dbo.ItemMain M ON S.ItemNo = M.ItemID LEFT OUTER JOIN 
(Select OrderID, SUM(QTY) AS Allocated From dbo.AllocateItems Where Status > 0
GROUP BY OrderID) A ON E.PurchaseOrderEntryId = A.OrderID 
Where O.Status > 0 and E.Status > 0
AND (O.StoreNo = @StoreID OR @StoreID IS NULL) AND PurchaseOrderDate > = @FromDate AND PurchaseOrderDate < @ToDate
GROUP BY T.StoreName, O.StoreNo, M.LinkNo, M.StyleNo, M.Matrix1, M.Matrix2


Select  DISTINCT T.StoreName, A.StoreID, M.LinkNo, M.StyleNo, M.Matrix1 AS Color, M.Matrix2 AS Size, SUM(A.QTY) AS PoQty  
INTO #Allocate
from dbo.AllocateItems A INNER JOIN 
dbo.PurchaseOrderEntry E ON A.OrderID = E.PurchaseOrderEntryId INNER JOIN
dbo.PurchaseOrders AS O ON E.PurchaseOrderNo = O.PurchaseOrderId INNER JOIN 
dbo.ItemStore S ON A.ItemStoreID = S.ItemStoreID INNER JOIN 
dbo.ItemMain M ON S.ItemNo = M.ItemID
INNER JOIN Store T ON A.StoreID = T.StoreID
Where O.Status > 0 and E.Status > 0 AND A.Status > 0
AND (A.StoreID = @StoreID OR @StoreID IS NULL) AND PurchaseOrderDate > = @FromDate AND PurchaseOrderDate < @ToDate
GROUP BY T.StoreName,A.StoreID, M.LinkNo, M.StyleNo, M.Matrix1, M.Matrix2


Select DISTINCT S.StoreID, S.StoreName, S.Department, S.LinkNo, S.StyleNo, S.Color, S.Size, SUM(S.SoldQty) AS Sold, OnHand, SUM(ISNULL(P.PoQty,0)) + SUM(ISNULL(A.PoQty,0)) AS Purchased,
(CASE WHEN SUM(ISNULL(P.PoQty,0)) + SUM(ISNULL(A.PoQty,0)) > 0 AND SUM(S.SoldQty) > 0 THEN (100 / (SUM(ISNULL(P.PoQty,0)) + SUM(ISNULL(A.PoQty,0))) * SUM(S.SoldQty))/100 ELSE 0 END) AS SellThru
from #Sales S LEFT OUTER JOIN #PO P ON S.StoreID = P.StoreID AND S.LinkNo = P.LinkNo
AND S.Color = P.Color AND S.Size = P.Size AND S.StyleNo = P.StyleNo LEFT OUTER JOIN  #Allocate AS A
ON S.StoreID = A.StoreID AND S.LinkNo = A.LinkNo
AND S.Color = A.Color AND S.Size = A.Size AND S.StyleNo = A.StyleNo
GROUP BY S.StoreID, S.StoreName, S.Department, S.LinkNo, S.StyleNo, S.Color, S.Size, S.OnHand


DROP TABLE #Sales
DROP TABLE #PO
DROP TABLE #Allocate
GO