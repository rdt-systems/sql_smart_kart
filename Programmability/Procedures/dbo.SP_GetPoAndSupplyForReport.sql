SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPoAndSupplyForReport]
(@SupplierID uniqueidentifier,
@StoreNo uniqueidentifier,
@FromDate datetime,
@ToDate datetime,
@PoStatus smallint)
AS SELECT     dbo.SupplierView.*, dbo.PurchaseOrdersView.*
FROM         dbo.SupplierView RIGHT OUTER JOIN
                      dbo.PurchaseOrdersView ON dbo.SupplierView.SupplierID = dbo.PurchaseOrdersView.SupplierNo
WHERE     (dbo.PurchaseOrdersView.SupplierNo = @SupplierID) AND (dbo.PurchaseOrdersView.StoreNo = @StoreNo) AND 
                      (dbo.SupplierView.DateCreated > @FromDate) AND (dbo.SupplierView.DateCreated < @ToDate) AND (dbo.PurchaseOrdersView.POStatus < 9)
GO