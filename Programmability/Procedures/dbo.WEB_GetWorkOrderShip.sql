SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[WEB_GetWorkOrderShip] 
(@WorkID uniqueidentifier)
AS
	
SELECT    city,state,zip,street1,country,[name],PhoneNumber1
FROM         Customeraddresses
where status>0
and addresstype=4
and customeraddressid=(select ShipTo from workorder
where status>0 and WorkOrderID=@WorkID)
GO