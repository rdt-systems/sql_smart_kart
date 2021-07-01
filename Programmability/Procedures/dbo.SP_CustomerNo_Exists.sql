SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerNo_Exists]
(@Number nvarchar(50),
@CustomerID uniqueidentifier=null)
As 

if (select Count(1) from dbo.Customer
where CustomerNo = @Number  and Status>-1 and (CustomerID<>@CustomerID or @CustomerID is null)) 
> 0
	select 1
	
else
	select 0
GO