SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetCustomerBalance]
(@CustomerID uniqueidentifier,
@ToDate Datetime=null
)
as

if @ToDate is null
begin

	select balancedoe
	from customer
	where CustomerID=@CustomerID

end
else

begin

	select top 1 currbalance
	from [transaction]
	where CustomerID=@CustomerID and endSaleTime<=@ToDate
	order by endSaleTime desc

end
GO