SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
Create VIEW [dbo].[AlterationsStatusView]

AS

SELECT DISTINCT AlterationID, CASE WHEN Status = 3 THEN Date ELSE NULL END AS ReadyDate, CASE WHEN Status = 4 THEN Date ELSE NULL END AS ClosedDate
FROM            AlterationsStatus


GO