SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PurchaseOrderPrintMatrixView]
AS SELECT        
PurchaseOrdersMatrixView.PoNo, 
PurchaseOrdersMatrixView.PurchaseOrderDate, 
PurchaseOrdersMatrixView.ReqDate,
(SELECT       CASE WHEN dbo.PurchaseOrdersMatrixView.POStatus = 2 THEN 'CLOSE' 
                   WHEN dbo.PurchaseOrdersMatrixView.POStatus = 1 THEN 'Partial' 
				   WHEN dbo.PurchaseOrdersMatrixView.POStatus = 0 THEN 'OPEN' END AS Expr1) AS Status, 
PurchaseOrdersMatrixView.GrandTotal, 
ISNULL(CreditView.Name, '') AS Terms, 
ISNULL(CreditView.InterestRate, 0) AS InterestRate, 
ISNULL(CreditView.InterestRate2, 0) AS InterestRate2, 
SupplierView.Name AS [Supplier Name], 
SupplierView.ContactName, 
ISNULL(ISNULL(SupplierAddressView.Line1, '') + ' ' + ISNULL(SupplierAddressView.Line2, ''), '')  AS Address, 
ISNULL(SupplierAddressView.City + ', ' + SupplierAddressView.State + ' ' + SupplierAddressView.Zip, '') AS CSZSupplier, 
PurchaseOrdersMatrixView.PurchaseOrderId,
PurchaseOrdersMatrixView.Note, 
PurchaseOrdersMatrixView.TrackNo,
ISNULL(Users.UserFName, '') + ' ' + ISNULL(Users.UserLName, '')   AS UserFName, 
PurchaseOrdersMatrixView.ExpirationDate, 
ISNULL(CustomerView.Name, '') AS ShipToName, 
ISNULL(ISNULL(AddressView.Street1, '')  + ' ' + ISNULL(AddressView.Street2, ''), '') AS ShipToAddress, 
ISNULL(ISNULL(AddressView.City, '') + ', ' + ISNULL(AddressView.State, '') + ' ' + ISNULL(AddressView.Zip, ''), '') AS CSZShipTo, 
SupplierView.SupplierNo, 
ShipViaView.ShipViaName, 
PurchaseOrdersMatrixView.Shipdrop, 
CustomerView.FirstName, 
SupplierView.AccountNo, 
SupplierAddressView.PhoneNumber2 AS Fax, 
SupplierAddressView.PhoneNumber1 AS Phone,
PurchaseOrdersMatrixView.ShipVia, 
Store.StoreNumber AS StoreNo,
Store.StoreName,
Store.Address AS StoreAddress,
Store.CityStateZip AS StoreCSZ, 
Store.Phone1 AS StoreTell,
DepartmentStore.name as DepartmentName ,
DepartmentStoreParent.name as DepartmentNameParent,
ISNULL(UsersBuyers.UserFName, UsersBuyers.UserName) + ' ' + ISNULL(UsersBuyers.UserLName, '')   AS BuyersName,
PurchaseOrdersMatrixView.VendorPONo,
Season.Name as SeasonName
FROM   ShipViaView RIGHT OUTER JOIN  PurchaseOrdersMatrixView ON ShipViaView.ShipViaID = PurchaseOrdersMatrixView.ShipVia 
INNER JOIN   SupplierView ON PurchaseOrdersMatrixView.SupplierNo = SupplierView.SupplierID
INNER JOIN   Store ON PurchaseOrdersMatrixView.StoreNo = Store.StoreID 
LEFT OUTER JOIN  SupplierAddressView ON SupplierView.MainAddress = SupplierAddressView.AddressID 
LEFT OUTER JOIN  CreditView ON PurchaseOrdersMatrixView.Termsid = CreditView.CreditID 
LEFT OUTER JOIN  Users ON PurchaseOrdersMatrixView.PersonOrderdId = Users.UserId 
LEFT OUTER JOIN  Users as UsersBuyers ON PurchaseOrdersMatrixView.BuyerID = UsersBuyers.UserId 
LEFT OUTER JOIN  DepartmentStore ON DepartmentStore.DepartmentStoreID = PurchaseOrdersMatrixView.DepartmentID 
LEFT OUTER JOIN  Season ON Season.SeasonId = PurchaseOrdersMatrixView.SeasonID 

LEFT OUTER JOIN  DepartmentStore as  DepartmentStoreParent ON DepartmentStore.ParentDepartmentID = DepartmentStoreParent.DepartmentStoreID 
LEFT OUTER JOIN   (SELECT    CustomerAddressID, CustomerID, Name, Street1, Street2, City, 
               State, Zip, Country, AddressType, CCRT, PhoneNumber1, Ext1, PhoneNumber2, Ext2, 
               SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified
		FROM CustomerAddressesView) AS AddressView 
		ON PurchaseOrdersMatrixView.ShipTo = AddressView.CustomerAddressID
		 LEFT OUTER JOIN    CustomerView	ON CustomerView.CustomerID = AddressView.CustomerID
GO