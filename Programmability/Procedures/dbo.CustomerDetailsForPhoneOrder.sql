SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE procedure [dbo].[CustomerDetailsForPhoneOrder]
(@CustomerID uniqueidentifier)
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

Declare @MaxTransaction as datetime
Set @MaxTransaction=(Select convert(Nvarchar,Max(StartSaleTime),111) from [Transaction] Where Status>-1 And Debit>0 And CustomerID=@CustomerID)

Declare @MaxWorkOrder as Datetime
Set @MaxWorkOrder=null--(Select convert(Nvarchar,Max(StartSaleTime),111) from dbo.WorkOrder Where Status>-1 And CustomerID=@CustomerID)

--Declare @LastPaymentID as uniqueidentifier
--Set @LastPaymentID=(Select Top 1 TransactionID from [Transaction] Where Status>-1 And CustomerID=@CustomerID And Credit>0 Order By StartSaleTime desc)

Declare @LastSaleID as uniqueidentifier
Set @LastSaleID =(Select Top 1 TransactionID from [Transaction] Where Status>-1 And CustomerID=@CustomerID And Debit>0 Order By StartSaleTime desc)

Select LockAccount, BalanceDoe,Credit, @MaxTransaction as LastVisit, (Select Debit from [Transaction] Where TransactionID=@LastSaleID) as LastAmount,
--	(Select Case when isnull(@MaxTransaction,'1753-01-01')>isnull(@MaxWorkOrder,'1753-01-01') then convert(Nvarchar,@MaxTransaction,111) else convert(Nvarchar,@MaxWorkOrder,111) end)as LastVisit,
	LastPaymentDate as LastPayDate,	
	--(Select Credit from [Transaction] Where TransactionID=@LastPaymentID) 
	IsNull(LastPayment,0) as LastPayment,
	FoodStampCode,CreditCardNO , FoodStampNo, DateCreated,  Cleared.LastDateCleared,
	 Over120 , Over30 , Over60 , Over90 , LockOutDays,RegularPaymentType 
	,(Select cast(g.CustomerGroupName as varchar(30))+ ','  from CustomerToGroup cg inner join dbo.CustomerGroup g on cg.CustomerGroupID = g.CustomerGroupID where cg.CustomerID = @CustomerID and cg.Status>0 
 for xml path ('')) As GroupName,CustomerNo
	from Customer LEFT OUTER JOIN
	 (SELECT DISTINCT CustomerID, MAX(StartSaleTime) AS LastDateCleared
                               FROM            [Transaction] AS Transaction_3
                               WHERE        (Status > 0) AND (CurrBalance <= 0) AND (CustomerID IS NOT NULL)
                               GROUP BY CustomerID) AS Cleared ON Customer.CustomerID = Cleared.CustomerID
Where Customer.CustomerID=@CustomerID
GO