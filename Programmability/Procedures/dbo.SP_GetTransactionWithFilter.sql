SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionWithFilter]
(@FilterFromDate nvarchar(4000),
@Filter nvarchar(4000))
As 
declare @MySelect1 nvarchar(4000)
declare @MySelect2 nvarchar(4000)
set @MySelect1='  SELECT     dbo.TransactionWithPaidView.*, dbo.CustomerView.CustomerNo
		  FROM         dbo.TransactionWithPaidView
    		  	INNER JOIN (select Count(*) as cnt,CustomerID 
			      	    from dbo.[Transaction] 
			            where  '
set @myselect2='                    group by CustomerID having Count(*) >0)
 		                    AS OnlyChanged
   		                    ON onlychanged.CustomerID=dbo.TransactionWithPaidView.CustomerID 

   		        LEFT OUTER JOIN
                        dbo.CustomerView ON dbo.TransactionWithPaidView.CustomerID = dbo.CustomerView.CustomerID
		  WHERE     (dbo.TransactionWithPaidView.Status > 0)and  (dbo.TransactionWithPaidView.TransactionType<>2 and dbo.TransactionWithPaidView.TransactionType<>4) and '

execute (@mySelect1+ @FilterFromDate + @MySelect2 + @Filter)
GO