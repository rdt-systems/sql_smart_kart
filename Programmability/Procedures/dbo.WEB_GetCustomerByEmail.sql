SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetCustomerByEmail] 
(@Email nvarchar(50))
AS
	
SELECT    customer.customerid
FROM    Customer
 inner join customertoemail on customer.customerid=customertoemail.customerid and customertoemail.status>0 
 inner join email on customertoemail.emailid=email.emailid and email.emailaddress=@Email and email.status>0
WHERE     (customer.Status > 0)
GO