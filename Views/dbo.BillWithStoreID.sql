SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[BillWithStoreID]
AS
SELECT     dbo.BillView.BillID, dbo.BillView.BillNo, dbo.BillView.SupplierID, dbo.BillView.Discount, dbo.BillView.Amount, dbo.BillView.AmountPay, 
                      dbo.BillView.BillDate, dbo.BillView.BillDue, dbo.BillView.PersonGet, dbo.BillView.Note, dbo.BillView.Status, dbo.BillView.DateCreated, 
                      dbo.BillView.UserCreated, dbo.BillView.DateModified, dbo.BillView.UserModified, dbo.ReceiveOrder.StoreID, 
                      dbo.ReceiveOrder.Status AS ReceiveStatus, dbo.BillView.TermsID, RE.EntrySum
FROM         dbo.BillView INNER JOIN
                      dbo.ReceiveOrder ON dbo.BillView.BillID = dbo.ReceiveOrder.BillID INNER JOIN
                          (SELECT     SUM(ExtPrice) AS EntrySum, ReceiveNo
                            FROM          dbo.ReceiveEntry
                            WHERE      (Status > 0)
                            GROUP BY ReceiveNo) AS RE ON RE.ReceiveNo = dbo.ReceiveOrder.ReceiveID
GO