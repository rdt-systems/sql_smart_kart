SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_GetCasesForDelivery]
(@TransactionID Uniqueidentifier)
AS

SELECT        CONVERT(nvarchar, CAST(QtyCase AS Int)) + ' Case/s ' + Name AS Cases
FROM            TransactionEntryItem
WHERE        (QtyCase >= 1) AND (QtyCase - CAST(QtyCase AS int) = 0) AND (UOMType = 2) AND (TransactionID = @TransactionID)
GO