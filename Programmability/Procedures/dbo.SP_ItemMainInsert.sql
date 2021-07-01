SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemMainInsert](@ItemID uniqueidentifier,
@Name nvarchar(4000),
@Description nvarchar(4000)= NULL,
@ModalNumber nvarchar(50),
@Quantization decimal= NULL,
@Unit uniqueidentifier= NULL,
@ParentID uniqueidentifier= NULL,
@MatrixTableNo uniqueidentifier= NULL,
@LinkNo uniqueidentifier= NULL,
@Matrix1 nvarchar(50)= NULL,
@Matrix2 nvarchar(50)= NULL,
@Matrix3 nvarchar(50)= NULL,
@Matrix4 nvarchar(50)= NULL,
@Matrix5 nvarchar(50)= NULL,
@Matrix6 nvarchar(50)= NULL,
@BarcodeNumber nvarchar(50),
@CaseBarcodeNumber nvarchar(50)= NULL,
@CaseQty int= 1,
@CaseDescription nvarchar(50)= NULL,
@BarcodeType int= NULL,
@ItemType int,
@ItemPicture image= NULL,
@PicturePath nvarchar(4000)= NULL,
@ItemPicture2 image= NULL,
@PicturePath2 nvarchar(4000)= NULL,
@ItemPicture3 image= NULL,
@PicturePath3 nvarchar(4000)= NULL,
@IsTemplate bit= NULL,
@IsSerial bit= NULL,
@ManufacturerID uniqueidentifier= NULL,
@ManufacturerPartNo nvarchar(50)= NULL,
@PriceByCase bit= 0,
@CostByCase bit= 0,
@Size nvarchar(50)= NULL,
@ExtraInfo nvarchar(500)= NULL,
@ExtraInfo2 nvarchar(200)=null,
@Status smallint,
@Units decimal(18,2) =0,
@Meaasure int =0,
@CaseBarCode nvarchar(25) ='',
@CustomerCode nvarchar(50)=null,
@StyleNo nvarchar(50)=null,
@NoScanMsg nvarchar(100)=null,
@CustomInteger1 int=null,
@SeasonID uniqueidentifier = NULL,
@ExtName nvarchar(100) = NULL,
@CustomField1 uniqueidentifier = NULL,
@CustomField2 uniqueidentifier = NULL,
@CustomField3 uniqueidentifier = NULL,
@CustomField4 uniqueidentifier = NULL,
@CustomField5 uniqueidentifier = NULL,
@CustomField6 uniqueidentifier = NULL,
@CustomField7 uniqueidentifier = NULL,
@CustomField8 uniqueidentifier = NULL,
@CustomField9 uniqueidentifier = NULL,
@CustomField10 uniqueidentifier = NULL,
@Note nvarchar(4000) = NULL,
@PkgCode nvarchar(50) = NULL,
@ModifierID uniqueidentifier)
AS 


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

declare @vCustomerCode nvarchar(50)

IF LTRIM(RTRIM(@CustomerCode))=''
  SET @vCustomerCode=NULL
ELSE
  SET @vCustomerCode=@CustomerCode 

