SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_TotalSalesDaily]
(
@Filter nvarchar(4000),
@IncludeDiscount bit =1
)
as
Declare @MyInsert1 nvarchar(4000)
DECLARE @MyInsFil1 nvarchar(4000)
Declare @MyInsert2 nvarchar(1000)
Declare @MyDrop nvarchar(150)
declare @MySelect nvarchar(2000)
declare @Group nvarchar(400)
begin


SET @Filter = REPLACE(@Filter,'StartSaleTime','EndSaleTime')

SET @MyInsFil1 = REPLACE(@Filter,'StoreID','Store.StoreID')


SET @MyInsert1 = N'
 SELECT        M.ItemID, TransactionEntry.TransactionEntryID, [Transaction].StartSaleTime,[Transaction].TransactionID, [Transaction].EndSaleTime, TransactionEntry.Total, Store.StoreID, [Transaction].TransactionNo, 
 ISNULL(TransactionEntry.TotalAfterDiscount, TransactionEntry.Total) 
                         - ISNULL(TransactionEntry.AVGCost, 0) * ISNULL
                             ((SELECT        CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END) END AS Expr1), 0) AS Profit, 
                         ISNULL(TransactionEntry.TotalAfterDiscount, TransactionEntry.Total) AS TotalAfterDiscount,
						 ISNULL(TransactionEntry.Cost, 0) * ISNULL
                             ((SELECT        CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END) END AS Expr1), 0) AS ExtCost
														  INTO #Temp01
FROM            ItemMain AS M INNER JOIN
                         ItemStore AS S ON M.ItemID = S.ItemNo INNER JOIN
                         SysItemTypeView ON M.ItemType = SysItemTypeView.SystemValueNo RIGHT OUTER JOIN
                         TransactionEntry WITH (NOLOCK) INNER JOIN
                         [Transaction] WITH (NOLOCK) ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID ON S.ItemStoreID = TransactionEntry.ItemStoreID
WHERE        (TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5) AND ([Transaction].Status > 0)  
'

SET @MyInsert2 = 'Select Tax, StartSaleTime,EndSaleTime, StoreID INTO #Temp02 from [Transaction] WITH (NOLOCK)  Where Status > 0 '

SET @MyDrop = ' 
DROP TABLE #Temp01
DROP TABLE #Temp02
'

if @IncludeDiscount = 1
	set @MySelect='SELECT  SaleDate As ''Date'', SUM(Total) AS Total, COUNT(TransactionNo)as Trans,SUM(Total) / COUNT(TransactionNo) AS AvgSale, Tax, AVG(Margin) AS Margin
				  FROM   (SELECT     SUM(TotalAfterDiscount) AS Total, T.Tax, (CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0	 ELSE ((SUM(Profit))/(SUM(TotalAfterDiscount)/100))/100 END) as Margin, 
				  CONVERT(CHAR(10), EndSaleTime, 101) AS SaleDate, TransactionNo
						   FROM         #Temp01 E  INNER JOIN (SELECT        SUM(Tax) AS Tax, CONVERT(CHAR(10), EndSaleTime, 101) AS SaleDate
						    FROM            #Temp02  
                               WHERE        (1 = 1) 
                               GROUP BY CONVERT(CHAR(10), EndSaleTime, 101)) T  ON CONVERT(CHAR(10), E.EndSaleTime, 101) = T.SaleDate
						  WHERE   (0 = 0) '
ELSE
	set @MySelect='SELECT     SaleDate As ''Date'', SUM(Total) AS Total, COUNT(TransactionNo)as Trans,SUM(Total) / COUNT(TransactionNo) AS AvgSale, Tax, AVG(Margin) AS Margin
				  FROM   (SELECT     SUM(TotalAfterDiscount) AS Total, T.Tax, (CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0	 ELSE ((SUM(Profit))/(SUM(TotalAfterDiscount)/100))/100 END) as Margin, 
				  CONVERT(CHAR(10), EndSaleTime, 101) AS SaleDate, TransactionNo
						   FROM         #Temp01 E  INNER JOIN (SELECT        SUM(Tax) AS Tax, CONVERT(CHAR(10), EndSaleTime, 101) AS SaleDate
                               FROM           #Temp02
                               WHERE        (1 = 1) 
                               GROUP BY CONVERT(CHAR(10), EndSaleTime, 101)) T  ON CONVERT(CHAR(10), E.EndSaleTime, 101) = T.SaleDate
						  WHERE   (0 = 0) '
                      
 set @Group=' GROUP BY CONVERT(CHAR(10), EndSaleTime, 101),Tax, TransactionNo) AS TotalTranss
             GROUP BY SaleDate,Tax '                

--set @MySelect='SELECT     SUM(Total) AS Total, COUNT(TransactionID) AS Trans, SUM(Total) / COUNT(TransactionID) AS AvgSale, 
--               CONVERT(CHAR(10), StartSaleTime, 101) 
--               AS ''Date'' FROM [TransactionEntryItem] WHERE 0=0 '

--set @Group='GROUP BY CONVERT(CHAR(10), StartSaleTime, 101)
--            ORDER BY CONVERT(CHAR(10), StartSaleTime, 101)'
print (@MyInsert1+@MyInsFil1+@MyInsert2+@Filter+@MySelect+@Group+@MyDrop)

exec(@MyInsert1+@MyInsFil1+@MyInsert2+@Filter+@MySelect+@Group+@MyDrop)

end
GO