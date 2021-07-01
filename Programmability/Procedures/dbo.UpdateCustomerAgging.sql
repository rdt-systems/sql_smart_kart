SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateCustomerAgging]
(@CustomerID uniqueidentifier
)

AS 

delete from [PaymentDetails] where Transactionid in(select Transactionid from [transaction] where customerid=@CustomerID)
update [transaction] set leftdebit = debit-credit where Debit<0 and customerid = @CustomerID 
update [transaction] set leftdebit = debit where Debit>=0 and customerid = @CustomerID 
print 'end delete'
declare @TransactionID uniqueidentifier	
--declare @CustomerID uniqueidentifier
declare @EndSaleTime datetime
declare @Debit Money
declare @Credit Money
DECLARE @ModifierID uniqueidentifier
DECLARE @AmountToApply money
DECLARE @DebitToPay money
DECLARE @ApplySettings smallint
DECLARE @I integer
SET @I = 0
declare C cursor  for select TransactionID from [Transaction] WHERE customerid  = @CustomerID AND Status>0  ORDER BY StartSaleTime
print 'ABC 1'
OPEN C
print 'ABC 2'
fetch next from C into @TransactionID
while @@fetch_status = 0 begin 
SET @I =@I+1
print 'No: '+CONVERT(char(20),@I)
--set @CustomerID= (select CustomerID from [Transaction] where TransactionID=@TransactionID)
set @EndSaleTime=(select EndSaleTime from [Transaction] where TransactionID=@TransactionID)
print '@EndSaleTime '+CONVERT(char(20),@EndSaleTime) 
set @Debit= (select Debit from [Transaction] where TransactionID=@TransactionID)
print 'Debit '+CONVERT(char(20),@Debit) 
set @Credit= (select Credit from [Transaction] where TransactionID=@TransactionID)
print 'Credit '+CONVERT(char(20),@Credit) 
set @ModifierID= (select UserModified from [Transaction] where TransactionID=@TransactionID)
	        if @EndSaleTime>=IsNull((select Max(EndSaleTime) From [Transaction] Where Status>0 and customerID=@CustomerID and transactionType=2),'1753/1/1')
			begin
				SET @AmountToApply=@Credit

					IF (@Debit<0 )--for return transaction
				    BEGIN
						SET @AmountToApply=@Credit-@Debit
print '1 AmountToApply '+CONVERT(char(20),@AmountToApply )
                    END
					IF (@AmountToApply>0)
                    BEGIN
						EXEC ApplyOldDebits @AmountToApply,@TransactionID,@CustomerID,@ModifierID
print 'EXEC ApplyOldDebits'
				    END
				
					SET @DebitToPay=(select LeftDebit from dbo.LeftDebitsView where TransactionID=@TransactionID)
print 'DebitToPay '+CONVERT(char(20),@DebitToPay )
					IF (@DebitToPay>0)
						EXEC PayDebitsFromOverPayments @DebitToPay,@TransactionID,@CustomerID,@ModifierID
			end
	--*******************************************************************************************  
fetch next from C into @TransactionID 
end
close C 
deallocate C



SELECT   customerID ,dbo.GetAgingDiff(isnull(duedate,EndSaleTime),dbo.GetLocalDATE()) AS MonthDif,  SUM(isnull(LeftDebit,debit)) AS DebitByDays
INTO #MyTemp
FROM  [Transaction]
where (transactionType=0 or TransactionType=2 or TransactionType=4) and leftdebit>0 and status>0 
And EndSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID)AND CustomerID = @customerID
group by CustomerID,dbo.GetAgingDiff(isnull(duedate,EndSaleTime),dbo.GetLocalDATE()) having SUM(isnull(LeftDebit,debit))>0

--declare @tempCust uniqueidentifier
--declare Cur cursor forward_only static optimistic for
--select CustomerID from customer
--open Cur
--fetch next from Cur into @tempCust
--while @@fetch_status= 0
--begin


update Customer
set
BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID And EndSaleTime>=dbo.GetCustomerDateStartBalance(Customer.CustomerID) ),0),
[Current]=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=-1 AND CustomerID=Customer.CustomerID),0) ,
Over0=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=0 AND CustomerID=Customer.CustomerID),0) ,
Over30=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=1 AND CustomerID=Customer.CustomerID),0) ,
Over60=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=2 AND CustomerID=Customer.CustomerID),0) ,
Over90=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=3 AND CustomerID=Customer.CustomerID),0) ,
Over120=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=4 AND CustomerID=Customer.CustomerID),0) ,
DateModified=dbo.GetLocalDATE()
where CustomerID= @Customerid


--========================================
--fetch next from Cur into @tempCust
--end
--close Cur
--deallocate Cur
--========================================
                             
drop TABLE #MyTemp
GO