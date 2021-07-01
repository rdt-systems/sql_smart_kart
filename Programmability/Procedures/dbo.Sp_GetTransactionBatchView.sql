SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_GetTransactionBatchView](@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null)
AS 
if @DateModified is null 
begin
	SELECT     dbo.TransactionBatchView.*
	FROM         dbo.TransactionBatchView
	WHERE     (Status > - 1) AND (StoreID = @StoreID)
 return
end


if  @DeletedOnly=0 
	SELECT     dbo.TransactionBatchView.*
	FROM         dbo.TransactionBatchView
	WHERE     (DateModified>@DateModified) 
	
	 AND (Status > - 1)

else
	SELECT     dbo.TransactionBatchView.*
	FROM         dbo.TransactionBatchView
	WHERE     (DateModified>@DateModified) 
	
                AND  (Status = - 1)
GO