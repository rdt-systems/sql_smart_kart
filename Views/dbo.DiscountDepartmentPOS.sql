SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DiscountDepartmentPOS]
AS
SELECT        DepartmentID, DiscountID, DateModified, DiscountDepartmentID, Status
FROM            dbo.DiscountDepartment
WHERE        (Status > 0)
GO