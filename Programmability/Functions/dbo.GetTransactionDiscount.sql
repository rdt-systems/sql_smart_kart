SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    FUNCTION [dbo].[GetTransactionDiscount]
(@ID uniqueidentifier
)  
RETURNS decimal(19,2) 
AS  
BEGIN 

	DECLARE @d decimal(19,2)
	
	SELECT @d=sum(isnull(UOMPrice,0)*isnull(qty,1))
	FROM TransactionEntry
	WHERE TransactionEntryType=4 and TransactionID=@ID and Status>0

return @d

END
GO