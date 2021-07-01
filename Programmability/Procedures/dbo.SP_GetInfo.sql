SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetInfo](
	@SupplierID uniqueidentifier,
	@PoID Uniqueidentifier = NULL,
	@ReceiveID Uniqueidentifier = NULL,
	@PO bit = 0
	)


AS

IF @PO = 1


BEGIN

IF @PoID IS NULL

BEGIN

Select TOP (1) SupplierID, PurchaseOrderId, PO.LastPurchased, NULL AS DateCreated, NULL AS CreatedBy, NULL AS DateModified, NULL AS  ModifiedBy  From Supplier S LEFT OUTER JOIN PurchaseOrders R ON S.SupplierID = R.SupplierNo LEFT OUTER JOIN (
Select SupplierNo, CAST(MAX(PurchaseOrderDate) as date) AS LastPurchased  from PurchaseOrders Where Status > 0 GROUP BY SupplierNo) AS PO on R.SupplierNo = PO.SupplierNo
LEFT OUTER JOIN Users C ON R.UserCreated = C.UserId LEFT OUTER JOIN Users M on R.UserModified = M.UserID
Where S.SupplierID = @SupplierID 
Order By PO.LastPurchased Desc

END

ELSE BEGIN

Select TOP (1) SupplierID, PurchaseOrderId, PO.LastPurchased, R.DateCreated, ISNULL(C.UserFName,'') + ' ' + ISNULL(C.UserLName,'') AS CreatedBy, R.DateModified, ISNULL(M.UserFName,'') + ' ' + ISNULL(M.UserLName,'') AS ModifiedBy  From Supplier S LEFT OUTER JOIN PurchaseOrders R ON S.SupplierID = R.SupplierNo LEFT OUTER JOIN (
Select SupplierNo, CAST(MAX(PurchaseOrderDate) As Date) AS LastPurchased  from PurchaseOrders Where Status > 0 GROUP BY SupplierNo) AS PO on R.SupplierNo = PO.SupplierNo
LEFT OUTER JOIN Users C ON R.UserCreated = C.UserId LEFT OUTER JOIN Users M on R.UserModified = M.UserID
Where R.PurchaseOrderId = @PoID 
Order By PO.LastPurchased Desc

	END






END


ELSE BEGIN

IF @ReceiveID IS NULL

BEGIN

Select TOP (1) SupplierID, ReceiveID, Received.LastReceived,NULL AS DateCreated, NULL AS CreatedBy, NULL AS DateModified, NULL AS  ModifiedBy  From Supplier S LEFT OUTER JOIN ReceiveOrder R ON S.SupplierID = R.SupplierNo LEFT OUTER JOIN (
Select SupplierNo, MAX(ReceiveOrderDate) AS LastReceived  from ReceiveOrder Where Status > 0 GROUP BY SupplierNo) AS Received on R.SupplierNo = Received.SupplierNo
LEFT OUTER JOIN Users C ON R.UserCreated = C.UserId LEFT OUTER JOIN Users M on R.UserModified = M.UserID
Where S.SupplierID = @SupplierID 
Order By Received.LastReceived Desc
END

Else Begin

Select TOP (1) SupplierID, ReceiveID, Received.LastReceived, R.DateCreated, ISNULL(C.UserFName,'') + ' ' + ISNULL(C.UserLName,'') AS CreatedBy, R.DateModified, ISNULL(M.UserFName,'') + ' ' + ISNULL(M.UserLName,'') AS ModifiedBy  From Supplier S LEFT OUTER JOIN ReceiveOrder R ON S.SupplierID = R.SupplierNo LEFT OUTER JOIN (
Select SupplierNo, MAX(ReceiveOrderDate) AS LastReceived  from ReceiveOrder Where Status > 0 GROUP BY SupplierNo) AS Received on R.SupplierNo = Received.SupplierNo
LEFT OUTER JOIN Users C ON R.UserCreated = C.UserId LEFT OUTER JOIN Users M on R.UserModified = M.UserID
Where R.ReceiveID = @ReceiveID
Order By Received.LastReceived Desc

	End
	
	END
GO