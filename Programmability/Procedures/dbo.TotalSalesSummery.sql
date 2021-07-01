SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[TotalSalesSummery]
(
@Filter nvarchar(4000)
)
as
declare @MySelect nvarchar(2000)
declare @Group nvarchar(400)
begin


	set @MySelect='SELECT     isnull(SUM(TotalAfterDiscount),0) AS Total, COUNT(distinct TransactionNo) as Trans, count (distinct dbo.FormatDateTime(StartSaleTime, ''MM/DD/YYYY'')) as CountDays
						  FROM          TransactionEntryProfit  WHERE      (0 = 0)  '

 set @Group=''                

--set @MySelect=''SELECT     SUM(Total) AS Total, COUNT(TransactionID) AS Trans, SUM(Total) / COUNT(TransactionID) AS AvgSale, 
--               dbo.FormatDateTime(StartSaleTime, ''MM/DD/YYYY'') 
--               AS ''Date'' FROM [TransactionEntryItem] WHERE 0=0 ''

--set @Group=''GROUP BY dbo.FormatDateTime(StartSaleTime, ''MM/DD/YYYY'')
--            ORDER BY dbo.FormatDateTime(StartSaleTime, ''MM/DD/YYYY'')''
print (@MySelect +@Filter+@Group)

exec(@MySelect +@Filter+@Group)

end
GO