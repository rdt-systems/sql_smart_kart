SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PrintSaleOrderView]
AS
SELECT     dbo.CustomerAddresses.Street1, dbo.CustomerAddresses.City + dbo.CustomerAddresses.State+ dbo.CustomerAddresses.Zip AS CityStateZip, dbo.WorkOrder.WorkOrderID, 
                      dbo.WorkOrder.ActiveDate, dbo.WorkOrder.ExpirationDate, dbo.WorkOrder.WONo, dbo.WorkOrder.Debit, dbo.WorkOrder.Tax, dbo.WorkOrder.TaxType, 
                      dbo.WorkOrder.TaxID, dbo.WorkOrder.ShipTo, dbo.WorkOrder.ShipVia, dbo.WorkOrder.Note, dbo.WorkOrder.WOStatus, 
                      dbo.Customer.FirstName + dbo.Customer.LastName AS aname, 
                      dbo.WorkOrder.DateCreated
FROM         dbo.CustomerAddresses INNER JOIN
                      dbo.Customer ON dbo.CustomerAddresses.CustomerID = dbo.Customer.CustomerID RIGHT OUTER JOIN
                      dbo.WorkOrder ON dbo.Customer.CustomerID = dbo.WorkOrder.CustomerID
GO