SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DiscountDepartmentPOS]
(
@DateModified datetime=null
)
AS 
SELECT [DiscountDepartmentPOS].*  FROM [DiscountDepartmentPOS]  WHERE (DateModified >@DateModified) AND Status>0
GO