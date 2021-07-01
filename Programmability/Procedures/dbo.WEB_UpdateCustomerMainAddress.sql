SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[WEB_UpdateCustomerMainAddress] 
(@ShipTo uniqueidentifier,@CustomerID uniqueidentifier)
as
update customer
set mainaddressid=@ShipTo, datemodified=dbo.GetLocalDATE()
where customerid=@CustomerID
GO