SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierNotesView]
AS
SELECT     dbo.SupplierNotes.*
FROM         dbo.SupplierNotes
GO