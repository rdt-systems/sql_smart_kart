SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_BKGetMovements] as
select * from BookkeepingCustomerMovements 
union all
select * from BookkeepingSupplierMovements 
order by MovementType
GO