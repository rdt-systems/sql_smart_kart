SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SetUpValuesInsert]
(@OptionID int,
 @CategoryID smallint,
 @OptionName varchar(50),
 @StoreID uniqueidentifier,
 @OptionValue varchar(4000),
 @OptionValueHe varchar(4000),
 @Status smallint,
 @ModifierID uniqueidentifier)


as insert into SetUpValues 
(OptionID,CategoryID,OptionName,StoreID,OptionValue,OptionValueHe,Status,DateCreated,UserCreated,DateModified,UserModified)
values
(@OptionID,@CategoryID,@OptionName,@StoreID,@OptionValue,@OptionValueHe,1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO