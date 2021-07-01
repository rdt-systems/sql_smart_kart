CREATE TABLE [dbo].[Discounts] (
  [DiscountID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [PercentsDiscount] [money] NULL,
  [AmountDiscount] [money] NULL,
  [MinTotalSale] [money] NULL,
  [UPCDiscount] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ClearBalance] [bit] NULL,
  [ClearDays] [int] NULL,
  [ReqPaswrd] [bit] NULL,
  [DiscountForCC] [money] NULL,
  [DiscountItems] [bit] NULL,
  [PercentsDiscountWithCC] [money] NULL,
  [SalesItem] [bit] NULL,
  [MinTotalSale2] [money] NULL,
  [PercentsDiscount2] [money] NULL,
  [AmountDiscount2] [money] NULL,
  [MinTotalSale3] [money] NULL,
  [PercentsDiscount3] [money] NULL,
  [AmountDiscount3] [money] NULL,
  [DiscountType] [int] NULL,
  [IncludeGiftCard] [bit] NULL,
  [DiscountItem] [int] NULL,
  [DiscountDepartment] [int] NULL,
  [DiscountBrand] [int] NULL,
  [DiscountStore] [int] NULL,
  [BogoQty] [int] NULL,
  [BogoAmount] [decimal] NULL,
  [BogoType] [int] NULL,
  [SelectedItem] [bit] NULL,
  [MaxAmount] [money] NULL,
  [AutoAssign] [bit] NULL,
  [MinQty] [int] NULL,
  [DiscountInt] [int] IDENTITY,
  CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED ([DiscountID])
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ChangeDiscounts] on [dbo].[Discounts]
for  update , insert , delete
as

 declare @DiscountID nvarchar(500) ,@ModifierID uniqueidentifier
 select  @DiscountID =inserted.DiscountID,@ModifierID=UserModified
 from inserted 


 
 declare @DiscountIDDelete nvarchar(500) ,@ModifierIDDelete uniqueidentifier
 select  @DiscountIDDelete =deleted.DiscountID,@ModifierIDDelete=deleted.UserModified
 from deleted 

if (select count(0) from inserted ) >0 and   (select count(0) from deleted ) <=0 
begin 
 exec SP_SaveRecentActivity 9,'Discounts',1,@DiscountID,1,'DiscountID',@ModifierID,null
end 


else if Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
begin 
exec SP_SaveRecentActivity 11,'Discounts',1,@DiscountID,1,'DiscountID',@ModifierID,null
end 

else if
 (select count(0) from inserted ) >0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 10,'Discounts',1,@DiscountID,1,'DiscountID',@ModifierID,null
end 


else if
 (select count(0) from inserted ) =0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 12,'Discounts',1,@DiscountIDDelete,1,'DiscountID',@ModifierIDDelete,null
end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDiscounts] on [dbo].[Discounts]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DiscountID, 'Discounts' , Status, dbo.GetLocalDATE() , 1,'DiscountID' FROM      inserted
  end
GO