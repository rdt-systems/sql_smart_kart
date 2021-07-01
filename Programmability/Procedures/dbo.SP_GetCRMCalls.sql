SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE procedure [dbo].[SP_GetCRMCalls]
(@Filter nvarchar(4000),
 @Records nvarchar(7)='900000')
as

declare  @MySelect nvarchar(4000)

set @MySelect= 'select Top('+@Records+') dbo.CRMCallsView.*
		FROM dbo.CRMCallsView
		WHERE Status > -1  '
declare @MyOrder nvarchar(100)
set @MyOrder =' Order By DateCreated Desc'
Execute (@MySelect + @Filter +@MyOrder)
GO