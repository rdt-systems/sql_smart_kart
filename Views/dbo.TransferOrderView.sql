SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransferOrderView]
AS
SELECT     TransferOrderID, TransferOrderNo, FromStoreID, ToStoreID, TransferOrderDate, Note, PersonID, Status, DateCreated, UserCreated, DateModified, 
                      UserModified, OrderStatus
FROM         dbo.TransferOrder
GO