SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransReturenInsert]
(@SaleTransEntryID uniqueidentifier,
 @Qty float,
 @ReturenTransID uniqueidentifier)
 AS
 declare @D As datetime
 SET @D =dbo.GetLocalDATE()
 declare @ID int
 SET @ID = (select Isnull(Max(ReturenID),0)+1 from TransReturen) 
   INSERT INTO [dbo].[TransReturen]
           ([ReturenID]
           ,[SaleTransEntryID]
           ,[Qty]
           ,[ReturenTransID]
           ,[DateCreated]
           ,[Status])
     VALUES
           (@ID
           ,@SaleTransEntryID
           ,@Qty 
           ,@ReturenTransID
           ,@D
           ,1)
GO