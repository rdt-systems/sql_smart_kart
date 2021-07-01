SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransactionsWithProfit]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000) 
declare @MyGroup nvarchar(4000)
set @MySelect= '
select top 10 TransactionID,TransactionNo, CustomerName,EndSaleTime as Date , dbo.FormatDateTime(EndSaleTime,''HH:MM:SS 12'') AS Time,  Debit, 
sum(Profit) as Profit
from TransactionEntryProfit 
Where 1 = 1 
 '

 set @MyGroup= '  
group by TransactionID,TransactionNo, CustomerName,EndSaleTime, dbo.FormatDateTime(EndSaleTime,''HH:MM:SS 12'') ,  Debit
order by EndSaleTime desc
 '

 print (@MySelect)
 print (  @Filter  )
 print (@MyGroup )
		
print (@MySelect + @Filter+@MyGroup )
Execute (@MySelect + @Filter+@MyGroup )
GO