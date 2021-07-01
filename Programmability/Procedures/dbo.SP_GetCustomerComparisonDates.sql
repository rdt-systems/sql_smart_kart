SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetCustomerComparisonDates] (
	@CurentFDate as date,
	@CurentToDate as date,
	@ComparisonFDate as date,
	@ComparisonToDate as date,
	@StoreID uniqueidentifier = NULL)


AS



 
SELECT        ISNULL(CurentPeriod.CurentQty, 0) AS CurentQty, ISNULL(CurentPeriod.CurentSales, 0) AS CurentSales, ISNULL(ComparisonPeriod.ComparisonQty, 0) AS ComparisonQty, ISNULL(ComparisonPeriod.ComparisonSales, 0) 
                         AS ComparisonPeriod, Customer.CustomerNo, ISNULL(Customer.LastName, '') + ' ' + ISNULL(Customer.FirstName, '') AS CustomerName, ISNULL(ComparisonPeriod.Department, CurentPeriod.Department) AS Department, 
                         ISNULL(CurentPeriod.CurentQty, 0) - ISNULL(ComparisonPeriod.ComparisonQty, 0) AS QtyChange, ISNULL(CurentPeriod.CurentSales, 0) - ISNULL(ComparisonPeriod.ComparisonSales, 0) AS DolarChange
FROM            (SELECT        ISNULL(Department, 'NoDepartment') AS Department, SUM(QTY) AS ComparisonQty, SUM(TotalAfterDiscount) AS ComparisonSales, CustomerID
                          FROM            TransactionEntryItem AS TransactionEntryItem_1
                          WHERE        (StartSaleTime > @ComparisonFDate) AND (StartSaleTime < DATEADD(day, 1, @ComparisonToDate)) AND (StoreID = @StoreID OR
                                                    @StoreID IS NULL)
                          GROUP BY ISNULL(Department, 'NoDepartment'), CustomerID) AS ComparisonPeriod RIGHT OUTER JOIN
                         Customer ON ComparisonPeriod.CustomerID = Customer.CustomerID LEFT OUTER JOIN
                             (SELECT        ISNULL(Department, 'NoDepartment') AS Department, SUM(QTY) AS CurentQty, SUM(TotalAfterDiscount) AS CurentSales, CustomerID
                               FROM            TransactionEntryItem
                               WHERE        (StartSaleTime > @CurentFDate) AND (StartSaleTime < DATEADD(day, 1, @CurentToDate)) AND (StoreID = @StoreID OR
                                                         @StoreID IS NULL)
                               GROUP BY ISNULL(Department, 'NoDepartment'), CustomerID) AS CurentPeriod ON Customer.CustomerID = CurentPeriod.CustomerID
WHERE        (ISNULL(CurentPeriod.CurentQty, 0) <> 0) OR
                         (ISNULL(ComparisonPeriod.ComparisonQty, 0) <> 0)
GO