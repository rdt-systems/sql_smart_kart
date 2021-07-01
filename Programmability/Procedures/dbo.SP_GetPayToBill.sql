SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPayToBill]
(@PaymentID uniqueidentifier,
 @StoreID uniqueidentifier)
as

SELECT       dbo.BillWithStoreID.BillNo,
             dbo.BillWithStoreID.Amount

FROM         dbo.BillWithStoreID 
	     FUll outer JOIN
             dbo.PayToBill ON dbo.BillWithStoreID.BillID = dbo.PayToBill.BillID and SuppTenderID=@PaymentID and dbo.PayToBill.Status > 0 
	     FUll outer JOIN
             dbo.SupplierTenderEntry ON dbo.PayToBill.SuppTenderID = dbo.SupplierTenderEntry.SuppTenderEntryID and dbo.SupplierTenderEntry.Status > 0

where        dbo.BillWithStoreID.Status>0 and 
             dbo.BillWithStoreID.StoreID=@StoreID and 
             SuppTenderEntryID=@PaymentID
GO