SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetClearBalanceOfCustomer] 
(
@CustomerID  uniqueidentifier,
@Days int
)
AS BEGIN

if @Days >=( select coalesce(datediff(day, max(t.StartSaleTime), dbo.GetLocalDATE()), 0) days_clear
from customer c
left join [transaction] t on t.CustomerID = c.CustomerID
  and t.Debit  = CurrBalance
  where T.Status>0 and C.customerid=@CustomerID 
group by C.customerid) 
select 1
else
select 0

--if
--(SELECT    COUNT(*)
--		FROM         dbo.[Transaction] tr 
--		WHERE     
--		--tr.TransactionType = 1 AND  
--		Status>0  AND  customerID=@CustomerID 
--		        and CurrBalance <= .10 and startsaletime>dateadd(day ,-(@Days),dbo.GetLocalDATE()))>0 
--select 1 

--else
--begin

--if(SELECT    COUNT(*)
--		FROM         dbo.Customer cus 
--		WHERE      Status>0  AND  customerID=@CustomerID 
--		        and balancedoe <= 0.10 )>0 
--select 1 

--else
--select 0
 
end
GO