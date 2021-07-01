SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE       VIEW [dbo].[PaymentsForCenter]
AS
SELECT     dbo.SupplierTenderEntry.SuppTenderEntryID, dbo.SupplierTenderEntry.SuppTenderNo, 3 AS Type, 
                      dbo.SupplierTenderEntry.TenderDate AS Date, dbo.SupplierTenderEntry.Amount,
	isnull((select sum(isnull(PayToBill.Amount,0))
	 from dbo.PayToBill
 	where dbo.PayToBill.SuppTenderID = dbo.SupplierTenderEntry.SuppTenderEntryID and PayToBill.status > 0
	Group By dbo.PayToBill.SuppTenderID),0) as status,  
                      dbo.SupplierTenderEntry.SupplierID, dbo.SupplierTenderEntry.StoreID,dbo.SupplierTenderEntry.Status as IsVoid
FROM         dbo.SupplierTenderEntry 
WHERE     (dbo.SupplierTenderEntry.Status > -1)
GO