IF EXISTS(Select * From ItemMain Where ItemID = @ItemID)
EXEC	[dbo].[SP_ItemMainUpdate]
@ItemID = @ItemID,@Name = @Name,@Description = @Description,@ModalNumber = @ModalNumber,@Quantization = @Quantization,@Unit = @Unit,@ParentID = @ParentID,@MatrixTableNo = @MatrixTableNo,@LinkNo = @LinkNo,@Matrix1 = @Matrix1,@Matrix2 = @Matrix2,@Matrix3 = @Matrix3,
@Matrix4 = @Matrix4,@Matrix5 = @Matrix5,@Matrix6 = @Matrix6,@BarcodeNumber = @BarcodeNumber,@CaseBarcodeNumber = @CaseBarcodeNumber,@CaseQty = @CaseQty,@CaseDescription = @CaseDescription,@BarcodeType = @BarcodeType,@ItemType = @ItemType,@ItemPicture = @ItemPicture,
@PicturePath = @PicturePath,@ItemPicture2 = @ItemPicture2,@PicturePath2 = @PicturePath2,@ItemPicture3 = @ItemPicture3,@PicturePath3 = @PicturePath3,@IsTemplate = @IsTemplate,@IsSerial = @IsSerial,@ManufacturerID = @ManufacturerID,
@ManufacturerPartNo = @ManufacturerPartNo,@PriceByCase = @PriceByCase,@CostByCase = @CostByCase,@Size = @Size,@ExtraInfo = @ExtraInfo,@ExtraInfo2 = @ExtraInfo2,@Status = @Status,@Units = @Units,@Meaasure = @Meaasure,@CaseBarCode = @CaseBarCode,
@CustomerCode = @CustomerCode,@StyleNo = @StyleNo,@NoScanMsg = @NoScanMsg,@CustomInteger1 = @CustomInteger1,@SeasonID = @SeasonID,@ExtName = @ExtName,@CustomField1 = @CustomField1,@CustomField2 = @CustomField2,@CustomField3 = @CustomField3,
@CustomField4 = @CustomField4,@CustomField5 = @CustomField5,@CustomField6 = @CustomField6,@CustomField7 = @CustomField7,@CustomField8 = @CustomField8,@CustomField9 = @CustomField9,@CustomField10 = @CustomField10,@DateModified = @UpdateTime,@ModifierID = @ModifierID,
@Note = @Note, @PkgCode =@PkgCode
 
ELSE
INSERT INTO dbo.ItemMain
                      (ItemID, Name, Description, ModalNumber, Quantization, Unit, ParentID, MatrixTableNo, LinkNo, Matrix1, Matrix2,Matrix3,Matrix4,Matrix5,Matrix6, BarcodeNumber, 
                      CaseBarcodeNumber, CaseQty,CaseDescription, BarcodeType, ItemType, ItemPicture, PicturePath,ItemPicture2, PicturePath2,ItemPicture3, PicturePath3, IsTemplate, IsSerial, ManufacturerID, 
                      ManufacturerPartNo,PriceByCase,CostByCase,Size,ExtraInfo,ExtraInfo2, Status,Units,Meaasure,CaseBarCode,CustomerCode,StyleNo,NoScanMsg,CustomInteger1, SeasonID, ExtName, DateCreated, UserCreated, DateModified, UserModified,
					  CustomField1,CustomField2,CustomField3,CustomField4,CustomField5,CustomField6,CustomField7,CustomField8,CustomField9,CustomField10,Note,PkgCode
					  
					  )
VALUES     (@ItemID, dbo.CheckString(@Name), dbo.CheckString(@Description), dbo.CheckString(@ModalNumber), @Quantization, @Unit, @ParentID, @MatrixTableNo, @LinkNo, @Matrix1, @Matrix2,  @Matrix3, @Matrix4, @Matrix5, @Matrix6,
                      dbo.CheckString(@BarcodeNumber), @CaseBarcodeNumber, @CaseQty,dbo.CheckString(@CaseDescription), IsNull(@BarcodeType,0), @ItemType, @ItemPicture, @PicturePath,
					@ItemPicture2, @PicturePath2,@ItemPicture3, @PicturePath3, @IsTemplate, 
                      @IsSerial, @ManufacturerID, @ManufacturerPartNo,@PriceByCase,@CostByCase,@Size,@ExtraInfo,@ExtraInfo2, ISNULL(@Status, 1),
@Units,@Meaasure,@CaseBarCode,@vCustomerCode,@StyleNo,@NoScanMsg,@CustomInteger1, @SeasonID,  @ExtName, @UpdateTime, @ModifierID, @UpdateTime, @ModifierID,
 @CustomField1,@CustomField2,@CustomField3,@CustomField4,@CustomField5,@CustomField6,@CustomField7,@CustomField8,@CustomField9,@CustomField10,@Note,@PkgCode
)

if @ItemType = 2
    exec SP_ZeroParentItems

select @UpdateTime as DateModified
GO