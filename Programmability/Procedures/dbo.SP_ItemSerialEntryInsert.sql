SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_ItemSerialEntryInsert]
           (@ItemSerialEntryID uniqueidentifier
           ,@TransEntryID uniqueidentifier
           ,@SerialNumber1 nvarchar(50)
           ,@SerialNumber2 nvarchar(50)
           ,@SerialNumber3 nvarchar(50)
           ,@SerialNumber4 nvarchar(50)
           ,@SerialNumber5 nvarchar(50))

AS
INSERT INTO [ItemSerialEntry]
           ([ItemSerialEntryID]
           ,[TransEntryID]
           ,[SerialNumber1]
           ,[SerialNumber2]
           ,[SerialNumber3]
           ,[SerialNumber4]
           ,[SerialNumber5])
     VALUES
           (@ItemSerialEntryID
           ,@TransEntryID
           ,@SerialNumber1
           ,@SerialNumber2
           ,@SerialNumber3
           ,@SerialNumber4
           ,@SerialNumber5)
GO