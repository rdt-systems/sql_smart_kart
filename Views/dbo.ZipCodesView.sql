SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ZipCodesView]
AS
SELECT     ZipCode, City, StateID
FROM         dbo.ZipCodes
GO