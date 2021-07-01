SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerMonthlySales]
(

@Filter nvarchar(4000)
)

AS

declare @MySelect nvarchar(2000)
declare @Group nvarchar(400)

set @myselect = 'SELECT DATEPART(month, [Transaction].StartSaleTime) AS Month,DATEPART(year, [Transaction].StartSaleTime) AS Year,SUM([Transaction].Debit) AS Sale, CU.CustomerID,CU.CustomerNo,Name
                 FROM CustomerView As CU INNER JOIN [Transaction] ON CU.CustomerID = [Transaction].CustomerID'

--set @Filter = ' Where dbo.[Transaction].Status>0 and (dbo.[Transaction].StartSaleTime '

set @Group =  ' Group BY DATEPART(year, [Transaction].StartSaleTime),DATEPART(month, [Transaction].StartSaleTime), CU.CustomerNo,CU.CustomerID,CU.Name' 

--print(@MySelect + @Filter + @Group)
exec(@MySelect + @Filter + @Group)
GO