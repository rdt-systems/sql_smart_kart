SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_rptOpenPartialPO]
(@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(4000)

SET @MySelect ='SELECT       PONO,* 
FROM            PurchaseOrderEntryView INNER JOIN
                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId
WHERE        (PurchaseOrderEntryView.QtyOrdered > PurchaseOrderEntryView.ReceivedQty) AND (PurchaseOrdersView.POStatus <> 0) And (PurchaseOrderEntryView.ReceivedQty > 0)'

print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO