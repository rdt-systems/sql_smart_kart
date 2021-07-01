SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetRecentNewCustomer] 
(@Filter nvarchar(4000),
@Storeid uniqueidentifier=null)
as


declare @MySelect1 nvarchar(4000)
set @MySelect1='SELECT    Customer.Name as CustomerName, Customer.CustomerNo,Customer.Address,Customer.balanceDoe,CustomerID
                        
FROM           [CustomerView] as Customer 
where 1=1
'  



declare @MySelect3 nvarchar(4000)
set @MySelect3='  

order by DateCreated desc  '



exec ( @MySelect1+ @Filter + @MySelect3  )
GO