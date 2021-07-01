SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemInInvoicePrice]
(@TransactionID uniqueidentifier,
@ItemStoreID uniqueidentifier)
AS

select max(UOMPrice) from TransactionEntry
where TransactionID=@TransactionID and ItemStoreID=@ItemStoreID
GO