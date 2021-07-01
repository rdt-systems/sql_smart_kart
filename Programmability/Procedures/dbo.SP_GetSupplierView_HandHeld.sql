SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetSupplierView_HandHeld]
(@ShowInActive bit = 1,
@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
AS 


if @DateModified is null 

begin
SELECT     dbo.SupplierView.SupplierID, dbo.SupplierView.SupplierNo, dbo.SupplierView.[Name]
FROM         dbo.SupplierView
WHERE     (Status >-1)
set @refreshTime = dbo.GetLocalDATE()
  return
end


if  @DeletedOnly=0 
          SELECT     dbo.SupplierView.SupplierID, dbo.SupplierView.SupplierNo, dbo.SupplierView.[Name]
          FROM         dbo.SupplierView
          WHERE     (Status >- 1) and  (DateModified>@DateModified) 

else
	  SELECT     dbo.SupplierView.SupplierID, dbo.SupplierView.SupplierNo, dbo.SupplierView.[Name]
          FROM         dbo.SupplierView
	  WHERE     (DateModified>@DateModified) 
	             AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO