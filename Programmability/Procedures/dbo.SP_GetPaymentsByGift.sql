SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPaymentsByGift]
(@GiftID uniqueidentifier)
As 


SELECT        ISNULL(TransactionView.TransactionID,'00000000-0000-0000-0000-000000000000') AS TransactionID, ISNULL(TransactionView.TransactionNo,'Batch Added') AS TransactionNo, TransactionView.CustomerNo, TransactionView.CustomerName, TransactionView.Debit, TransactionView.Credit, ISNULL(TransactionView.EndSaleTime,UsedDate) AS EndSaleTime, 
                         CouponUsed.Amount AS Amount, ISNULL(CouponUsed.AmountAdd, 0) AS AmountAdd
FROM            CouponUsed LEFT OUTER JOIN
                         TransactionView ON TransactionView.TransactionID = CouponUsed.TransactionID 
WHERE        (ISNULL(TransactionView.Status,1) > -1) AND (CouponUsed.Status > 0) AND (CouponUsed.CouponID = @GiftID)
--and exists 
							--(SELECT * 
							--from  CouponUsed
							--WHERE CouponUsed.TenderEntryID = CouponUsed.TenderEntryID and
							 --CouponUsed.Status> 0 and  
						   --)
GO