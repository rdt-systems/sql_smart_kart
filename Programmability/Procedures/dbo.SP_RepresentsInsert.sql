SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RepresentsInsert]
(
@RepID uniqueidentifier,
@StoreID uniqueidentifier,
@RepName nvarchar(50),
@Note nvarchar(200),
@Status smallint,
@ModifierID uniqueidentifier)
  AS
	INSERT INTO dbo.Represents
	(RepID,StoreID,RepName,Note,Status,UserModified)
	VALUES
	(@RepID ,@StoreID ,dbo.CheckString(@RepName) ,@Note ,@Status,@ModifierID)
GO