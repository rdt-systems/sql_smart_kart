SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_UserQuery]
(
@DateModified datetime=null
)
AS 

SELECT [UserQuery].*  FROM [UserQuery]  WHERE (DateModified >@DateModified )  AND  [UserQuery].Status>0
GO