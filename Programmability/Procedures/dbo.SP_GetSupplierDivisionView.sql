SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSupplierDivisionView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)
as

if @DateModified is null 
begin
	SELECT     dbo.SupplierDivisionView.*
        FROM         dbo.SupplierDivisionView
	WHERE     (Status > - 1)
set @refreshTime = dbo.GetLocalDATE()
   return
end

if  @DeletedOnly=0 
	SELECT     dbo.SupplierDivisionView.*
        FROM         dbo.SupplierDivisionView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.SupplierDivisionView.*
        FROM         dbo.SupplierDivisionView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO