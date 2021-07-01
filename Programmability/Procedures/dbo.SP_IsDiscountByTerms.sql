SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_IsDiscountByTerms] 
@BillID uniqueidentifier,
@QnlyReceiveID bit

as 

select ReceiveID,BillNo,Convert(nvarchar,BillDate,111) as BillDate
from ReceiveOrderView 
where (@QnlyReceiveID=1 Or (isnull(Discount,0)>0 And TermsID is not Null and Amount=AmountPay)) and BillID=@BillID
GO