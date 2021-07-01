SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSpecialInsert]
           (@ItemStoreID uniqueidentifier
           ,@SaleType int
           ,@SalePrice money
           ,@SaleStartDate datetime
           ,@SaleEndDate datetime
           ,@SaleMin int
           ,@SaleMax int
           ,@MinForSale money
           ,@SpecialBuy int
           ,@SpecialPrice money
           ,@AssignDate bit
           ,@Status smallint=1
		   ,@ModifierID uniqueidentifier)

AS
INSERT INTO [dbo].[ItemSpecial]
           ([ItemStoreID]
           ,[SaleType]
           ,[SalePrice]
           ,[SaleStartDate]
           ,[SaleEndDate]
           ,[SaleMin]
           ,[SaleMax]
           ,[MinForSale]
           ,[SpecialBuy]
           ,[SpecialPrice]
           ,[AssignDate]
           ,[Status]
           ,[DateCreated]
           ,[DateModified] 
           ,[UserCreated])
     VALUES
           (@ItemStoreID
           ,@SaleType
           ,@SalePrice
           ,@SaleStartDate
           ,@SaleEndDate
           ,@SaleMin
           ,@SaleMax
           ,@MinForSale
           ,@SpecialBuy
           ,@SpecialPrice
           ,@AssignDate
           ,@Status
           ,dbo.GetLocalDATE()
           ,dbo.GetLocalDATE()    
           ,@ModifierID
           )
GO