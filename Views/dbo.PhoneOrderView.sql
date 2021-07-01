SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO









CREATE VIEW [dbo].[PhoneOrderView]
AS
SELECT    DISTINCT    Customer.CustomerNo, Customer.FirstName, Customer.LastName, Customer.Over30, Customer.Over60, Customer.Over90, Customer.Over120, Customer.Credit, Customer.Over0, Customer.[Current], 
                         Customer.LockAccount, Customer.BalanceDoe, Customer.LastPaymentDate, Customer.LastPayment, PhoneOrder.PhoneOrderID, PhoneOrder.PhoneOrderNo, PhoneOrder.StoreID, PhoneOrder.CustomerID, 
                         PhoneOrder.DriversNote, PhoneOrder.CustomerNote, PhoneOrder.PickNote, PhoneOrder.PhoneOrderDate, DATEADD(day, DATEDIFF(day, PhoneOrder.PhoneOrderTime, 1), PhoneOrder.PhoneOrderTime) 
                         AS PhoneOrderTime, PhoneOrder.DeliveryDate, PhoneOrder.ShiftID, PhoneOrder.ShippingID, PhoneOrder.PhoneOrderStatus, PhoneOrder.PickByID, PhoneOrder.TakeByID, PhoneOrder.TransactionID, 
                         PhoneOrder.Type, PhoneOrder.Total, PhoneOrder.Status, PhoneOrder.DateCreated, PhoneOrder.UserCreated, PhoneOrder.DateModified, PhoneOrder.UserModified, PhoneOrder.Freezer, 
                         ISNULL(PhoneOrder.TenderID, 0) AS TenderID, PhoneOrder.StartEditing, PhoneOrder.PaymentNote, PhoneOrder.UserEditing, PhoneOrderType.SystemValueName AS PhoneOrderType, 
                         [Transaction].TransactionNo, Customer.LockOutDays, [Transaction].Credit AS Paid, Users.UserName AS TakenByUserName, STUFF
                             ((SELECT DISTINCT ',' + ig.Zone
                              FROM         SectionsView AS ig
                              WHERE     ig.CustomerID = PhoneOrder.CustomerID  FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Zone
FROM            Customer INNER JOIN
                         PhoneOrder ON Customer.CustomerID = PhoneOrder.CustomerID LEFT OUTER JOIN
                         Users ON PhoneOrder.TakeByID = Users.UserId LEFT OUTER JOIN
                         [Transaction] ON PhoneOrder.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
GO