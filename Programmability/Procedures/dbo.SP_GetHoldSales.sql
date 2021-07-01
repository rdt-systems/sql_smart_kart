SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetHoldSales]
@StoreID as uniqueidentifier

AS SELECT     dbo.[Transaction].TransactionID, dbo.[Transaction].TransactionNo, dbo.[Transaction].Debit, dbo.[Transaction].StartSaleTime ,dbo.[Transaction].Note
FROM         dbo.[Transaction] 
WHERE     (TransactionType = 9 )and StoreID=@StoreID
GO