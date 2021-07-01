SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[RecieptDelivery]
AS
SELECT     RecieptTxt, TransactionNo
FROM         dbo.[Transaction]
GO