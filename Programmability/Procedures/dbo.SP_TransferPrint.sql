SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferPrint](@ID uniqueidentifier)
AS 
SELECT        TransferItems.TransferNo, FromStore.StoreName AS FromStoreName, ToStore.StoreName AS ToStoreName, TransferItems.Note, TransferItems.TransferDate, FromStore.Address AS FromAddress, 
                         FromStore.CityStateZip AS FromCityStateZip, ToStore.Address AS ToAddress, ToStore.CityStateZip AS ToCityStateZip, TransferItems.TransferID, ISNULL(Users.UserName,'') AS UserCreated,
						 Info.CustomerNo, Info.CustomerName, Info.Cell, Info.Address, Info.CityStateZip
FROM            Store AS FromStore INNER JOIN
                         TransferItems ON FromStore.StoreID = TransferItems.FromStoreID INNER JOIN
                         Store AS ToStore ON TransferItems.ToStoreID = ToStore.StoreID LEFT OUTER JOIN
                         Users ON TransferItems.UserCreated = Users.UserId LEFT OUTER JOIN
						 (Select DISTINCT TransferID, C.CustomerNo, 
						 ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') AS CustomerName, A.PhoneNumber2 AS Cell, ISNULL(A.Street1,'') + ' ' +  ISNULL(A.Street2,'') AS Address, ISNULL(A.City,'')+', '+ ISNULL(A.State,'')+ ' ' + ISNULL(A.Zip,'')  AS CityStateZip
						From TransferEntry T INNER JOIN RequestTransferEntry R ON T.RequestTransferEntryID = R.RequestTransferEntryID INNER JOIN Customer C 
						ON R.CustomerId = C.CustomerID INNER JOIN CustomerAddresses A 
						ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID) AS Info ON TransferItems.TransferID = Info.TransferID
WHERE     (TransferItems.TransferID = @ID) AND  (TransferItems.Status > 0)
GO