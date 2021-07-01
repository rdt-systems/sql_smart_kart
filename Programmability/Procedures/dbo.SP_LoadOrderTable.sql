SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


---Sp Created to show 

CREATE PROCEDURE [dbo].[SP_LoadOrderTable]  
AS
 BEGIN
        SELECT	OrderTypeID,[Name]	FROM OrderType 
 END
GO