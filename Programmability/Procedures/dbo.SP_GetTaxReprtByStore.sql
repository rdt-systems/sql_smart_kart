SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetTaxReprtByStore]
	(@StartDate DateTime,
	@EndDate DateTime,
	@StoreID uniqueidentifier =null)
AS
BEGIN


Select
    TransactionEntry.TaxRate,
    Sum(TransactionEntry.TotalAfterDiscount) As TotalSales, 
    Sum(TransactionEntry.TotalAfterDiscount * (Case When TransactionEntry.Taxable = 1 AND [Transaction].TaxID is not null  then IsNull([TransactionEntry].TaxRate, 0)  Else 0    End) / 100) As Tax,
	SUM(CASE WHEN TransactionEntry.Taxable = 0  AND [Transaction].TaxID is not null THEN TransactionEntry.TotalAfterDiscount ELSE 0 END) As NoonTaxbleSales,
	SUM(CASE WHEN [Transaction].TaxID is null THEN TransactionEntry.TotalAfterDiscount ELSE 0 END)As TotalExempt ,
	Sum(TransactionEntry.TotalAfterDiscount) - 
		SUM(CASE WHEN TransactionEntry.Taxable = 0  AND [Transaction].TaxID is not null THEN TransactionEntry.TotalAfterDiscount ELSE 0 END)-
		SUM(CASE WHEN [Transaction].TaxID is null THEN TransactionEntry.TotalAfterDiscount ELSE 0 END)As TaxbleSales ,
	Store.StoreName
From
    TransactionEntry Inner Join
    [Transaction] On TransactionEntry.TransactionID = [Transaction].TransactionID Inner Join
    Store On Store.StoreID = [Transaction].StoreID 
Where
    TransactionEntry.Status > 0 And
    [Transaction].Status > 0 AND
	TransactionEntry.TaxRate is not null and
	 (EndSaletime >= @StartDate) AND (EndSaletime < @EndDate + 1) AND ([Transaction].StoreID = @StoreID OR @StoreID is Null) 
--	and EndSaletime>'2020-10-10'
--  And EndSaletime<'2020-10-13'
Group By
    TransactionEntry.TaxRate,
    Store.StoreName

--SELECT        Sales.StoreName, Sales.TaxRate, SUM(Sales.TotalAfterDiscount) AS TotalSales, Taxble.TotalSales AS TaxbleSales, 
--CASE WHEN (SUM(Sales.TotalAfterDiscount) - Taxble.TotalSales - NotTaxble.TotalSales) >0 THEN  SUM(Sales.TotalAfterDiscount) - Taxble.TotalSales - NotTaxble.TotalSales ELSE 0 END AS TotalExempt, 
--                         NotTaxble.TotalSales AS NoonTaxbleSales, Taxble.SalesTax AS Tax
--FROM            TransactionEntryItem AS Sales LEFT OUTER JOIN
--                             (SELECT        TE.TaxRate, TE.StoreID, SUM(Te.TotalSales *te.TaxRate /100) AS SalesTax, SUM(TE.TotalSales) AS TotalSales
--                               FROM            [Transaction] AS T INNER JOIN
--                                                             (SELECT        TransactionID, TaxRate, StoreID, SUM(TotalAfterDiscount) AS TotalSales
--                                                               FROM            TransactionEntryForTax
--                                                               WHERE        (ISNULL(Taxable, 0) = 1) AND  ISNULL(TaxCollected,0) <> 0 AND (StartSaleTime >= @StartDate) AND (StartSaleTime < @EndDate +1)
--                                                               GROUP BY TransactionID, TaxRate, StoreID) AS TE ON T.TransactionID = TE.TransactionID AND T.Tax <> 0
--                               WHERE        (T.Status > 0)
--                               GROUP BY TE.TaxRate, TE.StoreID) AS Taxble ON Sales.StoreID = Taxble.StoreID AND Sales.TaxRate = Taxble.TaxRate LEFT OUTER JOIN
--                             (SELECT        TE.TaxRate, TE.StoreID, SUM(T.Tax) AS SalesTax, SUM(TE.TotalSales) AS TotalSales
--                               FROM            [Transaction] AS T INNER JOIN
--                                                             (SELECT        TransactionID, TaxRate, StoreID, SUM(TotalAfterDiscount) AS TotalSales
--                                                               FROM            TransactionEntryForTax
--                                                               WHERE       1=1
--															--   and   (ISNULL(Taxable, 0) = 0) 
--															   AND ISNULL(TaxCollected,0) = 0  
--															   AND (StartSaleTime >= @StartDate) AND (StartSaleTime < @EndDate+1 )
--                                                               GROUP BY TransactionID, TaxRate, StoreID) AS TE ON T.TransactionID = TE.TransactionID
--                               WHERE        (T.Status > 0)
--                               GROUP BY TE.TaxRate, TE.StoreID) AS NotTaxble ON Sales.StoreID = NotTaxble.StoreID AND Sales.TaxRate = NotTaxble.TaxRate
--WHERE        (Sales.StartSaleTime >= @StartDate) AND (Sales.StartSaleTime < @EndDate + 1) AND (Sales.StoreID = @StoreID ) OR
--                         (Sales.StartSaleTime >= @StartDate) AND (Sales.StartSaleTime < @EndDate + 1) AND (@StoreID IS NULL)
--GROUP BY Sales.TaxRate, Sales.StoreID, Sales.StoreName, Taxble.TotalSales, NotTaxble.TotalSales, Taxble.SalesTax
END
GO