SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetCustomerMainAddress] 
(@CustomerID uniqueidentifier)
AS
	
SELECT    city,state,zip,street1,country,[name],PhoneNumber1
FROM         Customeraddresses
where customerid=@CustomerID
and status>0
and addresstype=6
GO