SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <5/31/2015>
-- Description:	<RPT_SalesByDep_Email>
-- =============================================

CREATE PROCEDURE [dbo].[RPT_SalesByDep_Email]
@Date DateTime = NULL,
@StoreID Uniqueidentifier = NULL

AS
BEGIN

IF @Date IS NULL
SET @Date = dbo.GetDay(dbo.GetLocalDATE())

IF @StoreID IS NULL
Begin
SELECT        DEPT AS [Category Name], QTYSHIP, ExtPrice AS [Ext Price], Cost AS [Total Cost], [P/L$] AS [Profit Margin $], [P/L%] AS [Profit Margin %]
FROM            (SELECT        1 AS No, ISNULL(MainDepartment, '[No Department]') AS DEPT, CAST(SUM(QTY) AS int) AS QTYSHIP, FORMAT(SUM(TotalAfterDiscount), 'C', 'en-US') AS ExtPrice, FORMAT(SUM(ExtCost), 'C', 'en-US') 
                                                    AS Cost, FORMAT(SUM(TotalAfterDiscount) - SUM(ExtCost), 'C', 'en-US') AS [P/L$], FORMAT((CASE WHEN SUM(TotalAfterDiscount) <> 0 AND SUM(ExtCost) <> 0 THEN (SUM(TotalAfterDiscount) 
                                                    - SUM(ExtCost)) / SUM(TotalAfterDiscount) ELSE 100 END), 'p') AS [P/L%]
                          FROM            TransactionEntryItem
                          WHERE        EXISTS
                                                        (SELECT        1 AS Expr1
                                                          FROM            (SELECT        ItemStoreID
                                                                                    FROM            ItemsRepFilter
                                                                                    WHERE        (1 = 1)) AS E
                                                          WHERE        (ItemStoreID = TransactionEntryItem.ItemStoreID)) AND (dbo.GetDay(StartSaleTime) = @Date)
                          GROUP BY MainDepartment
                          UNION
                          SELECT        2 AS No, 'Total' AS DEPT, CAST(SUM(QTY) AS int) AS QTYSHIP, FORMAT(SUM(TotalAfterDiscount), 'C', 'en-US') AS ExtPrice, FORMAT(SUM(ExtCost), 'C', 'en-US') AS Cost, 
                                                   FORMAT(SUM(TotalAfterDiscount) - SUM(ExtCost), 'C', 'en-US') AS [P/L$], FORMAT((CASE WHEN SUM(TotalAfterDiscount) <> 0 AND SUM(ExtCost) <> 0 THEN (SUM(TotalAfterDiscount) - SUM(ExtCost)) 
                                                   / SUM(TotalAfterDiscount) ELSE 100 END), 'p') AS [P/L%]
                          FROM            TransactionEntryItem AS TransactionEntryItem_1
                          WHERE        EXISTS
                                                       (SELECT        1 AS Expr1
                                                         FROM            (SELECT        ItemStoreID
                                                                                   FROM            ItemsRepFilter
                                                                                   WHERE        (1 = 1)) AS E
                                                         WHERE        (ItemStoreID = TransactionEntryItem_1.ItemStoreID)) AND (dbo.GetDay(StartSaleTime) = @Date)) AS TR
ORDER BY No
End

if @StoreID is not null
begin
SELECT        DEPT AS [Category Name], QTYSHIP, ExtPrice AS [Ext Price], Cost AS [Total Cost], [P/L$] AS [Profit Margin $], [P/L%] AS [Profit Margin %]
FROM            (SELECT        1 AS No, ISNULL(MainDepartment, '[No Department]') AS DEPT, CAST(SUM(QTY) AS int) AS QTYSHIP, FORMAT(SUM(TotalAfterDiscount), 'C', 'en-US') AS ExtPrice, FORMAT(SUM(ExtCost), 'C', 'en-US') 
                                                    AS Cost, FORMAT(SUM(TotalAfterDiscount) - SUM(ExtCost), 'C', 'en-US') AS [P/L$], FORMAT((CASE WHEN SUM(TotalAfterDiscount) <> 0 AND SUM(ExtCost) <> 0 THEN (SUM(TotalAfterDiscount) 
                                                    - SUM(ExtCost)) / SUM(TotalAfterDiscount) ELSE 100 END), 'p') AS [P/L%]
                          FROM            TransactionEntryItem
                          WHERE        EXISTS
                                                        (SELECT        1 AS Expr1
                                                          FROM            (SELECT        ItemStoreID
                                                                                    FROM            ItemsRepFilter
                                                                                    WHERE        (1 = 1)) AS E
                                                          WHERE        (ItemStoreID = TransactionEntryItem.ItemStoreID)) AND (dbo.GetDay(StartSaleTime) = @Date) AND (StoreID = @StoreID)
                          GROUP BY MainDepartment
                          UNION
                          SELECT        2 AS No, 'Total' AS DEPT, CAST(SUM(QTY) AS int) AS QTYSHIP, FORMAT(SUM(TotalAfterDiscount), 'C', 'en-US') AS ExtPrice, FORMAT(SUM(ExtCost), 'C', 'en-US') AS Cost, 
                                                   FORMAT(SUM(TotalAfterDiscount) - SUM(ExtCost), 'C', 'en-US') AS [P/L$], FORMAT((CASE WHEN SUM(TotalAfterDiscount) <> 0 AND SUM(ExtCost) <> 0 THEN (SUM(TotalAfterDiscount) - SUM(ExtCost)) 
                                                   / SUM(TotalAfterDiscount) ELSE 100 END), 'p') AS [P/L%]
                          FROM            TransactionEntryItem AS TransactionEntryItem_1
                          WHERE        EXISTS
                                                       (SELECT        1 AS Expr1
                                                         FROM            (SELECT        ItemStoreID
                                                                                   FROM            ItemsRepFilter
                                                                                   WHERE        (1 = 1)) AS E
                                                         WHERE        (ItemStoreID = TransactionEntryItem_1.ItemStoreID)) AND (dbo.GetDay(StartSaleTime) = @Date) AND (StoreID = @StoreID)) AS TR
ORDER BY No
end

END
GO