SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ManufacturersView]
AS
SELECT     ManufacturerID, ManufacturerName, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Manufacturers
GO