SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillsForEditPayment]
(@SupplierID uniqueidentifier,
 @PaymentID uniqueidentifier,
 @StoreID uniqueidentifier,
@PaymentDate dateTime)
as

SELECT     dbo.BillWithStoreID.BillID,dbo.BillWithStoreID.BillNo, dbo.BillWithStoreID.Amount, dbo.BillWithStoreID.AmountPay,
    Case when DateDiff(Day,dbo.BillWithStoreID.BillDate,@PaymentDate) <= dbo.Credit.Days then
       isnull(InterestRate,0)
    else
    0.00 end
                as [Terms Discount(%)],

    Case when DateDiff(Day,dbo.BillWithStoreID.BillDate,@PaymentDate) <= dbo.Credit.Days And dbo.BillWithStoreID.Amount <> dbo.BillWithStoreID.AmountPay then
    round((ISNULL(dbo.BillWithStoreID.Amount - ISNULL(dbo.BillWithStoreID.AmountPay,0), 0) - isnull(InterestRate,0)*dbo.BillWithStoreID.EntrySum/100),2)
    else
    ISNULL(dbo.BillWithStoreID.Amount - ISNULL(dbo.BillWithStoreID.AmountPay,0), 0) end
    +isnull(dbo.PayToBill.Amount,0)
     AS Balance, 
                      isnull(dbo.PayToBill.Amount,0) AS ApplyAmount,
                      dbo.BillWithStoreID.BillDate, cast(0 as bit) as Apply
FROM         dbo.BillWithStoreID  Left Outer join
    dbo.Credit On dbo.Credit.CreditID=BillWithStoreID.TermsID and dbo.Credit.Status>0 full outer JOIN
             dbo.PayToBill ON dbo.BillWithStoreID.BillID = dbo.PayToBill.BillID and SuppTenderID=@PaymentID and dbo.PayToBill.Status > 0 FUll outer JOIN
             dbo.SupplierTenderEntry ON dbo.PayToBill.SuppTenderID = dbo.SupplierTenderEntry.SuppTenderEntryID and dbo.SupplierTenderEntry.Status > 0
where dbo.BillWithStoreID.SupplierID = @SupplierID and dbo.BillWithStoreID.Status>0 and dbo.BillWithStoreID.ReceiveStatus>0 and DBO.BillWithStoreID.StoreID=@StoreID and (dbo.BillWithStoreID.AmountPay <> dbo.BillWithStoreID.Amount Or SuppTenderEntryID=@PaymentID)
GO