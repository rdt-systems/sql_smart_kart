SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RequestPrint](@ID uniqueidentifier)
AS 
SELECT        RequestTransfer.RequestNo, FromStore.StoreName AS FromStoreName, ToStore.StoreName AS ToStoreName, RequestTransfer.Note, RequestTransfer.RequestDate, FromStore.Address AS FromAddress, 
                         FromStore.CityStateZip AS FromCityStateZip, ToStore.Address AS ToAddress, ToStore.CityStateZip AS ToCityStateZip, RequestTransfer.RequestTransferID, ISNULL(Users.UserName,'') AS UserCreated,
						 Info.CustomerNo, Info.CustomerName, Info.Cell, Info.Address, Info.CityStateZip
FROM            Store AS FromStore INNER JOIN
                         RequestTransfer ON FromStore.StoreID = RequestTransfer.FromStoreID INNER JOIN
                         Store AS ToStore ON RequestTransfer.ToStoreID = ToStore.StoreID LEFT OUTER JOIN
                         Users ON RequestTransfer.UserCreated = Users.UserId LEFT OUTER JOIN (Select DISTINCT RequestTransferID, C.CustomerNo, 
						 ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') AS CustomerName, A.PhoneNumber2 AS Cell, ISNULL(A.Street1,'') + ' ' +  ISNULL(A.Street2,'') AS Address, ISNULL(A.City,'')+', '+ ISNULL(A.State,'')+ ' ' + ISNULL(A.Zip,'')  AS CityStateZip
						From RequestTransferEntry R INNER JOIN Customer C 
						ON R.CustomerId = C.CustomerID INNER JOIN CustomerAddresses A 
						ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID) AS Info ON RequestTransfer.RequestTransferID = Info.RequestTransferID
WHERE     (RequestTransfer.RequestTransferID = @ID) AND  (RequestTransfer.Status > 0)
GO