SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[GetCustomerDateStartBalance] (@CustomerID uniqueidentifier) RETURNS datetime
AS
BEGIN	

	RETURN IsNull(
		(select Max(EndSaleTime) From [Transaction] 
			Where Status>0 and customerID=@CustomerID and transactionType=2)
			,'1753/1/1')

END
GO