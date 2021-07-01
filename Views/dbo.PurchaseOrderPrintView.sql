SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PurchaseOrderPrintView]
AS
SELECT        PurchaseOrdersView.PoNo, PurchaseOrdersView.PurchaseOrderDate, PurchaseOrdersView.ReqDate,
                             (SELECT        CASE WHEN dbo.PurchaseOrdersView.POStatus = 2 THEN 'CLOSE' WHEN dbo.PurchaseOrdersView.POStatus = 1 THEN 'Partial' WHEN dbo.PurchaseOrdersView.POStatus = 0 THEN 'OPEN' END AS
                                                          Expr1) AS Status, PurchaseOrdersView.GrandTotal, ISNULL(CreditView.Name, '') AS Terms, SupplierView.Name AS [Supplier Name], SupplierView.ContactName, 
                         ISNULL(ISNULL(SupplierAddressView.Line1,'') + ' ' + ISNULL(SupplierAddressView.Line2,''), '') AS Address, ISNULL(SupplierAddressView.City + ', ' + SupplierAddressView.State + ' ' + SupplierAddressView.Zip, '') AS CSZSupplier, 
                         PurchaseOrdersView.PurchaseOrderId, PurchaseOrdersView.Note, PurchaseOrdersView.TrackNo, ISNULL(Users.UserFName, '') + ' ' + ISNULL(Users.UserLName, '') AS UserFName, 
                         PurchaseOrdersView.ExpirationDate, ISNULL(CustomerView.Name, '') AS ShipToName, ISNULL(ISNULL(AddressView.Street1, '') + ' ' + ISNULL(AddressView.Street2, ''), '') AS ShipToAddress, 
                         ISNULL(ISNULL(AddressView.City,'') + ', ' + ISNULL(AddressView.State,'') + ' ' + ISNULL(AddressView.Zip,''), '') AS CSZShipTo, SupplierView.SupplierNo, ShipViaView.ShipViaName, PurchaseOrdersView.Shipdrop, CustomerView.FirstName, 
                         SupplierView.AccountNo, SupplierAddressView.PhoneNumber2 AS Fax, SupplierAddressView.PhoneNumber1 AS Phone, PurchaseOrdersView.ShipVia, Store.StoreNumber AS StoreNo, Store.StoreName, 
                         Store.Address AS StoreAddress, Store.CityStateZip AS StoreCSZ, Store.Phone1 AS StoreTell,
						 SupplierView.SupplierNote
FROM            ShipViaView RIGHT OUTER JOIN
                         PurchaseOrdersView INNER JOIN
                         SupplierView ON PurchaseOrdersView.SupplierNo = SupplierView.SupplierID INNER JOIN
                         Store ON PurchaseOrdersView.StoreNo = Store.StoreID LEFT OUTER JOIN
                         SupplierAddressView ON SupplierView.MainAddress = SupplierAddressView.AddressID LEFT OUTER JOIN
                         CreditView ON PurchaseOrdersView.TermsNo = CreditView.CreditID LEFT OUTER JOIN
                         Users ON PurchaseOrdersView.PersonOrderdId = Users.UserId ON ShipViaView.ShipViaID = PurchaseOrdersView.ShipVia LEFT OUTER JOIN
                         CustomerView INNER JOIN
                             (SELECT        CustomerAddressID, CustomerID, Name, Street1, Street2, City, State, Zip, Country, AddressType, CCRT, PhoneNumber1, Ext1, PhoneNumber2, Ext2, SortOrder, Status, DateCreated, UserCreated, 
                                                         DateModified, UserModified
                               FROM            CustomerAddressesView) AS AddressView ON CustomerView.CustomerID = AddressView.CustomerID ON PurchaseOrdersView.ShipTo = AddressView.CustomerAddressID
GO