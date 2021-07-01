SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[BottomButtonsView]
AS
SELECT *  FROM [dbo].[BottomButtons] WHERE Status > 0
GO