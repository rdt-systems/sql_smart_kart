SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[WEB_UpdateWorkOrderShip] 
(@ShipTo uniqueidentifier,@WorkID uniqueidentifier)
as
update workorder
set shipto=@ShipTo,
datemodified=dbo.GetLocalDATE()
where WorkOrderID=@WorkID
GO