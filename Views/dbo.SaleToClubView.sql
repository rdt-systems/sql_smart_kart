SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SaleToClubView]
AS
SELECT     SaleToClubID, SaleID, ClubID, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.SaleToClub
GO