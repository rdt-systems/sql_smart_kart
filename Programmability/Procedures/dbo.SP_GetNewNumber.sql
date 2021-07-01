SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetNewNumber]
@StoreID uniqueidentifier=null,
@TableName nvarchar(30),
@DefualtNumber Int

AS
if @StoreID is null
BEGIN
	IF(SELECT  TOP(1)   dbo.NumberSettings.TableName
	FROM         dbo.NumberSettings
    WHERE TableName = @TableName) IS NULL 
		INSERT INTO NumberSettings(TableName,SeqNumber,StartNum,[Desc],StoreiD)
		VALUES(@TableName,@DefualtNumber,@DefualtNumber,@TableName,NULL)
	ELSE
      UPDATE NumberSettings SET SeqNumber = SeqNumber+1 WHERE TableName = @TableName  
    SELECT TOP(1) SeqNumber AS NewNumber FROM NumberSettings WHERE TableName = @TableName    
END
ELSE BEGIN
	IF(SELECT     dbo.NumberSettings.TableName
	FROM         dbo.NumberSettings
    WHERE TableName = @TableName AND StoreID=@StoreID) IS NULL 
		INSERT INTO NumberSettings(TableName,SeqNumber,StartNum,[Desc],StoreiD)
		VALUES(@TableName,1,@DefualtNumber,@TableName,@StoreID)
	ELSE
      UPDATE NumberSettings SET SeqNumber = SeqNumber+1 WHERE TableName = @TableName  AND StoreID=@StoreID  
    SELECT TOP(1) SeqNumber AS NewNumber FROM NumberSettings WHERE TableName = @TableName AND StoreID=@StoreID 
END
GO