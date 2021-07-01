SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SoldItemsByDepartment]
(@StoreID uniqueidentifier,
@FromDate datetime ,
@Todate DateTime)

AS
SELECT     Department as Name,  
		   Round(SUM(Total),2)AS Price

FROM      dbo.TransactionEntryItem

where 
		   StoreID=@StoreID And 
           StartSaleTime>=@FromDate and 
		   StartSaleTime<@ToDate

GROUP BY   Department

ORDER BY   Department
GO