SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_UpdateAllCustomers] as

update 	Customer 
set 	DateModified=DateModified

update 	CustomerAddresses 
set 	DateModified=DateModified
GO