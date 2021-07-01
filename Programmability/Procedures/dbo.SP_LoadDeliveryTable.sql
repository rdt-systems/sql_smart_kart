SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


---Sp Created to show 

CREATE PROCEDURE [dbo].[SP_LoadDeliveryTable]  
AS
 BEGIN
    SELECT	DISTINCT Delivery.Road, Delivery.Status, Delivery.assigned	FROM    Delivery 
 END
GO