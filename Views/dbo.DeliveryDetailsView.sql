SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







CREATE VIEW [dbo].[DeliveryDetailsView]
WITH SCHEMABINDING
AS
SELECT        (CASE WHEN dbo.DeliveryDetails.Status = 1 THEN 'New' WHEN dbo.DeliveryDetails.Status = 2 THEN 'To Deliver' WHEN dbo.DeliveryDetails.Status = 6 THEN 'Delivered' WHEN dbo.DeliveryDetails.Status = 4 THEN 'Returned' WHEN
                          dbo.deliverydetails.status = 7 THEN 'On Hold' WHEN dbo.deliverydetails.status = 8 THEN 'Packed' WHEN dbo.deliverydetails.status = 9 THEN 'Picked' END) AS Status, DeliveryDetails.Status AS IStatus, RegShift.ShiftNO, 
                         Packed.UserName AS PackedBy, DeliveryDetails.PackedDate, tt.RegShiftID, DeliveryDetails.Note, DeliveryDetails.SentDate, DeliveryDetails.Shift, DeliveryDetails.Box, DeliveryDetails.DeliverdDate, DeliveryDetails.PaidString, 
                         DeliveryDetails.StatusType, tt.TransactionNo, Registers.RegisterNo, tt.StartSaleTime, Users.UserName, (CASE WHEN isnull(DeliveryDetails.TempAddress, '') 
                         <> '' THEN DeliveryDetails.TempAddress ELSE dbo.CustomerAddresses.Street1 + '  ' + ISNULL(dbo.CustomerAddresses.Street2, '') END) AS FullAddress, (CASE WHEN isnull(DeliveryDetails.TempAddress, '') 
                         <> '' THEN DeliveryDetails.TempAddress WHEN ISNULL(dbo.CustomerAddresses.Name, '') = '' THEN dbo.Customer.LastName + ' ' + ISNULL(dbo.Customer.FirstName, '') ELSE dbo.CustomerAddresses.Name END) 
                         AS ShipName, (CASE WHEN isnull(DeliveryDetails.TempCityStateZip, '') 
                         <> '' THEN DeliveryDetails.TempCityStateZip ELSE dbo.CustomerAddresses.City + ', ' + dbo.CustomerAddresses.State + ' ' + dbo.CustomerAddresses.Zip END) AS CityStateZip, 
                         Customer.LastName + ' ' + ISNULL(Customer.FirstName, '') AS CustomerName, DeliveryDetails.DeliveryDetailID, DeliveryDetails.Freezer, DeliveryDetails.Status AS StatusValue, 
                         DeliveryDetails.BeDeliverdDate AS ScheduledDate, Customer.CustomerID, ISNULL(DeliveryDetails.BatchID, 0) AS BatchID, tt.Debit AS OrderAmount, Customer.BalanceDoe AS TotalBalance, Customer.CustomerNo, 
                         DeliveryDetails.ShippedDate, DeliveryDetails.ReturnedDate, Customer.FirstName, Customer.LastName, tt.TransactionID, DeliveryDetails.Cases, CAST(DeliveryDetails.Number AS int) AS Number, 
                         CustomerAddresses.PhoneNumber2 AS CellPhone, CASE WHEN ISNUMERIC(SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1))) = 1 THEN SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1)) 
                         ELSE '' END AS HouseNo, PhoneOrder.PhoneOrderDate, (CASE WHEN dbo.DeliveryDetails.Status = 2 THEN DATEDIFF(MINUTE, ShippedDate, dbo.GetLocalDate()) 
                         WHEN dbo.DeliveryDetails.Status = 6 THEN - 6 WHEN dbo.DeliveryDetails.Status = 4 THEN - 4 END) AS TimeInTransit, SUBSTRING(CustomerAddresses.Street1, CHARINDEX(' ', CustomerAddresses.Street1 + ' ', 1) + 1, 
                         LEN(CustomerAddresses.Street1)) AS StreetName, PhoneOrder.ShiftID AS PhoneShift, PhoneOrderType.SystemValueName AS PhoneType, Customer.Email, '' AS Zone, DeliveryDetails.SortOrder, DeliveryDetails.TotalScan, 
                         DeliveryDetails.DateModified, CustomerAddresses.Street1, CustomerAddresses.Street2, CustomerAddresses.City, CustomerAddresses.State, CustomerAddresses.Zip,
CONVERT(nvarchar(500), 
  STUFF
  ((SELECT DISTINCT
    ',' + t.TenderName
  FROM dbo.Tender AS t
  INNER JOIN dbo.TenderEntry AS te
    ON te.TenderID = t.TenderID
  WHERE te.transactionid = tt.transactionid
  FOR xml PATH ('')), 1, 1, '')) AS TenderName,
       CONVERT(nvarchar(500), STUFF
  ((SELECT DISTINCT
    ',' +  CustomerGroup.CustomerGroupName
FROM            dbo.CustomerToGroup INNER JOIN
                         dbo.CustomerGroup ON CustomerToGroup.CustomerGroupID = CustomerGroup.CustomerGroupID
WHERE        (CustomerGroup.Sort = 0) AND (CustomerGroup.Status > 0) AND (CustomerToGroup.Status > 0) AND CustomerToGroup.CustomerID = DeliveryDetails.CustomerID
FOR xml PATH ('')), 1, 1, '')) AS Section
FROM            dbo.DeliveryDetails WITH (NOLOCK) INNER JOIN
                         dbo.Customer WITH (NOLOCK) ON DeliveryDetails.CustomerID = Customer.CustomerID INNER JOIN
                         dbo.[Transaction] AS tt WITH (NOLOCK) ON tt.TransactionID = DeliveryDetails.TransactionID LEFT OUTER JOIN
                         dbo.Users AS Packed ON DeliveryDetails.PackedBy = Packed.UserId LEFT OUTER JOIN
                         dbo.CustomerAddresses WITH (NOLOCK) ON DeliveryDetails.ShippingAdress = CustomerAddresses.CustomerAddressID LEFT OUTER JOIN
                         dbo.Users ON DeliveryDetails.Driver = Users.UserId LEFT OUTER JOIN
                         dbo.Registers ON DeliveryDetails.RegID = Registers.RegisterID LEFT OUTER JOIN
                         dbo.RegShift WITH (NOLOCK) ON tt.RegShiftID = RegShift.RegShiftID LEFT OUTER JOIN
                         dbo.PhoneOrder WITH (NOLOCK) ON tt.TransactionID = PhoneOrder.TransactionID LEFT OUTER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            dbo.SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
WHERE        (DeliveryDetails.Status > - 1)
GO