SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ChangeTransactionCust]
(
@CustID uniqueidentifier,
@TransID uniqueidentifier,
@Balance money)

AS
	declare @A varchar(50)
	declare @OldCustomerID uniqueidentifier
	declare @OldBalance money
	declare @lastTransactionDate datetime
	set @A = (SELECT dbo.GetLocalDATE())

	Select Top(1) @OldCustomerID= CustomerID,
		   @lastTransactionDate = StartSaleTime
		   FROM [Transaction]  where Transactionid=@TransID

	 

	--PRINT @CustID
	Update [dbo].[Transaction]
	SET CustomerID = @CustID,Note =Note +' Changed Customer Account '+@A
	WHERE TransactionID = @TransID

	EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @TransID


	update dbo.Customer
	set BalanceDoe = (balancedoe + @Balance),datemodified=dbo.GetLocalDATE()
	where CustomerID = @CustID
	
	if @OldCustomerID is not null BEGIN
    	update Customer
		set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0),dateModified=dbo.GetLocalDATE()
		where CustomerID = @OldCustomerID 
update Customer set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0), DateModified =dbo.GetLocalDATE()
WHERE CustomerID IN(SELECT        C.CustomerID
From Customer C
Inner Join (Select CustomerID, (SUM(ISNULL(Debit, 0) - ISNULL(Credit, 0))) AS BAL From [Transaction] Where Status >0 group by CustomerID) As T on C.CustomerID = T.CustomerID
Where C.BalanceDoe < > T.BAL) 

	   declare @OldTransID uniqueidentifier

		SET  @OldTransID =(SELECT top(1)    [Transaction].TransactionID
				FROM         [Transaction] INNER JOIN
	          (SELECT     MAX(StartSaleTime) AS StartSaleTime, CustomerID
	            FROM          [Transaction] AS Transaction_1
	            WHERE      (CustomerID = @OldCustomerID and StartSaleTime<@lastTransactionDate)
	            GROUP BY CustomerID) AS Maxdate ON [Transaction].StartSaleTime = Maxdate.StartSaleTime AND [Transaction].CustomerID = Maxdate.CustomerID)
	    EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @OldTransID

	END
GO