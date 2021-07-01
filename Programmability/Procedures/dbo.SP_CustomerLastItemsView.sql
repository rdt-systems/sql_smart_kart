SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerLastItemsView]
(
@DateModified datetime=null
)
AS 

 CREATE TABLE #trans(
    [ID] [nvarchar](100) NULL,
	[BarcodeNumber] [nvarchar](100) NULL,
	[StartSaleTime] [datetime] NULL,
	[Price] [money] NULL,
    [Name] [nvarchar](200) NULL,
	[ModalNumber] [nvarchar](100) NULL,
	[CustomerID] [uniqueidentifier] NULL,
    [TransactionNo] [nvarchar](100) NULL,
	[Qty] [decimal] NULL,
	[ReturenQty] [float] NULL,
	[DateModified] [datetime] NULL,
    [Status] [int] NULL
)

select CustomerID,DateModified into #Cust from dbo.Customer where (DateModified> @DateModified or @DateModified is null) 


declare @B as int=1
DECLARE @CustID as uniqueidentifier
DECLARE @D as DateTime

SET @B= (SELECT COUNT(*) FROM #Cust)
WHILE @B > 0                    
BEGIN

		Select Top(1) @CustID=CustomerID,@D=DateModified from #Cust
		print convert(nvarchar(50),@CustID)
		INSERT INTO #trans
		SELECT top(5)CONVERT(varchar(100), Cast(ROW_NUMBER() OVER (PARTITION BY CustomerID
		  ORDER BY StartSaleTime desc,CustomerID  ) as decimal(38, 0)))+convert(nvarchar(50),CustomerID) AS ID,    
	ItemMain.BarcodeNumber, [Transaction].StartSaleTime, TransactionEntry.UOMPrice AS Price, ItemMain.Name, ItemMain.ModalNumber, [Transaction].CustomerID, [Transaction].TransactionNo, 
							 TransactionEntry.UOMQty AS Qty,  ISNULL(ReturnTrans.TotalReturn, 0) AS ReturenQty,@D,1 As Status
	FROM            dbo.[Transaction] WITH (NOLOCK) INNER JOIN
							 dbo.TransactionEntry WITH (NOLOCK)   ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
							 dbo.ItemStore ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID INNER JOIN
							 dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID  LEFT OUTER JOIN
								 (Select Distinct
		Sum(Case
			When M.ItemType = 4
			Then 1
			Else T.UOMQty
		End) As TotalSale,
		Sum(IsNull(R.Qty, 0)) As TotalReturn,
		T.TransactionEntryID
	From
		dbo.TransactionEntry As T WITH (NOLOCK)  Inner Join
		dbo.ItemStore As S On T.ItemStoreID = S.ItemStoreID Inner Join
		dbo.ItemMain As M On S.ItemNo = M.ItemID Left Outer Join
		(Select
			 TransReturen.ReturenTransID,
			 Sum(TransReturen.Qty) As Qty
		 From
			 dbo.TransReturen WITH (NOLOCK) 
		 Where
			 TransReturen.Status > 0
		 Group By
			 TransReturen.ReturenTransID) As R On T.TransactionEntryID = R.ReturenTransID
	Where
		T.Status > 0 And
		T.TransactionEntryType = 0
	Group By
		T.TransactionEntryID) AS ReturnTrans ON TransactionEntry.TransactionEntryID = ReturnTrans.TransactionEntryID where CustomerID=@custID

		delete from #Cust  where CustomerID=@CustID
  SET @B=@B-1
END
Select * from #trans 
drop table #Cust 
drop table #trans
GO