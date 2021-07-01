SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetWorkOrderEntries]
(@WorkOrderID uniqueidentifier)
as

	SELECT     dbo.WorkOrderEntryView.*
	FROM       dbo.WorkOrderEntryView
	WHERE     (Status > - 1) and (WorkOrderID=@WorkOrderID)
GO