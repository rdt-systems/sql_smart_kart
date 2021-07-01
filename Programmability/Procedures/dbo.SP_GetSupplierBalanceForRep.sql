SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSupplierBalanceForRep]
(@FromDate  datetime,
@ToDate DateTime)

as
SELECT     dbo.Supplier.*, ISNULL(Receives.ReceivesAmount, 0) 
                      - ISNULL(Payments.PaymentsAmount, 0)-isnull(ReturnVs.ReturnsAmount,0) AS Balance
FROM         dbo.Supplier LEFT OUTER JOIN
                           (SELECT     SUM(Total) AS ReceivesAmount, SupplierNo
                            FROM          dbo.ReceiveOrder
                            WHERE      (Status > 0) and (ReceiveOrderDate>=@FromDate and ReceiveOrderDate<@ToDate)
                            GROUP BY SupplierNo) Receives ON Receives.SupplierNo = dbo.Supplier.SupplierID LEFT OUTER JOIN
                            (SELECT     SUM(Amount) AS PaymentsAmount, SupplierID
                            FROM          dbo.SupplierTenderEntry
                            WHERE      (Status > 0) and (TenderDate>=@FromDate and TenderDate<@ToDate)
                            GROUP BY SupplierID) Payments ON Payments.SupplierID = dbo.Supplier.SupplierID LEFT OUTER JOIN
                            (SELECT     SUM(Total) AS ReturnsAmount, SupplierID
                            FROM          dbo.ReturnToVender
                            WHERE      (Status > 0) and (ReturnToVenderDate>=@FromDate and ReturnToVenderDate<@ToDate)
                            GROUP BY SupplierID) ReturnVs ON ReturnVs.SupplierID = dbo.Supplier.SupplierID 
where dbo.Supplier.Status>0
GO