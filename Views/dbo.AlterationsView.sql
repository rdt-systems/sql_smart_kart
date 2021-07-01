SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[AlterationsView]
AS
SELECT DISTINCT 
                         Alterations.AlterationID, Conveyor.Rack + '-' + CONVERT(nvarchar(50), Conveyor.RowNo) AS SlotNo, 
                         CASE WHEN Alterations.AlterationStatus = 1 THEN 'Open' WHEN Alterations.AlterationStatus = 2 THEN 'Working Now' WHEN Alterations.AlterationStatus = 3 THEN 'Ready' WHEN Alterations.AlterationStatus = 4 THEN 'Closed' END
                          AS Status, T.StartSaleTime AS SaleDate, Alterations.ExpectedDate, CONVERT(nvarchar(MAX), Alterations.Note) AS ExtraInfo, Alterations.AlterationNo, T.TransactionNo, TR.Name AS ItemName, TR.ItemCode AS UPC, 
                         TR.ModalNumber AS ItemCode, C.CustomerNo, C.Name, Conveyor.StoreID, Store.StoreName, C.Address, C.CityStateAndZip, C.Phone, Alterations.TransactionID, Alterations.TransactionEntryID, S.ReadyDate, S.ClosedDate, C.BalanceDoe, DATEDIFF (DD,Alterations.DateCreated,S.ReadyDate ) AS ETA
FROM            Alterations INNER JOIN
                         Conveyor ON Alterations.ConveyorID = Conveyor.ConveyorID INNER JOIN
                         [Transaction] AS T ON Alterations.TransactionID = T.TransactionID INNER JOIN
                         TransactionEntryView AS TR ON Alterations.TransactionEntryID = TR.TransactionEntryID INNER JOIN
                         CustomerView AS C ON T.CustomerID = C.CustomerID INNER JOIN
                         Store ON Store.StoreID = Conveyor.StoreID LEFT OUTER JOIN
                         AlterationsStatusView AS S ON Alterations.AlterationID = S.AlterationID
WHERE        (Conveyor.Status > 0) AND (T.Status > 0)
GO