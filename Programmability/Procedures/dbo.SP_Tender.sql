SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Tender]
(
@DateModified datetime=null
)
AS 

SELECT [Tender].*  FROM [Tender]  WHERE (DateModified > @DateModified) AND Status>0
GO