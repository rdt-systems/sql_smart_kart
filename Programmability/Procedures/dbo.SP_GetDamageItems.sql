SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetDamageItems]
(@Filter nvarchar(4000))

AS

declare @MySelect nvarchar(4000)

set @MySelect= 'SELECT     dbo.DamageItemView.*
		FROM  dbo.DamageItemView
        WHERE     (Status > - 1) '
Execute (@MySelect + @Filter )
GO