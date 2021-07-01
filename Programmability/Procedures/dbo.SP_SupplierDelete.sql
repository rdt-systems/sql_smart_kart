SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierDelete]
(@SupplierID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Supplier
SET              Status = -1, DateModified = dbo.GetLocalDATE(), 
                    UserModified = @ModifierID
WHERE	    SupplierID = @SupplierID
GO