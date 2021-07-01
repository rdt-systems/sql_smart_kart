SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_BottomButtonsView]
(
@DateModified datetime=null
)
AS 
SELECT [BottomButtonsView].*  FROM [BottomButtonsView]  WHERE (DateModified >@DateModified) AND Status>0
GO