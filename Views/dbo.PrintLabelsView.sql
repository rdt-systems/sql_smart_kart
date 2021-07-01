SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[PrintLabelsView]
AS
SELECT     dbo.PrintLabels.*
FROM         dbo.PrintLabels
GO