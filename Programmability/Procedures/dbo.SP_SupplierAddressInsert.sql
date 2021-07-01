SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierAddressInsert]
(@AddressID uniqueidentifier,
@Name nvarchar(50),
@Line1 nvarchar(50),
@Line2 nvarchar(50),
@Quarter nvarchar(20),
@City nvarchar(20),
@State nvarchar(10),
@Zip nvarchar(15),
@Country nvarchar(15),
@AddressType int,
@CCRT nvarchar (20),
@PhoneNumber1 nvarchar (20),
@Ext1 nvarchar (20),
@PhoneNumber2 nvarchar (20),
@Ext2 nvarchar (20),
@PhoneNumber3 nvarchar (20)=null,
@Ext3 nvarchar (20),
@cellphone nvarchar (20),
@SortOrder smallint,
@Status smallint,
@ModifierID nvarchar(50))
AS INSERT INTO dbo.SupplierAddresses
                      (AddressID, Name, Line1, Line2, Quarter, City, State, Zip, Country, AddressType, CCRT, PhoneNumber1, Ext1, PhoneNumber2, Ext2, PhoneNumber3, Ext3, cellphone,SortOrder, Status, 
                      DateModified, UserModified, UserCreated)
VALUES     (@AddressID, dbo.CheckString(@Name), @Line1, @Line2, @Quarter, dbo.CheckString(@City), @State, dbo.CheckString(@Zip), @Country, @AddressType, @CCRT, @PhoneNumber1, @Ext1, 
                      @PhoneNumber2, @Ext2, @PhoneNumber3, @Ext3,@cellphone,@SortOrder, 1, dbo.GetLocalDATE(), @ModifierID, @ModifierID)
GO