SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create VIEW [dbo].[SaleToTenderView]
AS
SELECT     SaleToTenderID, SaleID, TenderID, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.SaleToTender
GO