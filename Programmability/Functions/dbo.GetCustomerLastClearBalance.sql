SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[GetCustomerLastClearBalance] (@Customer uniqueidentifier)  
RETURNS datetime AS  
BEGIN 

	declare @d datetime
	
		SELECT     @d =  MAX(tr.StartSaleTime)  
		FROM         dbo.[Transaction] tr 
		WHERE     tr.TransactionType = 1 AND  Status>0  AND  customerID=@Customer 
		        and CurrBalance <= 0
	
	return @d

END
GO