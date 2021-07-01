SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetUnApplyByReturn]
(@ID uniqueidentifier)

as

SELECT  isnull(
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
WHERE     (ReturnToVenderID=@ID)
GO