SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactDelete]
(@ContactNameID uniqueidentifier,
@ModifierID uniqueidentifier)

AS
UPDATE dbo.CustomerContact
SET	Status = -1, DateModified = dbo.GetLocalDATE()
WHERE CustomerContactID = @ContactNameID


UPDATE dbo.SupplierContact
SET	Status = -1, DateModified = dbo.GetLocalDATE()
WHERE ContactNo = @ContactNameID
GO