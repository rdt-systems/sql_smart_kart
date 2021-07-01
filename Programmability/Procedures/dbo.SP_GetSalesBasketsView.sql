SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSalesBasketsView]
(@DeletedOnly bit =0,
@DateModified datetime=null, 
@SaleID uniqueidentifier=null,
@refreshTime  datetime output)
AS

if @SaleID is not null
begin
	select * 
	from dbo.SalesBasketsView
	WHERE     (Status > - 1) and (SaleID=@SaleID)
set @refreshTime = dbo.GetLocalDATE()
return
end

if @DateModified is null 
begin
  SELECT     dbo.SalesBasketsView.*
  FROM       dbo.SalesBasketsView
  WHERE     (Status > - 1) 
set @refreshTime = dbo.GetLocalDATE()
return
end

if  @DeletedOnly=0 
	SELECT     dbo.SalesBasketsView.*
	FROM       dbo.SalesBasketsView
	WHERE     (DateModified>@DateModified) and (Status > - 1)
else
	SELECT     dbo.SalesBasketsView.*
	FROM       dbo.SalesBasketsView
	WHERE     (DateModified>@DateModified) AND (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO