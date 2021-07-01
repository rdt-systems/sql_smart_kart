SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetReturnToVenderEntry]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReturnToVender.ReturnToVenderDate,
		           dbo.ReturnToVenderEntry.Qty,
			   dbo.ReturnToVender.ReturnToVenderID
		FROM       dbo.ReturnToVenderEntry 
			   INNER JOIN
                           dbo.ReturnToVender ON dbo.ReturnToVenderEntry.ReturnToVenderID = dbo.ReturnToVender.ReturnToVenderID
		WHERE  '
Execute (@MySelect + @Filter )
GO