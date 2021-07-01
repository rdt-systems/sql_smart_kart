SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemsLookupValuesView]
AS
SELECT     ValueType, ValueID, ValueName, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.ItemsLookupValues
GO