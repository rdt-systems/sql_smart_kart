SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GETShippingInfo](@DateModified datetime)
AS
SELECT        T.TransactionNo, D.Shift, C.FirstName, C.LastName, A.Street1, A.Street2, A.City, A.State, A.Zip, C.CustomerNo, A.PhoneNumber2 AS CellPhone, D.Box, D.Cases, D.Note, D.DeliveryDetailID, D.BeDeliverdDate AS ScheduledDate, 
                         T.Debit AS OrderAmount, C.BalanceDoe AS TotalBalance, PP.PhoneType, T.StartSaleTime
,
CONVERT(nvarchar(500), 
  STUFF
  ((SELECT DISTINCT
    ',' + t.TenderName
  FROM dbo.Tender AS t
  INNER JOIN dbo.TenderEntry AS te WITH (NOLOCK)
    ON te.TenderID = t.TenderID
  WHERE te.transactionid = D.transactionid
  FOR xml PATH ('')), 1, 1, '')) AS TenderName,
       CONVERT(nvarchar(500), STUFF
  ((SELECT DISTINCT
    ',' +  CustomerGroup.CustomerGroupName
FROM            dbo.CustomerToGroup WITH (NOLOCK) INNER JOIN
                         dbo.CustomerGroup WITH (NOLOCK) ON CustomerToGroup.CustomerGroupID = CustomerGroup.CustomerGroupID
WHERE        (CustomerGroup.Sort = 0) AND (CustomerGroup.Status > 0) AND (CustomerToGroup.Status > 0) AND CustomerToGroup.CustomerID = D.CustomerID
FOR xml PATH ('')), 1, 1, '')) AS Section
FROM            dbo.DeliveryDetails AS D WITH (NOLOCK) INNER JOIN
                         dbo.[Transaction] AS T WITH (NOLOCK) ON D.TransactionID = T.TransactionID INNER JOIN
                         dbo.Customer AS C WITH (NOLOCK) ON D.CustomerID = C.CustomerID INNER JOIN
                         dbo.CustomerAddresses AS A WITH (NOLOCK) ON D.ShippingAdress = A.CustomerAddressID LEFT OUTER JOIN
                             (SELECT        P.TransactionID, S.SystemValueName AS PhoneType
                               FROM            dbo.PhoneOrder AS P WITH (NOLOCK) INNER JOIN
                                                         dbo.SystemValues AS S ON P.Type = S.SystemValueNo AND S.SystemTableNo = 56) AS PP ON D.TransactionID = PP.TransactionID
WHERE    ISNULL(D.TotalScan,0) = 0 AND    (D.Status > 0) AND (D.DateModified >= CAST(dbo.GetLocalDate() - 5 AS date)) AND D.DateModified > @DateModified
GO