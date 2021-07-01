SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE   VIEW [dbo].[PayToBillView]
AS
SELECT     dbo.PayToBill.*
FROM         dbo.PayToBill
GO