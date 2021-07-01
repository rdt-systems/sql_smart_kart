SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[RPT_CustomersPhoneOrders]
(@FromDate datetime,
 @ToDate datetime)
AS
SELECT        C.CustomerNo, C.LastName, C.FirstName, C.Address, C.City, C.State, C.Zip, SUM(PhoneOrderEntryPickSheet.Qty) AS Qty, PhoneOrderEntryPickSheet.Name, PhoneOrderEntryPickSheet.BarcodeNumber, 
                         CAST(CAST(SUM(PhoneOrderEntryPickSheet.Qty) AS decimal) AS nvarchar) + ' ' + PhoneOrderEntryPickSheet.Name AS FullDescription, PhoneOrderEntryPickSheet.ModalNumber, 
                         PhoneOrderEntryPickSheet.ManufacturerPartNo
FROM            PhoneOrderEntryPickSheet INNER JOIN
                         PhoneOrder ON PhoneOrderEntryPickSheet.PhoneOrderID = PhoneOrder.PhoneOrderID INNER JOIN
                         CustomerView AS C ON PhoneOrder.CustomerID = C.CustomerID
WHERE        (PhoneOrderEntryPickSheet.Status > 0) AND (dbo.GetDay(PhoneOrder.PhoneOrderDate) >= @FromDate) AND (dbo.GetDay(PhoneOrder.PhoneOrderDate) <= @ToDate)
GROUP BY C.CustomerNo, C.LastName, C.FirstName, C.Address, C.City, C.State, C.Zip, PhoneOrderEntryPickSheet.Name, PhoneOrderEntryPickSheet.BarcodeNumber, PhoneOrderEntryPickSheet.ModalNumber, 
                         PhoneOrderEntryPickSheet.ManufacturerPartNo
GO