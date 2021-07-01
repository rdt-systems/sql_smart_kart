SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelsDelete]
(@PrintLabelsID uniqueidentifier,
@ModifierID uniqueidentifier)
AS 

DELETE
FROM    dbo.PrintLabels
WHERE  PrintLabelsID = @PrintLabelsID


--UPDATE    dbo.PrintLabels
--SET              Status = -1, DateModified = dbo.GetLocalDATE()
--WHERE  PrintLabelsID = @PrintLabelsID
GO