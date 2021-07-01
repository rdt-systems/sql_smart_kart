SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneOrder]
(@ID uniqueidentifier)
as
	SELECT     dbo.PurchaseOrdersView.*
	FROM       dbo.PurchaseOrdersView
	WHERE     (Status > - 1) and (PurchaseOrderId=@ID)
GO