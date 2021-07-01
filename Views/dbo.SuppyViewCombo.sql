SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SuppyViewCombo]
AS
SELECT     Name, SupplierID
FROM         dbo.Supplier
GO