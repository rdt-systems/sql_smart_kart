SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[GetPOStatus](@POID uniqueidentifier, @PONO as nvarchar(50)= null)
as
if IsNull(@PONO,'') <> ''
BEGIN
	select PONo,POStatus
	from PurchaseOrders
	where PoNo=@PONO
END
else
BEGIN
	select PONo,POStatus
	from PurchaseOrders
	where PurchaseOrderID=@POID
END
GO