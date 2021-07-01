SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetUnPaidBills]
(@FromDate datetime,
@ToDate datetime,
@StoreID Uniqueidentifier = null)

AS

SELECT     dbo.BillView.BillNo, dbo.BillView.Amount, dbo.BillView.AmountPay, dbo.BillView.BillDate,dbo.BillView.Amount -  ISNULL(dbo.BillView.AmountPay, 0) 
                      AS Balance, 0.00 AS ApplyAmount, dbo.ReceiveOrder.ReceiveID, dbo.BillView.BillDue, dbo.ReceiveOrder.Freight, dbo.ReceiveOrder.Discount, 
                      dbo.Supplier.Name,dbo.BillView.Amount,dbo.Store.StoreName
FROM         dbo.BillView INNER JOIN
                      dbo.Supplier ON dbo.BillView.SupplierID = dbo.Supplier.SupplierID and dbo.Supplier.Status >0   INNER JOIN
                      dbo.ReceiveOrder ON dbo.BillView.BillID = dbo.ReceiveOrder.BillID INNER JOIN
                      dbo.Store ON dbo.Store.StoreID = dbo.ReceiveOrder.StoreID

WHERE     dbo.ReceiveOrder.Status>0 and (dbo.BillView.Status > 0) AND (ISNULL(dbo.BillView.Amount - isnull(dbo.BillView.AmountPay,0), 0) > 0) AND (dbo.BillView.BillDate >= @FromDate) AND 
                      (dbo.BillView.BillDate < @ToDate) And (@StoreID Is Null Or dbo.ReceiveOrder.StoreID=@StoreID)
ORDER BY dbo.BillView.BillDate DESC
GO