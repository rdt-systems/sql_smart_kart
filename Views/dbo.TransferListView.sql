SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO









CREATE VIEW [dbo].[TransferListView]

AS

SELECT       DISTINCT  ISNULL(U.UserFName, '') + ' ' + ISNULL(U.UserLName, '') AS SentBy, ISNULL(T.TransferStatus,1) AS TransferStatus, ST.StoreName AS FromStore, ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, '') AS SentFor, C.CustomerNo AS PhoneNo,
						A.PhoneNumber2 AS Cell, A.Street1, A.Street2, A.City, A.State, A.Zip, A.Country, ISNULL(A.UseSMS,0) AS UseSMS,
                         M.BarcodeNumber, M.ModalNumber, M.Name, S.Cost, S.Price, RE.CustomerId, E.Qty, T.ToStoreID AS StoreID, T.TransferDate, T.TransferNo, T.TransferID, T.FromStoreID, FR.StoreName AS ToStore 
FROM         dbo.TransferEntry AS E WITH (NOLOCK) INNER JOIN
                         dbo.TransferItems AS T WITH (NOLOCK) ON E.TransferID = T.TransferID LEFT OUTER JOIN 
   dbo.RequestTransferEntry AS RE WITH (NOLOCK) ON E.RequestTransferEntryID = RE.RequestTransferEntryID LEFT OUTER JOIN ItemStore AS S ON E.ItemStoreNo = S.ItemStoreID INNER JOIN
                         dbo.ItemMain AS M WITH (NOLOCK) ON S.ItemNo = M.ItemID INNER JOIN
                         dbo.Store AS ST WITH (NOLOCK) ON ST.StoreID = T.FromStoreID INNER JOIN
						 dbo.Store AS FR WITH (NOLOCK) ON FR.StoreID = T.ToStoreID LEFT OUTER JOIN
                         dbo.Users AS U WITH (NOLOCK) ON T.UserCreated = U.UserId LEFT OUTER JOIN
                         dbo.Customer AS C WITH (NOLOCK) ON RE.CustomerId = C.CustomerID LEFT OUTER JOIN CustomerAddresses AS A ON C.MainAddressID = A.CustomerAddressID AND C.CustomerID = A.CustomerID AND A.AddressType = 6
WHERE        (E.Status > 0) AND (T.Status > 0)
GO