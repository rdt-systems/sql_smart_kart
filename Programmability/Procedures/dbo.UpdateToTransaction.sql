SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[UpdateToTransaction] 
(
@startsaletime datetime,
@CustomerID uniqueidentifier,
@OldTime datetime=null
)
as
update [Transaction]
set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
		 FROM [Transaction] tr
		 WHERE [Transaction].customerid = tr.customerid AND tr.startsaletime <= [Transaction].startsaletime and Status>0
		 And StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID) )
Where CustomerID=@CustomerID and (startsaletime>=@startsaletime or startsaletime>=isnull(@OldTime,@startsaletime))

--update [w_Transaction]
--set currBalance=(SELECT currBalance
--		 FROM [Transaction] tr
--		 WHERE [w_Transaction].transactionid = tr.transactionid)
--Where CustomerID=@CustomerID and (startsaletime>=@startsaletime or startsaletime>=isnull(@OldTime,@startsaletime))
--

EXEC CustomerBalanceUpdate @CustomerID
GO