SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetSupplierByID]
(
	@SupplierID uniqueidentifier)
as
BEGIN
 SELECT * FROM SupplierView WHERE SupplierID = @SupplierID
END
GO