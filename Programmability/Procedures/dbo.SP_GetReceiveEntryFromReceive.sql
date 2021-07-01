SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveEntryFromReceive]
(@ID uniqueidentifier)
As 
SELECT     dbo.ReceiveEntry.*
FROM         dbo.ReceiveEntry
where ReceiveNo=@ID and status>0
GO