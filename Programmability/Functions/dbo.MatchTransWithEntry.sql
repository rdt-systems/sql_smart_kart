SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:      Nathan Ehrenthal>
-- Create Date: 1/24/2021>
-- Description: To make sure the transaction match with Entry>
-- =============================================
CREATE FUNCTION [dbo].[MatchTransWithEntry]
(
    @TransactionID as uniqueidentifier
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar int
	SET @ResultVar= (Select Count(*)
From
    [Transaction] Inner Join
    (Select
         Sum(CASE WHEN TransactionEntryType=4 then (-TransactionEntry.Total) ELSE TransactionEntry.Total END ) As Sum_Total,
         TransactionEntry.TransactionID
     From
         TransactionEntry
     Where
         TransactionEntry.Status > 0
     Group By
         TransactionEntry.TransactionID) E On [Transaction].TransactionID = E.TransactionID
WHERE  (((([Transaction].Debit-[Transaction].tax)- E.Sum_Total)>.01) or ((([Transaction].Debit-[Transaction].tax)- E.Sum_Total)<-.01))
AND [Transaction].TransactionID=@TransactionID)
    -- Return the result of the function
    RETURN @ResultVar
END
GO