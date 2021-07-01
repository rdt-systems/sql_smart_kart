SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_ItemDailySales]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'Select  sum(Qty) as Qty,
						sum(Total) as ExtPrice,
						StartSaleTime as DayOfYear,
						isnull(Department,''[NO DEPARTMENT]'')as Department
				From TransactionEntryItem 
				where '

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy='group By StartSaleTime,Department
				Order By StartSaleTime'

Execute (@MySelect + @Filter + @MyGroupBy)
GO