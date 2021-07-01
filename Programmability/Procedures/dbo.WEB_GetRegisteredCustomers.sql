SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetRegisteredCustomers]

(@ResellerID uniqueidentifier=null)
as
if @ResellerID is null
	select customer.customerid, customer.lastname,customer.customerno, customer.firstname,
	customer.[password],
	(
	SELECT emailaddress from email 
	where (select top 1 emailid from customertoemail where customerid=customer.customerid order by datemodified desc)=emailid

	) Mail
	from customer
	where status>0
	order by mail desc
else
	select customer.customerid, customer.lastname,customer.customerno, customer.firstname,
	customer.[password],
	(
	SELECT emailaddress from email 
	where (select top 1 emailid from customertoemail where customerid=customer.customerid order by datemodified desc)=emailid

	) Mail
	from customer
	where status>0
	and resellerid=@ResellerID
	order by mail desc
GO