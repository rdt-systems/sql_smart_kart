SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE view [dbo].[ItemsForUpdateParent]
as
select ItemID,LinkNo,StoreNo,OnHand,OnOrder,OnWorkOrder,
	MTDQty,PTDQty,YTDQty,MTDDollar,PTDDollar,YTDDollar,
	MTDReturnQty,PTDReturnQty,YTDReturnQty, ItemStore.Status
from 	ItemMain inner join
	ItemStore on ItemID=ItemNo
where 	(LinkNo is not null) and (ItemStore.Status>-1)
GO