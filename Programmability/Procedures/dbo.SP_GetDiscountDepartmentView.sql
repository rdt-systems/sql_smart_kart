SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDiscountDepartmentView]
(@DiscountID uniqueidentifier = NULL)
AS
  SELECT * FROM DiscountDepartmentView Where (DiscountID = @DiscountID OR @DiscountID IS NULL) and Status > -1
GO