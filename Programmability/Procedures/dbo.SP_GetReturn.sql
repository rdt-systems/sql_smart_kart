SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReturn]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReturnToVenderView.*,
		isnull(
		Total-isnull(
			(
				select Sum(Amount)
			 	from dbo.PayToBill
			 	where SuppTenderID=dbo.ReturnToVenderView.ReturnToVenderID and Status>0
			)
		,0)
		,0)
		 as NotApplyAmount
                FROM       dbo.ReturnToVenderView
	        WHERE     '
Execute (@MySelect + @Filter )
GO