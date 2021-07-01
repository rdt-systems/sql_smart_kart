SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveOrderToApprove]
(@FromDate datetime,
@ToDate datetime)
as
Select * ,Supp.[Name] as SupplierName
from ReceiveOrderView inner Join
	(Select ReceiveNo
 	from ReceiveEntry
 	Where ForApprove=1 and Status>0
	GROUP BY ReceiveNo) ReEntry ON ReEntry.ReceiveNo = dbo.ReceiveOrderView.ReceiveID inner Join
	(Select [Name],SupplierID
	from Supplier 
	Where Status>0
	Group By SupplierID,[Name]) Supp On Supp.SupplierID=dbo.ReceiveOrderView.SupplierNo
where Status>0 and  ReceiveOrderView.BillDate>=@FromDate and ReceiveOrderView.BillDate<@ToDate
GO