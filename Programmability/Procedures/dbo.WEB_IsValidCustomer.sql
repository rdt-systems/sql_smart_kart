SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create 
            PROCEDURE [dbo].[WEB_IsValidCustomer]
(@CustomerID nvarchar(50))
As 

if (select Count(1) from dbo.Customer
where CustomerID= @CustomerID and Status>-1 )
> 0
	select 1
	
else
	select 0
GO