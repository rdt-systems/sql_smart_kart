SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[StateView]
AS
SELECT     StateCode, StateName, StateSort
FROM         dbo.State
GO