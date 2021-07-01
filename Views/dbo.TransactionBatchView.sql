SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionBatchView]
AS
SELECT     dbo.TransactionBatch.*
FROM         dbo.TransactionBatch
GO