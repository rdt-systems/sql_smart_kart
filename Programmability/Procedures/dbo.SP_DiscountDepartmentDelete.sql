SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountDepartmentDelete]
(@DiscountDepartmentID uniqueidentifier
,@ModifierID uniqueidentifier)
AS
 DELETE FROM DiscountDepartment WHERE [DiscountDepartmentID] = @DiscountDepartmentID
GO