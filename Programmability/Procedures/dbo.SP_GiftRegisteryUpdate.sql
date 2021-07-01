SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftRegisteryUpdate]
           (@GiftRegisteryID uniqueidentifier,
           @CustomerID uniqueidentifier,
           @CustomerID1 uniqueidentifier,
           @EventDate datetime,
           @EventType nvarchar(20),
           @DateCreated datetime,
           @DateModified datetime,
           @Status int,
           @GiftRegisteryNo nvarchar(50))
AS 

UPDATE [GiftRegistery]
   SET [CustomerID] = @CustomerID
      ,[CustomerID1] = @CustomerID1
      ,[EventDate] = @EventDate
      ,[EventType] = @EventType
      ,[DateCreated] = @DateCreated
      ,[DateModified] = @DateModified
      ,[Status] = @Status
      ,[GiftRegisteryNo] = @GiftRegisteryNo
 WHERE [GiftRegisteryID] = @GiftRegisteryID
GO