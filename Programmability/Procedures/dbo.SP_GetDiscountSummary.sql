SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetDiscountSummary]
(@Filter nvarchar(4000),
@CustomerFilter nvarchar(4000))
AS 

Declare @BaseFilter nvarchar(4000)
--set @BaseFilter='(TransactionEntry.TransactionEntryType = 4) AND 
--			     (TransactionEntry.Status > 0) AND	
--			     (TransactionEntry.UOMPrice <> 0) AND	
--		         (dbo.[Transaction].Status > 0)'
		        
set @BaseFilter='(TransactionEntry.TransactionEntryType = 4) AND 
			     (TransactionEntry.Status > 0) AND	
		         (dbo.[Transaction].Status > 0)'		        

declare @MyWhere nvarchar(4000)
if @CustomerFilter<>''
	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							   Into #CustomerSelect 
							   From CustomerRepFilter 
							   Where (1=1) '
		SET @MyWhere=  ' AND exists (Select 1 From #CustomerSelect where CustomerID=dbo.[Transaction].CustomerID) '
	end 
 else
     SET @MyWhere= ''

--*********************************************

declare @Select nvarchar(4000)
set @select = '
	SELECT isnull(dbo.Discounts.DiscountID,dbo.Credit.CreditID) as DiscountID,
		   isnull(''Discount: '' + dbo.Discounts.Name, isnull(''Term : '' + dbo.Credit.Name,''[MANUAL DISCOUNT]'')) as Name, 
           isnull(dbo.Discounts.PercentsDiscount,dbo.Credit.InterestRate) as PercentsDiscount,
		   dbo.Discounts.AmountDiscount,
		   dbo.Discounts.StartDate,
		   dbo.Discounts.EndDate,
		   dbo.Discounts.UPCDiscount,
		   (CASE WHEN dbo.Discounts.StartDate is null and dbo.Discounts.EndDate is null THEN ''Active''
				 WHEN Convert(nvarchar,dbo.Discounts.StartDate,101)<= Convert(nvarchar,dbo.GetLocalDATE(),101) and Convert(nvarchar,dbo.Discounts.EndDate,101)>= Convert(nvarchar,dbo.GetLocalDATE(),101) THEN ''Active''
				 ELSE ''InActive''
			END) as Status,
		   Count(Distinct dbo.[Transaction].CustomerID) as CustomersNo,
		   Count(dbo.[Transaction].TransactionID) as TransactionsCount,
		   SUM(TotalQtyTransaction.TotalQty) as TotalQty,
		   SUM((TotalQtyTransaction.Total) +isnull(TotalReturn,0)+ isnull(disRetern,0)) as TotalBeforeDiscount,
		   --(SUM([Transaction].Debit) + SUM(ISNULL(TransactionEntry.UOMPrice, 0))) AS TotalBeforeDiscount,
		  SUM(ISNULL(TransactionEntry.UOMPrice, 0)   +isnull(disRetern,0) ) AS DiscountTotal,
		   SUM(dbo.[Transaction].Debit+isnull(TotalReturn,0))-SUM(ISNULL(dbo.[Transaction].Tax,0)) as SalesTotalWithoutTax,
   		   SUM(dbo.[Transaction].Debit + isnull(TotalReturn,0)+ISNULL(TotalReturnTax,0)) as SalesTotal,
		   dbo.[Transaction].StoreID,
		   MyStore.StoreName
				 

	FROM   dbo.TransactionEntry WITH (NOLOCK)
		   LEFT OUTER JOIN
                   dbo.Discounts  ON TransactionEntry.ItemStoreID = dbo.Discounts.DiscountID AND dbo.Discounts.Status > 0
		   LEFT OUTER JOIN
                   dbo.Credit  ON TransactionEntry.ItemStoreID = dbo.Credit.CreditID AND dbo.Credit.Status > 0
		   INNER JOIN
                   dbo.[Transaction] WITH (NOLOCK) ON dbo.[Transaction].TransactionID = TransactionEntry.TransactionID
		   INNER JOIN
                   (select TransactionEntry.TransactionID,sum(TransactionEntry.Qty) as TotalQty,sum(TransactionEntry.Total) as Total ,sum(ter.Total) as TotalReturn, min(trr.Tax) TotalReturnTax 
				   ,sum(((TransactionEntry.Total -TransactionEntry.TotalAfterDiscount) /TransactionEntry.Qty)*ter.Qty) as disRetern
					from dbo.TransactionEntry

					left outer join TransReturen on TransReturen.ReturenTransID = TransactionEntry.TransactionEntryID 
					left outer join TransactionEntry ter on ter.TransactionEntryID =TransReturen.SaleTransEntryID and ter.Status>0
					LEFT OUTER JOIN [Transaction] trr on trr.TransactionID =ter.TransactionID and trr.Status>0


					where TransactionEntry.Status>0 And TransactionEntry.TransactionEntryType = 0
AND ((TransactionEntry.Total - TransactionEntry.TotalAfterDiscount)<>0)
					group by TransactionEntry.TransactionID)as TotalQtyTransaction ON TotalQtyTransaction.TransactionID = dbo.[Transaction].TransactionID 
INNER JOIN
                             (SELECT        StoreID AS MyStoreID, StoreName, StoreNumber
                               FROM            Store AS Store_1) AS myStore ON [Transaction].StoreID = myStore.MyStoreID
		  
	WHERE  '

declare @GroupBy nvarchar(4000)
set @GroupBy ='

	GROUP BY  dbo.Discounts.DiscountID, 
		      dbo.Discounts.Name,
		      dbo.Discounts.PercentsDiscount, 
		      dbo.Discounts.AmountDiscount,
		      dbo.Discounts.StartDate,
		      dbo.Discounts.EndDate, 
              dbo.Discounts.UPCDiscount,
			  dbo.Credit.CreditID,
			  dbo.Credit.Name,
			  dbo.Credit.InterestRate,
			  dbo.[Transaction].StoreID,
			  MyStore.StoreName '
			  
--insert into sqlStatmentLog(sqlString) values(@select  + @BaseFilter + @MyWhere + @Filter + @GroupBy)			  
print(@select  + @BaseFilter + @MyWhere + @Filter + @GroupBy   )
exec ( @CustomerSelect + @CustomerFilter + @select  + @BaseFilter + @MyWhere + @Filter + @GroupBy   )


if @CustomerFilter<>''
drop table #CustomerSelect
GO