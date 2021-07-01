SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetItems]
(@Filter nvarchar(4000) )
as
declare @MySelect nvarchar(4000)

	set @MySelect= 'select *
	                                 from ItemMainandStoreView
					where 1=1'-- and itemno=''0094E9C2-A346-44DB-93BF-0000483CC1B9'''
	Execute (@MySelect + @Filter )
GO