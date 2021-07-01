SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetLastItemSaleByCustomer] 
(@CustomerID uniqueidentifier,
 @LastTrans Integer =5)
 AS
 SELECT DISTINCT TOP (@LastTrans) BarcodeNumber, StartSaleTime,Price,Name,ModalNumber
FROM            TransactionEntryItem
WHERE        (CustomerID = @CustomerID) and (BarcodeNumber is not null)
ORDER BY StartSaleTime DESC
GO