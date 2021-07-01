SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetRepresentsView]
(@StoreID uniqueidentifier=null,
@DeletedOnly bit =0,
@DateModified datetime=null)
AS


if @DateModified is null 
begin
	if @StoreID is null
		
		select *
		from represents
   		WHERE     (Status > - 1) 
	else

   		select *
		from represents
   		WHERE     (Status > - 1) and (StoreID=@StoreID)

 return
end


if  @DeletedOnly=0 
	select *
	from represents
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)and (StoreID=@StoreID)

else
	select *
	from represents
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)and (StoreID=@StoreID)
GO