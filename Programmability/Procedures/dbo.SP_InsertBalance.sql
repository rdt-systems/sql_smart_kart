SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_InsertBalance]
(@CustomerID uniqueidentifier,
@Balance decimal(19,3),
@BalanceDate datetime='1753/1/1',
@UserID UniqueIdentifier= NULL,
@StoreID UniqueIdentifier=null)
as
/*declare @NewCustomer bit
set @NewCustomer = isnull((select 1 from customer where customerid=@CustomerID and Datediff(minute,dbo.GetLocalDATE(),DateCREATE) > -2),0) 

if @NewCustomer = 0
	return*/

UPDATE dbo.Customer

SET 	
	BalanceDoe = isnull(@Balance,0),
	StartBalance= isnull(@Balance,0),
	StartBalanceDate= @BalanceDate,
	DateModified=dbo.GetLocalDATE()

WHERE   (CustomerID = @CustomerID)

DECLARE @TransactionID uniqueidentifier
SELECT @TransactionID = newid()
DECLARE @TransactionNo nvarchar(50)
if @StoreID is null
	set @TransactionNo = (SELECT top 1 StoreSymbol+'-'+convert(varchar,isnull(SeqNumber,0)+1) from dbo.numberSettings Where TableName='invoice')
else
	set @TransactionNo = (SELECT top 1 StoreSymbol+'-'+convert(varchar,isnull(SeqNumber,0)+1) from dbo.numberSettings Where TableName='invoice' and StoreID=@StoreID)


if @Balance>=0 
begin
	
	EXEC dbo.SP_TransactionBOInsert @TransactionID,@TransactionNo, 2, 0, null, null, @CustomerID, @Balance, 0, 
		@BalanceDate, @BalanceDate, @BalanceDate, 0, 0, null, null, null, null, null, 
		null, null, null, null, null, null, null,null, null, null, null, 1, @UserID, NULL
end 
else if @Balance<0 
begin
	EXEC dbo.SP_TransactionBOInsert @TransactionID,@TransactionNo, 2, 0, null, null, @CustomerID, @Balance,0, 
		@BalanceDate, @BalanceDate, @BalanceDate, 0, 0, null, null, null, null, null, 
		null, null, null, null, null, null, null,null, null, null, null, 1, @UserID, NULL
	
end 

update dbo.numberSettings set SeqNumber=isnull(SeqNumber,0)+1 Where TableName='invoice' and StoreID=@StoreID

if @CustomerID is not null
begin
	EXEC dbo.CustomerBalanceUpdate @CustomerID

update dbo.[Transaction]
set currBalance=(SELECT round(SUM(Debit) - SUM(Credit), 2)
		 FROM [Transaction] tr
		 WHERE [Transaction].customerid = tr.customerid AND tr.EndSaleTime <= [Transaction].EndSaleTime and Status>0
		 And (EndSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID) or EndSaleTime is null))
where status>0 and CustomerID=@CustomerID 

end
GO