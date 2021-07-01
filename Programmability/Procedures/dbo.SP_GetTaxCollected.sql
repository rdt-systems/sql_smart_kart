SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTaxCollected]
(@Filter nvarchar(4000),
@CustomerFilter nvarchar(4000)
)
AS 

Declare @BaseFilter nvarchar(4000)
set @BaseFilter='dbo.[Transaction].Status>0 AND 
				 dbo.[Transaction].Tax<>0 AND 
				 dbo.[Transaction].Tax is not null '

declare @MyWhere nvarchar(4000)
if @CustomerFilter<>''
	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							   Into #CustomerSelect 
							   From CustomerRepFilter 
							   Where (1=1) '
		SET @MyWhere=  'AND exists (Select 1 From #CustomerSelect where CustomerID=dbo.[Transaction].CustomerID ) '
	end 
 else
     SET @MyWhere= ''

--*********************************************

DECLARE @MySelect nvarchar(4000)

set @MySelect='
    SELECT 	dbo.[Transaction].TransactionID,
		    dbo.[Transaction].TransactionNo, 
			--dbo.[Transaction].Debit as TotalSale,
			Sales.TotalSale,
			dbo.[Transaction].StartSaleTime as Date,
		    dbo.[Transaction].Tax as TaxSum,
		    dbo.[Transaction].TaxRate/100 as TaxRate,
		    dbo.Tax.TaxName,
			dbo.Customerview.CustomerNo,
			CASE WHEN ISNULL(dbo.Customerview.LastName,'''') <>  '''' OR ISNULL(dbo.Customerview.FirstName,'''') <> '''' THEN
			ISNULL(dbo.Customerview.LastName,'''') + '', '' + ISNULL(dbo.Customerview.FirstName,'''') ELSE '''' END as CustomerName,
            dbo.[Transaction].StoreID, STUFF
                          ((SELECT DISTINCT '','' + Tender.TenderName
FROM            TenderEntry INNER JOIN
                         Tender ON TenderEntry.TenderID = Tender.TenderID
						 And TenderEntry.TransactionID = dbo.[Transaction].TransactionID
						 And TenderEntry.Status >0 FOR XML PATH(''''), TYPE ).value(''.'', ''varchar(max)''), 1, 1, '''') AS Payment
FROM    dbo.[Transaction] 
 INNER JOIN (Select TransactionID, SUM(TotalAfterDiscount) AS TotalSale  from TransactionEntryItem Where ISNULL(Taxable,0)   =1
Group By TransactionID) AS Sales On [Transaction].TransactionID = Sales.TransactionID
			INNER JOIN
                   dbo.Tax ON dbo.Tax.TaxID = dbo.[Transaction].TaxID             LEFT OUTER JOIN
                   dbo.CustomerView ON dbo.[Transaction].CustomerID = dbo.Customerview.CustomerID  AND dbo.Customerview.Status > 0


    WHERE    '

Print ( @MySelect  + @BaseFilter + @MyWhere + @Filter )

exec ( @CustomerSelect + @CustomerFilter + @MySelect  + @BaseFilter + @MyWhere + @Filter   )


if @CustomerFilter<>''
drop table #CustomerSelect
GO