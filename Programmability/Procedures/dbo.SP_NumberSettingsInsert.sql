SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_NumberSettingsInsert] 
(
@TableName varchar(50),
@SeqNumber bigint,
@StoreSymbol varchar(50),
@StartNum bigint,
@StoreID uniqueidentifier,
@TableNameHe varchar(50),
@Desc varchar(50),
@ModifierID uniqueidentifier)
AS
insert into NumberSettings
( TableName,SeqNumber,StartNum,	StoreSymbol,StoreID,TableNameHe,[Desc])
Values ( @TableName,0,0,@StoreSymbol,@StoreID,@TableNameHe,@TableName)
GO