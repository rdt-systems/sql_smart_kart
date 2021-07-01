SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_Department_NPGS_Email_Report](
@From datetime,
@To datetime)

AS

SELECT        Name, Qty, [Ext Cost], [Total After Discount], Margin, Profit
FROM            (SELECT        1 AS Sort, ItemStoreID, Name, CAST(SUM(QTY) AS INT) AS Qty, '$' + CONVERT(nvarchar(25), CAST(SUM(ExtCost) AS money)) AS [Ext Cost], '$' + CONVERT(nvarchar(25), CAST(SUM(TotalAfterDiscount) AS money)) 
                                                    AS [Total After Discount], CAST(CAST((CASE WHEN SUM(TotalAfterDiscount) = 0 OR
                                                    SUM(Profit) <= 0 THEN 0 ELSE ((SUM(Profit)) / (SUM(TotalAfterDiscount) / 100)) END) AS numeric(10, 2)) AS nvarchar(5)) + '%' AS Margin, '$' + CONVERT(nvarchar(25), CAST(SUM(Profit) AS money)) AS Profit
                          FROM            TransactionEntryItem
                          WHERE       (DepartmentID IN ('6FD76CDA-8767-4B38-A6CD-259A4D7959A3', '15737F37-12B4-4877-8E07-FBB1161C63E4')) AND
						   (StartSaleTime >= @From) AND (StartSaleTime < @To)
                          GROUP BY ItemStoreID, Name
                          UNION
                          SELECT        2 AS Sort, '99999999-9999-9999-9999-999999999999' AS ItemStoreID, 'Total' AS Name, CAST(SUM(QTY) AS INT) AS Qty, '$' + CONVERT(nvarchar(25), CAST(SUM(ExtCost) AS money)) AS [Ext Cost], 
                                                   '$' + CONVERT(nvarchar(25), CAST(SUM(TotalAfterDiscount) AS money)) AS [Total After Discount], CAST(CAST((CASE WHEN SUM(TotalAfterDiscount) = 0 OR
                                                   SUM(Profit) <= 0 THEN 0 ELSE ((SUM(Profit)) / (SUM(TotalAfterDiscount) / 100)) END) AS numeric(10, 2)) AS nvarchar(5)) + '%' AS Margin, '$' + CONVERT(nvarchar(25), CAST(SUM(Profit) AS money)) AS Expr1
                          FROM            TransactionEntryItem
                          WHERE       (DepartmentID IN ('6FD76CDA-8767-4B38-A6CD-259A4D7959A3', '15737F37-12B4-4877-8E07-FBB1161C63E4')) AND 
						  (StartSaleTime >= @From) AND (StartSaleTime < @To)) 
                         AS Rep
ORDER BY Sort
GO