SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DailyUpdateRunningBalance]
AS

--------------------Update Balance
update Customer set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0), DateModified =dbo.GetLocalDATE()
WHERE CustomerID IN(SELECT        C.CustomerID
From Customer C
Inner Join (Select CustomerID, (SUM(ISNULL(Debit, 0) - ISNULL(Credit, 0))) AS BAL From [Transaction] Where Status >0 group by CustomerID) As T on C.CustomerID = T.CustomerID
Where C.BalanceDoe < > T.BAL) 

------------------Update Running Balance

declare @CustomerID uniqueidentifier
declare @S varchar(100)
declare @TransID uniqueidentifier
DECLARE @I integer
SET @I = 0
declare B cursor  for 
select CustomerID,IsNUll(LastName,'')+' '+IsNull(Firstname,'')as [Name] from customer
--WHERE CustomerNo='(718)622-5278' 
order By Lastname,FirstName
OPEN B

fetch next from B into @CustomerID,@S
while @@fetch_status = 0 begin
	set @TransID = (SELECT TOP(1) Transactionid FROM [Transaction] WHERE customerid=@CustomerID ORDER BY DateCreated)
	if @TransID is not null begin
		EXEC [SP_UpdateRuningBalance]@TransactionID = @TransID
	end 

	SET @I =@I+1
	print 'No: '+CONVERT(char(20),@I)+' '+@S
	fetch next from B into @CustomerID ,@S
end
close B
deallocate B
GO