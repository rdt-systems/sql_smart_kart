SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

  CREATE function [dbo].[FN_GetTotalProfitYear] (@StoreId uniqueidentifier=null) returns table
  as return(
  select convert(varchar(10),DATEPART(yyyy, TransactionEntryProfit.StartSaleTime))  
+  
RIGHT(REPLICATE('0', 2) + convert(varchar(10),DATEPART(mm, TransactionEntryProfit.StartSaleTime)), 2) as Month ,  
convert(varchar(3), TransactionEntryProfit.StartSaleTime,100) as MonthName,  
sum(TransactionEntryProfit.TotalAfterDiscount) as Total,sum(TransactionEntryProfit.Profit)   as Profit  
from TransactionEntryProfit   
  
where TransactionEntryProfit.StartSaleTime >DATEADD(yyyy,-1,DATEADD( mm,1,CAST(CAST(DATEPART(yyyy,getdate()) AS varchar) + '-' + CAST(DATEPART(mm,getdate()) AS varchar) + '-' + CAST(01 AS varchar) AS DATETIME)))  
and ( TransactionEntryProfit.StoreID=@StoreId or @StoreId is null)  
group by convert(varchar(10),DATEPART(yyyy, TransactionEntryProfit.StartSaleTime))  
+  
RIGHT(REPLICATE('0', 2) + convert(varchar(10),DATEPART(mm, TransactionEntryProfit.StartSaleTime)), 2)   
,convert(varchar(3), TransactionEntryProfit.StartSaleTime,100)  
 
  )
GO