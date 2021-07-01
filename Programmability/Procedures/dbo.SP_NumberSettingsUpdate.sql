SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_NumberSettingsUpdate] 
(
@TableName varchar(50),
@NewNumber bigint,
@NewSymbol varchar(50),
@StartNum bigint,
@StoreID uniqueidentifier=null)
AS
if @StoreID is null
UPDATE NumberSettings
SET SeqNumber=@NewNumber,
	StartNum=@StartNum,
	StoreSymbol=@NewSymbol
WHERE TableName=@TableName
else
UPDATE NumberSettings
SET SeqNumber=@NewNumber,
	StartNum=@StartNum,
	StoreSymbol=@NewSymbol
WHERE TableName=@TableName And StoreID=@StoreID
GO