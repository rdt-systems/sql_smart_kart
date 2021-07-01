SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerAddressesInsert]
(@CustomerAddressID uniqueidentifier,
@CustomerID uniqueidentifier,
@Name nvarchar(50),
@Street1 nvarchar(50),
@Street2 nvarchar(50),
@City nvarchar(20),
@State nvarchar(100),
@Zip nvarchar(15),
@Country nvarchar(50),
@AddressType int,
@CCRT nvarchar (20),
@PhoneNumber1  nvarchar (20),
@Ext1  nvarchar (20),
@PhoneNumber2  nvarchar (20),
@Ext2  nvarchar (20),
@SortOrder smallint,
@IsTextable bit = null ,
@UseSMS bit = null,
@Status smallint,
@ModifierID uniqueidentifier)

AS

INSERT INTO    dbo.CustomerAddresses
	(CustomerAddressID,CustomerID,[Name], 
	 Street1,Street2,City,State,Zip,Country,AddressType,CCRT,
	 PhoneNumber1,Ext1,PhoneNumber2,Ext2,SortOrder,IsTextable,UseSMS,
	 Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES	(@CustomerAddressID,@CustomerID,dbo.CheckString(@Name),
	dbo.CheckString( @Street1),dbo.CheckString(@Street2), dbo.CheckString(@City), @State,
dbo.CheckString(@Zip),@Country,@AddressType, @CCRT,
	 @PhoneNumber1,  @Ext1,     @PhoneNumber2, @Ext2, @SortOrder,@IsTextable,@UseSMS,
	 isnull(@Status,1),dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO