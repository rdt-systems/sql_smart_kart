SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftRegisteryInsert]
           (@GiftRegisteryID uniqueidentifier,
           @CustomerID uniqueidentifier,
           @CustomerID1 uniqueidentifier,
           @EventDate datetime,
           @EventType nvarchar(20),
           @EventName nvarchar(20),
           @Status int,
           @GiftRegisteryNo nvarchar(50))
AS 
   INSERT INTO [GiftRegistery]
           ([GiftRegisteryID]
           ,[CustomerID]
           ,[CustomerID1]
           ,[EventDate]
           ,[EventType]
           ,[EventName]
           ,[DateCreated]
           ,[Status]
           ,[GiftRegisteryNo])
     VALUES
           (@GiftRegisteryID ,
           @CustomerID ,
           @CustomerID1 ,
           @EventDate ,
           @EventType ,
           @EventName ,
           dbo.GetLocalDATE() ,
           @Status ,
           @GiftRegisteryNo )
GO