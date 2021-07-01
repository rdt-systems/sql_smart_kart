SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create VIEW [dbo].[SaleToStoreView]
AS
SELECT     SaleToStoreID, SaleID, StoreID, ActivationStatus, Status, DateCreated, UserCreated, DateModified, UserModifed
FROM         dbo.SaleToStore
GO