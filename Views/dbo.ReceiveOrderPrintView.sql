SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[ReceiveOrderPrintView]
AS

SELECT        PurchaseOrdersView.PoNo, ReceiveOrderView.ReceiveOrderDate, ReceiveOrderView.Total, ReceiveOrderView.Note, ReceiveOrderView.Discount, ReceiveOrderView.Freight, SupplierView.SupplierNo, 
                         SupplierView.Name, SupplierView.ContactName, ISNULL(SupplierAddressView.Line1 + ' ' + SupplierAddressView.Line2, '') AS Address, 
                         ISNULL(SupplierAddressView.City + ' ' + SupplierAddressView.State + ' ' + SupplierAddressView.Zip, '') AS CSZSupplier, BillView.BillNo, BillView.Amount, BillView.BillDate, ReceiveOrderView.ReceiveID, 
                         ReceiveOrderView.CustomsDuties, ReceiveOrderView.OtherCharges
FROM            SupplierView INNER JOIN
                         ReceiveOrderView ON SupplierView.SupplierID = ReceiveOrderView.SupplierNo INNER JOIN
                         BillView ON ReceiveOrderView.BillID = BillView.BillID LEFT OUTER JOIN
                         ReceiveToPOView ON ReceiveOrderView.ReceiveID = ReceiveToPOView.ReceiveID LEFT OUTER JOIN
                         PurchaseOrdersView ON ReceiveToPOView.POID = PurchaseOrdersView.PurchaseOrderId LEFT OUTER JOIN
                         SupplierAddressView ON SupplierView.MainAddress = SupplierAddressView.AddressID
GO