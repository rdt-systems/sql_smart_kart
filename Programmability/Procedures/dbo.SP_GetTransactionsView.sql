SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransactionsView]
(@Filter nvarchar(4000),
@DeletedOnly bit =0,
@DateModified datetime=null, 
@refreshTime  datetime output)

as

declare @MySelect nvarchar(4000)

if @DateModified is null 
begin
set @MySelect= 'SELECT   dbo.TransactionWithPaidView.*
		FROM dbo.TransactionWithPaidView
		WHERE  1=1 '
Execute (@MySelect + @Filter )
set @refreshTime = dbo.GetLocalDATE()
 return
end

if  @DeletedOnly=0 
        set @MySelect= 'SELECT   dbo.TransactionWithPaidView.*
		FROM dbo.TransactionWithPaidView
		WHERE   (Status > - 1)  AND convert(varchar,DateModified,121)>'''+ convert(varchar,@DateModified,121)+''' '

else
begin
SELECT   dbo.TransactionWithPaidView.*
		FROM dbo.TransactionWithPaidView
		WHERE (Status = - 1) And  convert(varchar,DateModified,121)> convert(varchar,@DateModified,121)
		return
end
       
Execute (@MySelect + @Filter )

set @refreshTime = dbo.GetLocalDATE()
GO