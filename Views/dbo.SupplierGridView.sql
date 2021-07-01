SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[SupplierGridView]
AS
SELECT        dbo.Supplier.SupplierID, dbo.Supplier.SupplierNo, dbo.Supplier.Name, dbo.Supplier.DefaultCredit, dbo.Supplier.WebSite, dbo.Supplier.EmailAddress, dbo.Supplier.MainAddress, dbo.Supplier.ContactName, 
                         dbo.Supplier.BarterID, dbo.Supplier.WarehouseID, dbo.Supplier.Status, dbo.Supplier.DateCreated, dbo.Supplier.UserCreated, dbo.Supplier.DateModified, dbo.Supplier.UserModified, Orders.OpenInvoice, 
                         lr.LastReceive, ISNULL(MD.DTM, 0) - ISNULL(ReturnMD.DTM, 0) AS DTM, ISNULL(DT.DTP, 0) - ISNULL(ReturnDT.DTP, 0) AS DTP, ISNULL(Dy.DTY, 0) - ISNULL(ReturnDy.DTY, 0) AS DTY, 
                         ISNULL(Receives.ReceivesAmount, 0) - ISNULL(Payments.PaymentsAmount, 0) - ISNULL(ReturnVs.ReturnsAmount, 0) AS Balance, dbo.Supplier.AccountNo, 
  STUFF ((SELECT DISTINCT ',' + convert(nvarchar(max),SupplierNotes.NoteValue)
                                 FROM            SupplierNotes 
                                 WHERE        SupplierNotes.supplierid = dbo.Supplier.SupplierID AND SupplierNotes.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '')as Note,  dbo.SupplierAddresses.PhoneNumber1 AS PhoneNumber, dbo.SupplierAddresses.PhoneNumber2 AS FaxNumber, dbo.SupplierAddresses.PhoneNumber3 AS PhoneNumber2
FROM            dbo.Supplier LEFT OUTER JOIN
                         dbo.SupplierAddresses ON dbo.Supplier.MainAddress = dbo.SupplierAddresses.AddressID LEFT OUTER JOIN
                             (SELECT        SUM(GrandTotal) AS OpenInvoice, SupplierNo
                               FROM            dbo.PurchaseOrders
                               WHERE        (POStatus < 2) AND (Status > 0)
                               GROUP BY SupplierNo) AS Orders ON Orders.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        CONVERT(Nvarchar, MAX(ReceiveOrderDate), 110) AS LastReceive, SupplierNo
                               FROM            dbo.ReceiveOrder
                               WHERE        (Status > 0)
                               GROUP BY SupplierNo) AS lr ON lr.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTM, SupplierNo
                               FROM            dbo.ReceiveOrder AS ReceiveOrder_3
                               WHERE        (YEAR(ReceiveOrderDate) = YEAR(dbo.GetLocalDATE())) AND (MONTH(ReceiveOrderDate) = MONTH(dbo.GetLocalDATE())) AND (Status > 0)
                               GROUP BY SupplierNo) AS MD ON MD.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTM, SupplierID
                               FROM            dbo.ReturnToVender
                               WHERE        (YEAR(ReturnToVenderDate) = YEAR(dbo.GetLocalDATE())) AND (MONTH(ReturnToVenderDate) = MONTH(dbo.GetLocalDATE())) AND (Status > 0)
                               GROUP BY SupplierID) AS ReturnMD ON ReturnMD.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTP, SupplierNo
                               FROM            dbo.ReceiveOrder AS ReceiveOrder_2
                               WHERE        (YEAR(ReceiveOrderDate) = YEAR(dbo.GetLocalDATE())) AND (MONTH(ReceiveOrderDate) > MONTH(dbo.GetLocalDATE()) - 2) AND (Status > 0)
                               GROUP BY SupplierNo) AS DT ON DT.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTP, SupplierID
                               FROM            dbo.ReturnToVender AS ReturnToVender_3
                               WHERE        (YEAR(ReturnToVenderDate) = YEAR(dbo.GetLocalDATE())) AND (MONTH(ReturnToVenderDate) > MONTH(dbo.GetLocalDATE()) - 2) AND (Status > 0)
                               GROUP BY SupplierID) AS ReturnDT ON ReturnDT.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTY, SupplierNo
                               FROM            dbo.ReceiveOrder AS ReceiveOrder_1
                               WHERE        (YEAR(ReceiveOrderDate) = YEAR(dbo.GetLocalDATE())) AND (Status > 0)
                               GROUP BY SupplierNo) AS Dy ON Dy.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS DTY, SupplierID
                               FROM            dbo.ReturnToVender AS ReturnToVender_2
                               WHERE        (YEAR(ReturnToVenderDate) = YEAR(dbo.GetLocalDATE())) AND (Status > 0)
                               GROUP BY SupplierID) AS ReturnDy ON ReturnDy.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Amount) AS PaymentsAmount, SupplierID
                               FROM            dbo.SupplierTenderEntry
                               WHERE        (Status > 0)
                               GROUP BY SupplierID) AS Payments ON Payments.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS ReceivesAmount, SupplierNo
                               FROM            dbo.ReceiveOrderView
                               WHERE        (Status > 0)
                               GROUP BY SupplierNo) AS Receives ON Receives.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS ReturnsAmount, SupplierID
                               FROM            dbo.ReturnToVender AS ReturnToVender_1
                               WHERE        (Status > 0)
                               GROUP BY SupplierID) AS ReturnVs ON ReturnVs.SupplierID = dbo.Supplier.SupplierID
GO