SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ChangeToOnAccount]
(

@CustomerID uniqueidentifier,
@TransID uniqueidentifier,
@Balance money
)

AS
declare @A varchar(50)
set @A = (SELECT dbo.GetLocalDATE())
--declare @OldCustomerID uniqueidentifier
--declare @lastTransactionDate dateTime 
--Select @OldCustomerID= CustomerID,
--       @lastTransactionDate = StartSaleTime
--       FROM [Transaction]  where Transactionno=@TransID

Update [dbo].[Transaction]
SET Credit = 0 ,Note =Note +' Changed To On Account '+@A,DateModified= dbo.GetLocalDATE()
WHERE TransactionID = @TransID

Update [dbo].[TenderEntry] 
SET Status  = 0 ,DateModified= dbo.GetLocalDATE()
WHERE TransactionID = @TransID

EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @TransID

update Customer
set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0),dateModified=dbo.GetLocalDATE()
where CustomerID = @CustomerID

update Customer set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0), DateModified =dbo.GetLocalDATE()
WHERE CustomerID IN(SELECT        C.CustomerID
From Customer C
Inner Join (Select CustomerID, (SUM(ISNULL(Debit, 0) - ISNULL(Credit, 0))) AS BAL From [Transaction] Where Status >0 group by CustomerID) As T on C.CustomerID = T.CustomerID
Where C.BalanceDoe < > T.BAL) 
 
--if @OldCustomerID is not null begin
--	update Customer
--	set BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID ),0),dateModified=dbo.GetLocalDATE()
--	where CustomerID = @OldCustomerID 

--declare @OldTransID uniqueidentifier

--	SET  @OldTransID =(SELECT top(1)    [Transaction].TransactionID
--			FROM         [Transaction] INNER JOIN
--          (SELECT     MAX(StartSaleTime) AS StartSaleTime, CustomerID
--            FROM          [Transaction] AS Transaction_1
--            WHERE      (CustomerID = @OldCustomerID and StartSaleTime<@lastTransactionDate)
--            GROUP BY CustomerID) AS Maxdate ON [Transaction].StartSaleTime = Maxdate.StartSaleTime AND [Transaction].CustomerID = Maxdate.CustomerID)
--    EXEC [dbo].[SP_UpdateRuningBalance] @TransactionID = @OldTransID
 
--end
GO