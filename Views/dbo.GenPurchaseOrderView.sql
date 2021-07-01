SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GenPurchaseOrderView]
AS
SELECT        dbo.GenPurchaseOrder.*
FROM            dbo.GenPurchaseOrder
WHERE        (Status > 0)
GO