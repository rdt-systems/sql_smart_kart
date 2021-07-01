SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetCustomerTasksFiltered]
(@Filter nvarchar(4000))
as

declare  @MySelect nvarchar(4000)

set @MySelect= 'select dbo.CustomerTasksView.*
		FROM dbo.CustomerTasksView
		WHERE Status > -1  '
Execute (@MySelect + @Filter )
GO