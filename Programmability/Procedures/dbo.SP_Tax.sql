SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Tax]
(
@DateModified datetime=null
)
AS 
SELECT [Tax].*  FROM [Tax]  WHERE (DateModified >@DateModified) AND Status>0
GO