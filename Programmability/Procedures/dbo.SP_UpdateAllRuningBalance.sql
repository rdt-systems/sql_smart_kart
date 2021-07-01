SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		NathanErenthal
-- ALTER date: 1/2/11
-- Description:	Update the runnig balance from TransactionID
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateAllRuningBalance](@Days int=null)
AS
BEGIN
UPDATE Customer SET BalanceDoe = SumBalance.SumBalance, DateModified = dbo.GetLocalDate()
FROM dbo.Customer WITH (NOLOCK) INNER JOIN 
(SELECT CustomerID, SUM(ISNULL(Debit, 0) - ISNULL(Credit, 0)) AS SumBalance 
FROM dbo.[Transaction] WITH (NOLOCK) WHERE (Status > 0)   GROUP BY CustomerID) AS SumBalance 
ON Customer.CustomerID = SumBalance.CustomerID AND Customer.BalanceDoe <> SumBalance.SumBalance

declare @CustomerID uniqueidentifier
declare @S varchar(100)
declare @TransID uniqueidentifier
DECLARE @I integer
SET @I = 0
declare B cursor  for select CustomerID,IsNUll(LastName,'')+' '+IsNull(Firstname,'')as [Name] from dbo.Customer WITH (NOLOCK) order By Lastname,FirstName
OPEN B

fetch next from B into @CustomerID,@S
while @@fetch_status = 0 begin
    if @Days is null
	  set @TransID = (select top(1) Transactionid from dbo.[Transaction] WITH (NOLOCK) where customerid=@CustomerID ORDER BY DateCreated)
	else
	  set @TransID = (select top(1) Transactionid from dbo.[Transaction] WITH (NOLOCK)  where customerid=@CustomerID and DateModified > dbo.GetLocalDATE()-@Days ORDER BY DateCreated)
	if @TransID is not null begin
		EXEC [SP_UpdateRuningBalance]@TransactionID = @TransID
	end 

	SET @I =@I+1
	print 'No: '+CONVERT(char(20),@I)+' '+@S
	fetch next from B into @CustomerID ,@S
end
close B
deallocate B
END
GO