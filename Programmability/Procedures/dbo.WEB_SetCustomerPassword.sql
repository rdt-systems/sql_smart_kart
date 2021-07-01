SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_SetCustomerPassword]
(@CustomerID uniqueidentifier,@Password nvarchar(50))
AS
	
update customer
set	password=@Password
where customerid=@CustomerID
GO