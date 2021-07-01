SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetPhoneOrder]
(@Filter nvarchar(4000))
as
declare @MySelect VARCHAR(MAX)



set @MySelect= N'SELECT   DISTINCT     PhoneOrder.DriversNote, PhoneOrder.PickNote, PhoneOrderType.SystemValueName AS PhoneOrderType, PhoneOrder.PhoneOrderID, PhoneOrder.Status, RTRIM(PhoneOrder.ShiftID) AS ShiftID, 
                         TENDERS.TenderName AS Tender, PhoneOrder.Total, PhoneOrder.PhoneOrderDate, dbo.FormatDateTime(PhoneOrder.PhoneOrderTime, ''HH:MM:SS 12'') AS PhoneOrderTime, PhoneOrder.DeliveryDate, 
                         PhoneOrder.PhoneOrderNo, CustomerView.Name, CustomerView.CustomerNo, 
                         (CASE WHEN PhoneOrder.PhoneOrderStatus = 0 THEN ''Open'' WHEN PhoneOrder.PhoneOrderStatus = 1 THEN ''Process'' WHEN PhoneOrder.PhoneOrderStatus = 2 THEN ''Pick'' WHEN PhoneOrder.PhoneOrderStatus
                          = 3 THEN ''Hold'' END) AS PhoneOStatus, tPickBy.UserFName AS PickBy, CustomerAddresses.Street1 AS ShipAddress, CustomerView.Address AS CustAddress, tTakeBy.UserFName AS TakeBy, 
                         Drivers.UserName AS Driver, STUFF
                             ((SELECT DISTINCT '','' + G.CustomerGroupName
							 FROM            dbo.CustomerToGroup AS IG INNER JOIN
                         dbo.CustomerGroup G ON IG.CustomerGroupID = G.CustomerGroupID
WHERE        (G.Sort = 0) AND (G.Status > 0) AND (IG.Status > 0)
                              And  IG.CustomerID = PhoneOrder.CustomerID  FOR XML PATH('''')), 1, 1, '''') AS Zone,
							  Cleared.LastDateCleared , PhoneOrder.Freezer,
									  	   (select  sum(
								   case when PhoneOrderEntry.UOMType=2 
							  then  isnull( (CASE WHEN ItemMain.CostByCase = 1 THEN ItemStore.Cost ELSE ItemStore.Cost * ItemMain.CaseQty END),0)*isnull(PhoneOrderEntry.Qty,0) 
							  else isnull(CASE WHEN ItemMain.CostByCase = 1 AND ItemMain.CaseQty <> 0 THEN ItemStore.Cost / ItemMain.CaseQty ELSE ItemStore.Cost END,0)*isnull(PhoneOrderEntry.Qty,0) end ) as Cost
							  from PhoneOrderEntry join ItemStore  on PhoneOrderEntry.ItemStoreNo =ItemStore.ItemStoreId 
							  join itemmain on ItemStore.ItemNo=itemmain.ItemID
							  where 1=1  and PhoneOrderEntry.status>-1
							  and PhoneOrderEntry.PhoneOrderID=PhoneOrder.PhoneOrderID
							  group by PhoneOrderEntry.PhoneOrderID  ) as Cost  
FROM        dbo.PhoneOrder WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.Users AS Drivers INNER JOIN
                         dbo.DeliveryDetails WITH (NOLOCK)  ON Drivers.UserId = DeliveryDetails.Driver ON PhoneOrder.TransactionID = DeliveryDetails.TransactionID LEFT OUTER JOIN
                         dbo.CustomerAddresses ON PhoneOrder.ShippingID = CustomerAddresses.CustomerAddressID LEFT OUTER JOIN
                         (Select C.CustomerID, ISNULL(C.LastName, '''') + ISNULL('', '' + CASE WHEN C.FirstName = '''' THEN NULL ELSE C.FirstName END, '' '') AS Name, A.Street1 AS Address, C.CustomerNo
						 From dbo.Customer C INNER JOIN dbo.CustomerAddresses A ON C.CustomerID = A.CustomerID AND C.MainAddressID = A.CustomerAddressID 
						 Where A.AddressType = 6 AND A.Status > 0) AS CustomerView ON CustomerView.CustomerID = PhoneOrder.CustomerID LEFT OUTER JOIN
                         Users AS tPickBy ON PhoneOrder.PickByID = tPickBy.UserId LEFT OUTER JOIN
                         Users AS tTakeBy ON tTakeBy.UserId = PhoneOrder.TakeByID LEFT OUTER JOIN
                             (SELECT        TenderName, TenderID
                               FROM            Tender
                               WHERE        (Status > 0)) AS TENDERS ON PhoneOrder.TenderID = TENDERS.TenderID LEFT OUTER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON PhoneOrder.Type = PhoneOrderType.SystemValueNo
							    LEFT OUTER JOIN
	 (SELECT DISTINCT CustomerID, MAX(StartSaleTime) AS LastDateCleared
                               FROM            dbo.[Transaction] AS T WITH (NOLOCK)
                               WHERE        (Status > 0) AND (CurrBalance <= 0) AND (CustomerID IS NOT NULL)
                               GROUP BY CustomerID) AS Cleared ON PhoneOrder.CustomerID = Cleared.CustomerID 
WHERE  '

PRINT (@MySelect + @Filter )
Execute (@MySelect + @Filter )


/*SELECT        PhoneOrder.PhoneOrderID, PhoneOrder.Status, RTRIM(PhoneOrder.ShiftID) AS ShiftID, PhoneOrder.Total, PhoneOrder.PhoneOrderDate, 
                         PhoneOrder.PhoneOrderTime, PhoneOrder.DeliveryDate, PhoneOrder.PhoneOrderNo, CustomerView.Name, CustomerView.CustomerNo, 
                         (CASE WHEN PhoneOrder.PhoneOrderStatus = 0 THEN 'Open' WHEN PhoneOrder.PhoneOrderStatus = 1 THEN 'Process' WHEN PhoneOrder.PhoneOrderStatus
                          = 2 THEN 'Pick' WHEN PhoneOrder.PhoneOrderStatus = 3 THEN 'Hold' END) AS PhoneOStatus, Users_1.UserFName AS PickBy, 
                         CustomerAddresses.Street1 AS ShipAddress, CustomerView.Address AS CustAddress, Users.UserFName AS TakeBy
FROM            PhoneOrder INNER JOIN
                         Users ON PhoneOrder.TakeByID = Users.UserId LEFT OUTER JOIN
                         CustomerAddresses ON PhoneOrder.ShippingID = CustomerAddresses.CustomerAddressID LEFT OUTER JOIN
                         CustomerView ON CustomerView.CustomerID = PhoneOrder.CustomerID LEFT OUTER JOIN
                         Users AS Users_1 ON PhoneOrder.PickByID = Users_1.UserId

SELECT  PhoneOrder.PhoneOrderID,PhoneOrder.Status,RTRIM(dbo.PhoneOrder.ShiftID) AS ShiftID,PhoneOrder.Total,PhoneOrderDate,PhoneOrderTime, phoneorder.DeliveryDate, PhoneOrder.PhoneOrderNo,CustomerView.[Name],CustomerView.CustomerNo,(Case When PhoneOrder.PhoneOrderStatus=0 then 'Open'
 						when  PhoneOrder.PhoneOrderStatus=1 then 'Process'
						when  PhoneOrder.PhoneOrderStatus=2 then 'Pick'
						when  PhoneOrder.PhoneOrderStatus=3 then 'Hold' end) as PhoneOStatus,
 						Users.UserFName as PickBy, CustomerAddresses.Street1 as ShipAddress , CustomerView.Address as CustAddress
		FROM dbo.PhoneOrder Left outer Join CustomerAddresses ON PhoneOrder.ShippingID = CustomerAddresses.CustomerAddressID LEFT OUTER JOIN
                     CustomerView On CustomerView.CustomerID=PhoneOrder.CustomerID  Left outer join
                     Users On Users.UserID=PhoneOrder.PickByID */


					-- insert into sqlStatmentLog (sqlString ) values(@MySelect )
					--
--					 		 insert into sqlStatmentLog (sqlString ) values(@Filter)

					-- select*  from sqlStatmentLog order by 1 

					--truncate table sqlStatmentLog
GO