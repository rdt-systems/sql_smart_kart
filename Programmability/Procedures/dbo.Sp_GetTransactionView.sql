SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_GetTransactionView](
@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null)

AS
if @DateModified is null 
begin
	 SELECT     dbo.TransactionView.*
	FROM         dbo.TransactionView
	WHERE     (Status > - 1) AND (StoreID = @StoreID)

 return
end


if  @DeletedOnly=0 
        SELECT     dbo.TransactionView.*
	FROM         dbo.TransactionView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)AND (StoreID = @StoreID)

else
	 SELECT     dbo.TransactionView.*
	FROM         dbo.TransactionView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)AND (StoreID = @StoreID)
GO