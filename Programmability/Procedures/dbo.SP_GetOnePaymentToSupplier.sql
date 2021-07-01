SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOnePaymentToSupplier](@ID uniqueidentifier)
AS
SELECT     dbo.SupplierTenderEntryView.*
FROM         dbo.SupplierTenderEntryView 
WHERE     (dbo.SupplierTenderEntryView.SuppTenderEntryID = @ID)
GO