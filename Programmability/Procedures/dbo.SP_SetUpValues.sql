SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_SetUpValues]
(
@DateModified datetime=null,
@StoreID uniqueidentifier
)
AS 

SELECT     * FROM  SetUpValues WHERE ((CategoryID = 6)OR (Optionid = 47) OR(OPTIONID=433)OR (OPTIONID=428) OR (OptionID IN (429,430,431,432)) OR (OPTIONID=146) OR (OPTIONID>800) ) 
AND (StoreID =@StoreID)  AND (DateModified  >@DateModified) AND Status>0
GO