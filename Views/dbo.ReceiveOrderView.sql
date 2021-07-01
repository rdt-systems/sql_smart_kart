SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE VIEW [dbo].[ReceiveOrderView]
AS
SELECT        ReceiveOrder.ReceiveID, ReceiveOrder.PackingSlipNo, ReceiveOrder.StoreID, ReceiveOrder.SupplierNo, ReceiveOrder.BillID, ReceiveOrder.Freight, ReceiveOrder.Discount, ReceiveOrder.Note, 
                         ReceiveOrder.Total, ReceiveOrder.CurrBalance, ReceiveOrder.IsDiscAmount, ReceiveOrder.ReceiveOrderDate, ReceiveOrder.Status, ReceiveOrder.DateCreated, ReceiveOrder.UserCreated, 
                         ReceiveOrder.DateModified, ReceiveOrder.UserModified, BillView.BillNo, BillView.Amount, BillView.AmountPay, BillView.BillDate,
                             (SELECT        CASE WHEN BillView.Amount <= BillView.AmountPay THEN 0 ELSE 1 END AS Expr1) AS ReceiveStatus, ISNULL(BillView.Amount, 0) - ISNULL(BillView.AmountPay, 0) AS Balance, 
                         BillView.TermsID, ReceiveOrder.ReceiveOrderDate AS StartSaleTime, SupplierView.Name AS SupplierName, SupplierView.SupplierNo AS SupplierCode, 
                         SupplierView.Address1 + N' ' + SupplierView.Address2 AS SupplierAddress, SupplierView.City + N' ' + SupplierView.State + N' ' + SupplierView.Zip AS SupplierCSZ, SupplierView.PhoneNumber1, 
                         SupplierView.Ext1, SupplierView.PhoneNumber2, SupplierView.PhoneNumber3, SupplierView.ContactName, BillView.BillDue, Store.StoreName, SupplierView.AccountNo, ReceiveOrder.CustomsDuties, 
                         ReceiveOrder.OtherCharges,
						 Users.UserName
							  			 	 ,CONVERT(nvarchar(500),
	                STUFF((SELECT DISTINCT ',' + po.PoNo
                              FROM         dbo.PurchaseOrders AS po 
							  	            INNER JOIN 	dbo.PurchaseOrderEntry as poe on poe.PurchaseOrderNo=po.PurchaseOrderId
							                 INNER JOIN dbo.ReceiveEntry re ON poe.PurchaseOrderEntryId =re.PurchaseOrderEntryNo
											 Where po.Status > 0 and poe.Status > 0 and re.Status >0
                              AND     re.ReceiveNo = ReceiveOrder.ReceiveID
							FOR xml PATH ('')), 1, 1, '')) AS PoNo
FROM            ReceiveOrder INNER JOIN
                         Bill AS BillView ON ReceiveOrder.BillID = BillView.BillID INNER JOIN
                         Store ON ReceiveOrder.StoreID = Store.StoreID LEFT OUTER JOIN
                         SupplierView ON ReceiveOrder.SupplierNo = SupplierView.SupplierID
						 LEFT OUTER JOIN
                         Users ON ReceiveOrder.UserCreated = Users.UserId
GO