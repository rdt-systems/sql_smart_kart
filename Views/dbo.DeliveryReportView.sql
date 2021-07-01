SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DeliveryReportView]
AS
SELECT DISTINCT 
                         TOP (100) PERCENT dbo.DeliveryDetails.BatchID, dbo.Users.UserName, dbo.DeliveryDetails.ShippedDate, dbo.Users.UserId, 
                         (CASE WHEN dbo.DeliveryDetails.Status = 1 THEN 'New' WHEN dbo.DeliveryDetails.Status = 2 THEN 'To Deliver' WHEN dbo.DeliveryDetails.Status = 6 THEN 'Delivered' WHEN dbo.DeliveryDetails.Status = 4 THEN
                          'Returned' WHEN dbo.deliverydetails.status = 7 THEN 'On Hold' WHEN dbo.deliverydetails.status = 8 THEN 'Packed' WHEN dbo.deliverydetails.status = 9 THEN 'Picked' END) AS Status
FROM            dbo.DeliveryDetails LEFT OUTER JOIN
                         dbo.Users ON dbo.DeliveryDetails.Driver = dbo.Users.UserId
WHERE        ((CASE WHEN dbo.DeliveryDetails.Status = 1 THEN 'New' WHEN dbo.DeliveryDetails.Status = 2 THEN 'To Deliver' WHEN dbo.DeliveryDetails.Status = 6 THEN 'Delivered' WHEN dbo.DeliveryDetails.Status = 4 THEN
                          'Returned' WHEN dbo.deliverydetails.status = 7 THEN 'On Hold' WHEN dbo.deliverydetails.status = 8 THEN 'Packed' WHEN dbo.deliverydetails.status = 9 THEN 'Picked' END) IS NOT NULL)
GO