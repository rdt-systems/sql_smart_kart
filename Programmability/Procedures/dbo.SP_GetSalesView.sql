SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSalesView]
(@DeletedOnly bit =0,
@DateModified datetime=null,
@SaleID uniqueidentifier=null, 
@refreshTime  datetime output)
AS

if @SaleID is not null 
begin
  select * 
  from dbo.SalesView
  WHERE (Status > - 1) and (SaleID=@SaleID)
set @refreshTime = dbo.GetLocalDATE()
return
end

if @DateModified is null 
begin
  select * 
  from dbo.SalesView
  WHERE     (Status > - 1) 
set @refreshTime = dbo.GetLocalDATE()
return
end

if  @DeletedOnly=0 
	SELECT     dbo.SalesView.*
	FROM       dbo.SalesView
	WHERE     (DateModified>@DateModified) and (Status > - 1)

else
	SELECT     dbo.SalesView.*
	FROM       dbo.SalesView
	WHERE     (DateModified>@DateModified) AND (Status = - 1)
set @refreshTime = dbo.GetLocalDATE()
GO