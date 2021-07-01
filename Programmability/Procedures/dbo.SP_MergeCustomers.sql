SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MergeCustomers]
(	
	@FromCustomerID uniqueidentifier,
	@ToCustomerID uniqueidentifier,
	@ModifierID uniqueidentifier)
As 

IF NOT @FromCustomerID = @ToCustomerID

BEGIN

 declare @oldCustomerName nvarchar(500)
 select  @oldCustomerName =isnull(customer.CustomerNo,'')+' '+isnull(FirstName,'')+isnull(LastName,'')
 from customer 
 where customer.CustomerID=@FromCustomerID


exec SP_SaveRecentActivity 1,'Customer',1,@ToCustomerID,1,'CustomerID',@ModifierID,@oldCustomerName

print 'A'
update dbo.[Transaction]
set CustomerID=@ToCustomerID,
	DateModified=dbo.GetLocalDATE()
where CustomerID=@FromCustomerID   --and TransactionType<>2


--update dbo.[Transaction]
--set Status=-1,
--	DateModified=dbo.GetLocalDATE()
--where CustomerID=@FromCustomerID and TransactionType=2--OpenBalance
print 'B'
update dbo.WorkOrder
set CustomerID=@ToCustomerID,
	DateModified=dbo.GetLocalDATE()
where CustomerID=@FromCustomerID

print 'C'
update dbo.CustomerMemberCards 
set CustomerID=@ToCustomerID,
	DateModified=dbo.GetLocalDATE()
where CustomerID=@FromCustomerID


print 'E'
declare @TransID uniqueidentifier 
Set @TransID =( Select Top(1)TransactionID from [Transaction] Where status>0 and CustomerID =@ToCustomerID Order by StartSaleTime)
if @TransID is not null
  EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @TransID

print 'F'
update Customer
set
BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID),0),
DateModified=dbo.GetLocalDATE()
WHERE CustomerID=@ToCustomerID

print 'G'
EXEC dbo.SP_CustomerDelete @FromCustomerID,@ModifierID

print 'H'
declare @CustomerID uniqueidentifier
declare @S varchar(100)
declare @TranID uniqueidentifier
DECLARE @I integer
SET @I = 0
declare B cursor  for 
select CustomerID,IsNUll(LastName,'')+' '+IsNull(Firstname,'')as [Name] from customer
WHERE CustomerID=  @ToCustomerID
order By Lastname,FirstName
OPEN B

fetch next from B into @CustomerID,@S
while @@fetch_status = 0 begin
	set @TranID = (SELECT TOP(1) Transactionid FROM [Transaction] WHERE customerid=@CustomerID ORDER BY DateCreated)
	if @TranID is not null begin
		EXEC [SP_UpdateRuningBalance]@TransactionID = @TranID
	end 

	SET @I =@I+1
	print 'No: '+CONVERT(char(20),@I)+' '+@S
	fetch next from B into @CustomerID ,@S
end
close B
deallocate B

print 'I'

END
GO