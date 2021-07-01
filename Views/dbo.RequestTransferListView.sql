SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[RequestTransferListView]

AS

SELECT      T.RequestTransferID,  T.RequestDate, T.RequestNo, (CASE WHEN T.RequestStatus = 2 THEN 'CLOSE' WHEN T.RequestStatus = 1 THEN 'PARTIAL' ELSE 'OPEN' END) AS RequestStatus,
ISNULL(T.RequestStatus,1) AS ReqStatus,
ISNULL(U.UserFName, '') + ' ' + ISNULL(U.UserLName, '') AS RequastedBy,
						 ST.StoreName AS InStore, Frm.StoreName AS FromStore, T.FromStoreID AS StoreID, ISNULL(C.FirstName, '') 
                         + ' ' + ISNULL(C.LastName, '') AS ReqFor,ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, '') AS CustName, C.CustomerNo AS PhoneNo, A.PhoneNumber2 AS Cell, M.BarcodeNumber, M.Name,
						 A.Street1, A.Street2, A.City, A.State, A.Zip, A.Country, ISNULL(A.UseSMS,0) AS UseSMS,
						 S.Cost, S.Price, E.CustomerID, T.Note, E.Note AS OtherNote,
						 T.FromStoreID, T.ToStoreID
FROM            dbo.CustomerAddresses AS A WITH (NOLOCK) INNER JOIN
                         dbo.Customer AS C WITH (NOLOCK) ON A.CustomerID = C.CustomerID AND A.CustomerAddressID = C.MainAddressID RIGHT OUTER JOIN
                         dbo.RequestTransfer AS T WITH (NOLOCK) INNER JOIN
                         dbo.RequestTransferEntry AS E WITH (NOLOCK) ON T.RequestTransferID = E.RequestTransferID INNER JOIN
                         dbo.ItemStore AS S WITH (NOLOCK) ON E.ItemStoreID = S.ItemStoreID INNER JOIN
                         dbo.ItemMain AS M WITH (NOLOCK) ON S.ItemNo = M.ItemID INNER JOIN
                         dbo.Store AS ST WITH (NOLOCK) ON T.ToStoreID = ST.StoreID INNER JOIN Store AS Frm ON T.FromStoreID = Frm.StoreID ON C.CustomerID = E.CustomerId LEFT OUTER JOIN
                         dbo.Users AS U WITH (NOLOCK) ON T.UserCreated = U.UserId
Where T.Status > 0 and E.Status > 0


GO