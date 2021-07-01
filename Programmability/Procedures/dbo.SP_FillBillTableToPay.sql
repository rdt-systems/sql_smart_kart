SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_FillBillTableToPay](@ID uniqueidentifier)
AS
SELECT    dbo.BillView.*
FROM         dbo.BillView
WHERE     (Status >0) AND (SupplierID = @ID) AND (ISNULL(Amount - AmountPay, 0) > 0)
ORDER BY BillDate DESC
GO