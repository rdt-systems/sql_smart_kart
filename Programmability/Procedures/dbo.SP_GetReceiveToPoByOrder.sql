SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveToPoByOrder]
@ID uniqueidentifier
as
Select * 
from dbo.ReceiveToPO
where POID=@ID And Status>0
GO