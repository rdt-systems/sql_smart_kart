SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetComputersView]
(@DeletedOnly bit =0,
@DateModified datetime=null, @refreshTime  datetime output)

AS

if @DateModified is null 

begin
	select * from ComputersView
	Where Status>-1

	set @refreshTime = dbo.GetLocalDATE()
	return
end


if  @DeletedOnly=0 
  	select * from ComputersView
	WHERE     (DateModified>@DateModified )
	 AND (Status > - 1)
else

   	select * from ComputersView
	WHERE     (DateModified>@DateModified )
                AND  (Status = - 1) 
set @refreshTime = dbo.GetLocalDATE()
GO