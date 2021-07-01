SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[NewBillsForQBView]
AS
SELECT        B.BillNo, B.Amount, B.AmountPay, B.BillDate, B.BillDue, B.Note, QS.QbNumber AS SQbNumber, B.BillID, R.StoreID
FROM            dbo.Bill AS B INNER JOIN
                         dbo.Supplier AS S ON B.SupplierID = S.SupplierID INNER JOIN
                         dbo.ReceiveOrder AS R ON B.BillID = R.BillID INNER JOIN
                         dbo.QBSuppliers AS QS ON QS.StoreID = R.StoreID AND QS.SupplierID = S.SupplierID
WHERE        (S.Status > 0) AND (B.Status > 0) AND (B.QBNumber IS NULL) AND (QS.QbNumber IS NOT NULL) AND (QS.QbNumber <> 'Skip') AND (B.Amount IS NOT NULL)
GO