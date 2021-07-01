SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOrderEntries]
(@ID uniqueidentifier,
@MySort varchar(50))
as

If @MySort = ''
Set @MySort = 'SortOrder'
IF @MySort = 'Sort'
Set @MySort = 'SortOrder'
Declare @MySelect varchar(4000)


Set @MySelect = 	'SELECT     dbo.PurchaseOrderEntryView.*
	FROM       dbo.PurchaseOrderEntryView
	WHERE     (Status > - 1) and (PurchaseOrderNo=''' +CONVERT(varchar(100), @ID) +''') Order By '


Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO