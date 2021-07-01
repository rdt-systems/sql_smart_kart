SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionEntryFromTransaction]
(@ID uniqueidentifier)
As 
SELECT     dbo.TransactionEntry.*
FROM         dbo.TransactionEntry
where transactionID=@ID and status>0
GO