SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPaymentsByBill](@ID uniqueidentifier)
AS

CREATE TABLE #CurrSystemValues(
	[SystemTableNo] [bigint] NOT NULL,
	[SystemValueNo] [int] NOT NULL,
	[SystemValueName] [nvarchar](50) COLLATE HEBREW_CI_AS)

INSERT INTO #CurrSystemValues(systemtableno,systemvalueno,SystemValueName)
Select SystemTableNo,SystemValueNo,SystemValueName  as SystemValueName
from SystemValues

--------------------------------

SELECT     dbo.SupplierTenderEntryView.SuppTenderNo as No , dbo.SupplierTenderEntryView.TenderDate as Date, dbo.PayToBillView.Amount, 
                      dbo.SupplierTenderEntryView.SuppTenderEntryID as ID ,   3 AS Type
into #Temp1
FROM         dbo.SupplierTenderEntryView INNER JOIN
                      dbo.PayToBillView ON dbo.SupplierTenderEntryView.SuppTenderEntryID = dbo.PayToBillView.SuppTenderID INNER JOIN
                      dbo.BillView ON dbo.PayToBillView.BillID = dbo.BillView.BillID 
WHERE     (dbo.BillView.BillID =  @ID and dbo.PayToBillView.Status>0 and dbo.SupplierTenderEntryView.Status>0)

union

SELECT     dbo.ReturnToVender.ReturnToVenderNo AS No, dbo.ReturnToVender.ReturnToVenderDate AS Date, dbo.PayToBill.Amount, 
                      dbo.ReturnToVender.ReturnToVenderID AS ID, 2 AS Type
FROM         dbo.Bill INNER JOIN
                      dbo.PayToBill ON dbo.Bill.BillID = dbo.PayToBill.BillID INNER JOIN
                      dbo.ReturnToVender ON dbo.PayToBill.SuppTenderID = dbo.ReturnToVender.ReturnToVenderID
WHERE     (dbo.Bill.BillID =  @ID and dbo.PayToBill.Status>0)


select No,Date,Amount,ID,SystemValueName as Type
from #temp1 Inner Join 
     #CurrSystemValues On SystemValueNo=Type And SystemTableNo=34

Drop tAble #CurrSystemValues
Drop tAble #temp1
GO