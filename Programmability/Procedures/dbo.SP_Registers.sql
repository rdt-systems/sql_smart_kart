SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Registers]
(
@DateModified datetime=null
)
AS 

SELECT [Registers].*  FROM [Registers] WHERE (DateModified > @DateModified) AND Status>0
GO