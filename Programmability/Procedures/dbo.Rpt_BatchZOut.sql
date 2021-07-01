SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_BatchZOut] 
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
declare @MyUnion nvarchar(4000)

set @MySelect= 'SELECT  BatchID, RegisterID, UserId, BatchNumber, StatusOfBatch, BatchStatus, OpeningDateTime, ClosingDateTime, UserName,StoreName, OpeningAmount, 
					PayBalance, SaleOnAccount,CountOnAccount, TotalSales+ReturnInSale-tax+Discounts as TotalSales, TotalReturn, PayOut, ClosingAmount, ManualItem, Tax, Discounts, MaxSale, MinSale, AvrgSale, 
					TotalTransactions, OpenDrawer, VoidItem, CancelSale
				INTO #T
				FROM dbo.RepBatchView
				where 1=1 '



set @MyUnion= 'SELECT     BatchID, RegisterID, UserId, BatchNumber, StatusOfBatch, BatchStatus, OpeningDateTime, ClosingDateTime, UserName,StoreName, OpeningAmount, 
						PayBalance, SaleOnAccount,CountOnAccount, TotalSales as TotalSales, TotalReturn, PayOut, ClosingAmount, ManualItem, Tax, Discounts, MaxSale, MinSale, AvrgSale, 
						TotalTransactions, OpenDrawer, VoidItem, CancelSale,0 as OrderBy 
				from #T

				union all

				select ''00000000-0000-0000-0000-000000000000'',''00000000-0000-0000-0000-000000000000'',null
						,''Totals'',''Totals'',1,
						min(OpeningDateTime),max(ClosingDateTime),''All Users'',''All Stores'',sum(OpeningAmount),
						sum(PayBalance),sum(SaleOnAccount),sum(CountOnAccount),sum(TotalSales),sum(TotalReturn),
						sum(PayOut), sum(ClosingAmount),sum(ManualItem),sum(Tax),sum(Discounts),
						max(MaxSale),min(MinSale),avg(AvrgSale),sum(TotalTransactions),sum(OpenDrawer),
						sum(VoidItem),sum(CancelSale),1 
				from #T
				
				Order By OrderBy,OpeningDateTime
				Drop Table #T'
	
print  (@MySelect + @Filter + @MyUnion)		
Execute (@MySelect + @Filter + @MyUnion)
GO