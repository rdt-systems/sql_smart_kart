SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[WorkOrderView]
AS
SELECT     CONVERT(varchar, dbo.WorkOrder.EndSaleTime, 108) AS EndTime, CONVERT(varchar, dbo.WorkOrder.StartSaleTime, 108) AS StartTime, 
                      dbo.CustomerView.Name AS CustomerName, dbo.WorkOrder.WorkOrderID, dbo.WorkOrder.ActiveDate, dbo.WorkOrder.ExpirationDate, 
                      dbo.WorkOrder.WONo, dbo.WorkOrder.StoreID, dbo.WorkOrder.CustomerID, dbo.WorkOrder.Debit, dbo.WorkOrder.StartSaleTime, 
                      dbo.WorkOrder.EndSaleTime, dbo.WorkOrder.Tax, dbo.WorkOrder.TaxType, dbo.WorkOrder.TaxRate, dbo.WorkOrder.TaxID, dbo.WorkOrder.ShipTo, 
                      dbo.WorkOrder.ShipVia, dbo.WorkOrder.Pay_PaymentType, dbo.WorkOrder.Pay_CardNumber, dbo.WorkOrder.Freight, 
                      dbo.WorkOrder.Pay_NameOnCard, dbo.WorkOrder.Pay_ExpirationDate, dbo.WorkOrder.Pay_SecurityCode, dbo.WorkOrder.IsWeb, 
                      dbo.WorkOrder.WOStatus, dbo.WorkOrder.Note, dbo.WorkOrder.ResellerID, dbo.WorkOrder.Status, dbo.WorkOrder.DateCreated, 
                      dbo.WorkOrder.UserCreated, dbo.WorkOrder.DateModified, dbo.WorkOrder.UserModified, dbo.CustomerView.CustomerNo, 
                      dbo.ResellersView.CompanyName AS ResellerName, dbo.WorkOrder.Pay_TenderType
FROM         dbo.WorkOrder LEFT OUTER JOIN
                      dbo.ResellersView ON dbo.WorkOrder.ResellerID = dbo.ResellersView.ResellerID LEFT OUTER JOIN
                      dbo.CustomerView ON dbo.WorkOrder.CustomerID = dbo.CustomerView.CustomerID
GO