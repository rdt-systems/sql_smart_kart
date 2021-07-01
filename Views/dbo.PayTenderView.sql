SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PayTenderView]
AS
SELECT     dbo.PayTender.*
FROM         dbo.PayTender
GO