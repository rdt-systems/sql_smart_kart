SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE 
            PROCEDURE [dbo].[WEB_IsValidResCustomer]
(@CustomerID uniqueidentifier,
@ResellerID uniqueidentifier)
As 

if (select Count(1) from dbo.Customer
where CustomerID= @CustomerID and Status>-1 
and resellerid=@ResellerID)
> 0
	select 1
	
else
	select 0
GO