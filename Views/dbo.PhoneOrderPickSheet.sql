SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO











CREATE VIEW [dbo].[PhoneOrderPickSheet]
AS
SELECT        PhoneOrder.PhoneOrderID, PhoneOrderType.SystemValueName AS Type, PhoneOrder.PhoneOrderDate, PhoneOrder.PhoneOrderTime, PhoneOrder.PhoneOrderNo, CustomerView.Name, 
                         CustomerView.CustomerNo, PhoneOrder.ShiftID, PhoneOrder.PickNote, CustomerView.Phone, CustomerView.Cell, ISNULL(CustomerView.Address,'') + ' ' + ISNULL(CustomerView.Address2,'') AS Address , CustomerView.CityStateAndZip, PhoneOrder.DeliveryDate, 
                       CustomerAddresses.Name as ShipName, CustomerAddresses.Street1 AS ShipAddress, CustomerAddresses.City + N' ' + CustomerAddresses.State + N' ' + CustomerAddresses.Zip AS ShipCityStateZip, Users.UserName AS TakeBy, 
						 CustomerView.LastDateCleared, CustomerAddresses.PhoneNumber1 AS ShipPhone, 	 CustomerAddresses.PhoneNumber2 AS ShipCell,
                         (CASE WHEN dbo.PhoneOrder.CustomerNote IS NULL THEN '"' + 	   	 STUFF((
SELECT        ', ' +convert(nvarchar(50),CustomerGroup.CustomerGroupName)
FROM            CustomerToGroup as Cg   
INNER JOIN CustomerGroup ON Cg.CustomerGroupID = CustomerGroup.CustomerGroupID
WHERE CG.CustomerID = PhoneOrder.CustomerID AND (CustomerGroup.Sort = 0) AND (CustomerGroup.Status > 0) AND (Cg.Status > 0)
FOR XML PATH(''), TYPE ).value('.', 'varchar(4000)'), 1, 1, '') + ' "' ELSE dbo.PhoneOrder.CustomerNote END) COLLATE SQL_Latin1_General_CP1_CI_AS AS  CustomerGroup,
(CASE WHEN ISNULL(dbo.PhoneOrder.CustomerNote,'') = '' THEN    	 STUFF((
SELECT        ', ' +convert(nvarchar(500),CustomerNotes.NoteValue)
FROM            CustomerNotes
WHERE CustomerID = PhoneOrder.CustomerID AND TypeOfNote = 3 AND Status >0
FOR XML PATH(''), TYPE ).value('.', 'varchar(4000)'), 1, 1, '') ELSE dbo.PhoneOrder.CustomerNote END) COLLATE SQL_Latin1_General_CP1_CI_AS AS CustomerNote, IsNull(Freezer,0) As Freezer,
Tender.TenderName
FROM            PhoneOrder LEFT OUTER JOIN
                CustomerAddresses ON PhoneOrder.ShippingID = CustomerAddresses.CustomerAddressID LEFT OUTER JOIN
                CustomerView ON CustomerView.CustomerID = PhoneOrder.CustomerID LEFT OUTER JOIN
                Users ON Users.UserId = PhoneOrder.TakeByID LEFT OUTER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
							   left outer join Tender on Tender.TenderId =PhoneOrder.TenderID

GO