SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRecieptText](
	@TransactionID uniqueidentifier = NULL,
	@TransLogID int = NULL)

AS

IF @TransactionID IS NOT NULL
SELECT        RecieptTxt
FROM            [Transaction]
WHERE        (TransactionID = @TransactionID)

IF @TransLogID IS NOT NULL
SELECT        OldRecipt
FROM            TransactionLogs
WHERE        (TransLogID = @TransLogID)
GO