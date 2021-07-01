SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- ALTER date: <6/23/2011>
-- Description:	<Fill all Price changes>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SpecialPriceInsert] 
	@ItemStoreID uniqueidentifier,
	@Price money,
	@SaleType int,
	@AssignDate Int,
    @FromDate DateTime,
    @ToDate DateTime,
    @SpPrice nvarchar(50),
    @UserID uniqueidentifier
AS
BEGIN
  Declare @SaleDate nvarchar(50)
  if @AssignDate =1
	  SET @SaleDate = dbo.FormatDateTime(@FromDate,'MM/DD/YY')+ ' - '+dbo.FormatDateTime(@ToDate,'MM/DD/YY')
  ELSE
	  SET @SaleDate = null
  INSERT INTO [dbo].[PriceChangeHistory]
           ([PriceChangeHistoryID]
           ,[ItemStoreID]
           ,[PriceLevel]
           ,[OldPrice]
           ,[NewPrice]
           ,[UserID]
           ,[SaleType]
           ,[SP_Price]
           ,[SaleDate]
           ,[Date]
           ,[DateCreated]
           ,[DateModified])
     VALUES
           (NEWID()
           ,@ItemStoreID
           ,'Sale Price'
           ,Null
           ,@Price
           ,@UserID 
           ,(CASE WHEN @SaleType=1 THEN 'Ragulare' WHEN @SaleType=2 THEN 'Break Down' WHEN @SaleType=2 THEN 'Mix & Match' WHEN @SaleType=2 THEN 'Combind' ELSE 'NONE' END) 
           ,@SpPrice 
           ,@SaleDate
           ,dbo.GetLocalDATE()
           ,dbo.GetLocalDATE()
           ,dbo.GetLocalDATE())
END
GO