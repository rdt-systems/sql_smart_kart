SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Discounts]
(
@DateModified datetime=null
)
AS 

SELECT [Discounts].*  FROM [Discounts] WHERE (DateModified > @DateModified) AND Status>0
GO