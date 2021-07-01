SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetAlteration](
@AlterationNo nvarchar(20))
as
if @AlterationNo = ''
	Begin
		SELECT * FROM AlterationsView where AlterationNo = @AlterationNo 
	End
else
Begin
	SELECT * FROM AlterationsView
End
GO