SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemHourlySales]
(@date datetime = null,
 @Filter nvarchar(4000) = NULL,
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000)
)
AS 



if (@date is null) set @date = dbo.GetLocalDATE()

Declare @MyWhere nvarchar(4000)
DEclare @MySecondWhere nvarchar(4000)

Declare @MyFirstSelect nvarchar(4000)
Declare @MySecondSelect nvarchar(4000)
Declare @MyThirdlySelect nvarchar(4000)

Declare @CustomerWhere nvarchar(4000)
Declare @ItemSelect nvarchar(4000)
Declare @CustomerSelect nvarchar(4000)

Set  @ItemSelect=' Select Distinct ItemStoreID 
				   Into #ItemSelect 
                   From ItemsRepFilter 
                   Where (1=1) '

SET @MyWhere  = ' WHERE  ItemStoreID in (Select ItemStoreID From #ItemSelect ) '

SET @MyWhere= @MyWhere + ' And Entry.Status>0 And
			  (T.TransactionType = 0 Or T.TransactionType = 3) AND
			  (T.Status > 0)  and
              (dbo.FormatDateTime(T.EndSaleTime, ''SHORTDATE'') = Dbo.FormatDateTime( ''' 

SET @MySecondWhere =  ''' ,''SHORTDATE'')) and 
			  (Entry.TransactionEntryType <> 4)  '

 
Set  @CustomerSelect=' Select CustomerID 
					  Into #CustomerSelect 
					  From CustomerRepFilter 
					  Where (1=1) '
IF @CustomerFilter = '' 
  SET @CustomerSelect = ''
ELSE
	SET @CustomerWhere =	' And CustomerID in (Select CustomerID From #CustomerSelect) '



SET @MyFirstSelect = ' SELECT  T.TransactionID,Entry.Total,T.CustomerID,T.EndSaleTime,T.RegisterID,Entry.Qty,T.StoreID
					Into #Temp1
					FROM        TransactionEntry  as Entry INNER JOIN 
		            [Transaction] as T ON T.TransactionID = Entry.TransactionID  '
  

SET @MySecondSelect ='
		  
SELECT                StoreID,
					  dbo.FormatDateTime(EndSaleTime, ''SHORTDATE'') AS Date ,
                      dbo.GetHourFromToFormat(EndSaleTime,1) AS Hour,
					  SUM(Total) AS Debit, 
                      COUNT(DISTINCT RegisterID) AS Registers, 

					  ROUND(SUM(Total) / CAST
					  (
                      ( SELECT   SUM(Debit) 
                        FROM [Transaction] 
                        Where dbo.FormatDateTime(EndSaleTime, ''SHORTDATE'') = Dbo.FormatDateTime(#Temp1.EndSaleTime,''SHORTDATE'')And 
					          (TransactionType = 0 Or TransactionType = 3) AND
                              (Status > 0) And 
                              (StoreID=#Temp1.StoreID) '
                            

Set @MyThirdlySelect  = ' ) AS float) * 100, 2)
                      AS SalePrec,
                      COUNT(DISTINCT CustomerID) AS Customers,
					  COUNT(CustomerID) AS TransactionWithCustomer,
					  COUNT(CustomerID) / CAST(COUNT(1) AS float) * 100 AS CustomerPrec,
                          (SELECT     SUM(Total) AS Expr1
                           FROM       #Temp1 
						   WHERE      (CustomerID IS NOT NULL) AND
                                      (dbo.GetHourFromToFormat(EndSaleTime,1) = dbo.GetHourFromToFormat(EndSaleTime,1))
						   )AS CustomerDebit,
				     SUM(Qty) AS Items, 
                     MAX(EndSaleTime) AS OrderCol
FROM        #Temp1 
GROUP BY dbo.FormatDateTime(EndSaleTime, ''SHORTDATE''), StoreID,
         dbo.GetHourFromToFormat(EndSaleTime,1)
ORDER BY OrderCol '

--print (@ItemSelect + @ItemFilter  + @CustomerSelect+ @MyFirstSelect + @MyWhere + CONVERT(nvarchar(20),@Date) + @MySecondWhere + @CustomerWhere + @Filter + @MySecondSelect + @CustomerWhere + @MyThirdlySelect)

Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MyFirstSelect + @MyWhere + @Date + @MySecondWhere + @CustomerWhere + @Filter + @MySecondSelect + @CustomerWhere + @MyThirdlySelect)
     
 /*   ((@Department IS NOT NULL AND @Department=Entry.DepartmentID) OR (@Department is null And Entry.DepartmentID is Null)) And
		 (@StoreID is NULL OR T.StoreID=@StoreID)AND
         (@CustomerID is NULL OR T.CustomerID=@CustomerID) AND
		 (ItemStore.ItemNo=@ItemID Or (@ItemID='00000000-0000-0000-0000-000000000000' And Entry.ItemStoreID='00000000-0000-0000-0000-000000000000'))*/
GO