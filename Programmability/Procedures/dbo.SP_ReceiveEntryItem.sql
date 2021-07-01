SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveEntryItem]
AS SELECT     dbo.ReceiveEntryView.Cost, dbo.ReceiveEntryView.Qty, dbo.ReceiveOrderView.ReceiveID, dbo.Supplier.SupplierNo
FROM         dbo.ReceiveEntryView INNER JOIN
                      dbo.ReceiveOrderView ON dbo.ReceiveEntryView.ReceiveNo = dbo.ReceiveOrderView.ReceiveID INNER JOIN
                      dbo.Supplier ON dbo.ReceiveOrderView.SupplierNo = dbo.Supplier.SupplierID
GO