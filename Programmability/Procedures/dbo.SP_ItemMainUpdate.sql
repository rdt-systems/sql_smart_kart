SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemMainUpdate]  
(@ItemID uniqueidentifier,  
@Name nvarchar(4000),  
@Description nvarchar(4000) =Null,  
@ModalNumber nvarchar(4000),  
@Quantization decimal =Null,  
@Unit uniqueidentifier = NULL,  
@ParentID uniqueidentifier =NULL ,  
@MatrixTableNo uniqueidentifier=NULL,  
@LinkNo uniqueidentifier=NULL,  
@Matrix1 nvarchar(50)=NULL,  
@Matrix2 nvarchar(50)=NULL,  
@Matrix3 nvarchar(50)=NULL,  
@Matrix4 nvarchar(50)=NULL,  
@Matrix5 nvarchar(50)=NULL,  
@Matrix6 nvarchar(50)=NULL,  
@BarcodeNumber nvarchar(50),  
@CaseBarcodeNumber nvarchar(50)=NULL,  
@CaseQty int=1,  
@CaseDescription nvarchar(50)=NULL,  
@BarcodeType int=NULL,  
@ItemType int,  
@ItemPicture  image=NULL,  
@PicturePath  nvarchar(4000)=NULL,  
@ItemPicture2 image=NULL,  
@PicturePath2 nvarchar(4000)=NULL,  
@ItemPicture3 image=NULL,  
@PicturePath3 nvarchar(4000)=NULL,  
@IsTemplate bit=NULL,  
@IsSerial bit=NULL,  
@ManufacturerID uniqueidentifier=NULL,  
@ManufacturerPartNo nvarchar(50)=NULL,  
@PriceByCase bit=NULL,  
@CostByCase bit=NULL,  
@Size nvarchar(50)=NULL,  
@ExtraInfo nvarchar(MAX)=NULL,  
@ExtraInfo2 nvarchar(MAX)=null,  
@Status smallint,  
@Units decimal(18,2) =0,  
@Meaasure int =0,  
@CaseBarCode nvarchar(25) ='',  
@CustomerCode nvarchar(50)=null,  
@StyleNo nvarchar(50)=null,  
@NoScanMsg nvarchar(100)=null,  
@CustomInteger1 int =null,  
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
@DateModified datetime,  
@ModifierID uniqueidentifier)  
AS   
 
Declare @UpdateTime datetime  
set  @UpdateTime =dbo.GetLocalDATE()  
 
declare @vCustomerCode nvarchar(50)  
IF LTRIM(RTRIM(@CustomerCode))=''  
  SET @vCustomerCode=NULL  
ELSE  
  SET @vCustomerCode=@CustomerCode   
 
UPDATE    dbo.ItemMain  
 
SET      [Name] = dbo.CheckString(@Name),  
   [Description] = dbo.CheckString(@Description),  
   ModalNumber = dbo.CheckString(@ModalNumber),  
   Quantization = @Quantization,   
   Unit = @Unit,   
   ParentID = @ParentID,   
   MatrixTableNo = @MatrixTableNo,   
   LinkNo = @LinkNo,  
   Matrix1 = @Matrix1,  
   Matrix2 = @Matrix2,  
   Matrix3 = @Matrix3,  
   Matrix4 = @Matrix4,  
   Matrix5 = @Matrix5,  
   Matrix6 = @Matrix6,  
   BarcodeNumber =dbo.CheckString(@BarcodeNumber),   
         CaseBarcodeNumber = @CaseBarcodeNumber,   
   CaseQty = @CaseQty,   
   CaseDescription = @CaseDescription,   
   BarcodeType =IsNull(@BarcodeType,BarcodeType),   
     
   ItemType = @ItemType,   
   ItemPicture = null,  
   PicturePath =@PicturePath,   
   ItemPicture2 = null,  
   PicturePath2 =@PicturePath2,   
      ItemPicture3 = null,  
    PicturePath3 =@PicturePath3,   
    IsTemplate = @IsTemplate,   
     IsSerial = @IsSerial,   
   ManufacturerID = @ManufacturerID,   
   ManufacturerPartNo = @ManufacturerPartNo,  
   PriceByCase=0,--IsNull(@PriceByCase,PriceByCase),  
   CostByCase=IsNull(@CostByCase,CostByCase),   
   Size= @Size,  
   ExtraInfo = @ExtraInfo,  
         ExtraInfo2 = @ExtraInfo2,  
   Status =ISNULL(@Status, 1),  
   Units=@Units,  
         Meaasure=@Meaasure,  
         CaseBarCode=@CaseBarCode ,  
   CustomerCode= @vCustomerCode,  
   StyleNo = @StyleNo ,  
   NoScanMsg= @NoScanMsg,  
   CustomInteger1=@CustomInteger1,  
   SeasonID = @SeasonID,  
   ExtName = @ExtName,  
   CustomField1 = @CustomField1,  
   CustomField2 = @CustomField2,  
   CustomField3 = @CustomField3,  
   CustomField4 = @CustomField4,  
   CustomField5 = @CustomField5,  
   CustomField6 = @CustomField6,  
   CustomField7 = @CustomField7,  
   CustomField8 = @CustomField8,  
   CustomField9 = @CustomField9,  
   CustomField10 = @CustomField10,  
   DateModified = @UpdateTime,   
   UserModified = @ModifierID, 
   PkgCode = @PkgCode,
   Note = @Note 
 
WHERE    (ItemID = @ItemID) --AND (DateModified = @DateModified OR DateModified IS NULL)   
 
IF ISNULL(@Status, 1) <1  
Update ItemStore Set Status = @Status, DateModified = dbo.GetLocalDATE() Where  ItemNo = @ItemID and Status >-1  
 
select @UpdateTime as DateModified  
 
 
 
--Update chiledrin items  
If @ItemType = 2  
begin  
UPDATE    dbo.ItemMain  
 
SET      Name=dbo.CheckString(@Name) + (Case When IsNull(matrix1,'') = '-' Then '' ELSE ' ' + Matrix1 END) + (Case When IsNull(matrix2,'') = '-' Then '' ELSE ' ' +  Matrix2 END),
--      [Description] = dbo.CheckString(@Description),  
   --Alex Abreu 6/20/2016  
   --Modal number was comment I put it uncomment by Nathan   
   --ModalNumber = dbo.CheckString(@ModalNumber),  
  -- ModalNumber = @ModalNumber,  
   Quantization = @Quantization,   
   Unit = @Unit,   
   ParentID = @ParentID,   
         CaseBarcodeNumber = @CaseBarcodeNumber,   
   CaseQty = @CaseQty,   
   CaseDescription = @CaseDescription,   
   BarcodeType =IsNull(@BarcodeType,BarcodeType),   
   ItemPicture = @ItemPicture,  
   PicturePath =@PicturePath,   
   ItemPicture2 = @ItemPicture2,  
   PicturePath2 =@PicturePath2,   
      ItemPicture3 = @ItemPicture3,  
    PicturePath3 =@PicturePath3,   
    IsTemplate = @IsTemplate,   
     IsSerial = @IsSerial,   
   ManufacturerID = @ManufacturerID,   
   ManufacturerPartNo = @ManufacturerPartNo,  
   PriceByCase=IsNull(@PriceByCase,PriceByCase),  
   CostByCase=IsNull(@CostByCase,CostByCase),   
   Size= @Size,  
   ExtraInfo = @ExtraInfo,  
         ExtraInfo2 = @ExtraInfo2,  
  -- Status =ISNULL(@Status, 1),  
   Units=@Units,  
         Meaasure=@Meaasure,  
         CaseBarCode=@CaseBarCode ,  
   CustomerCode= @vCustomerCode,  
   SeasonID = @SeasonID,  
   ExtName = @ExtName,  
   NoScanMsg= @NoScanMsg,  
   DateModified = @UpdateTime,   
   UserModified = @ModifierID,  
  CustomField1 = @CustomField1,  
  CustomField2 = @CustomField2,  
  CustomField3 = @CustomField3,  
  CustomField4 = @CustomField4,  
  CustomField5 = @CustomField5,  
  CustomField6 = @CustomField6,  
  CustomField7 = @CustomField7,  
  CustomField8 = @CustomField8,  
  CustomField9 = @CustomField9,
  CustomField10 = @CustomField10  
  WHERE  LinkNo = @ItemID  
 
 
IF ISNULL(@Status, 1) < 1   
Update ItemStore Set Status = @Status, DateModified = dbo.GetLocalDATE() Where  ItemNo IN (Select ItemID From ItemMain Where LinkNo = @ItemID)  
exec SP_ZeroParentItems 
end  

  
Update ItemStore Set DateModified = dbo.GetLocalDATE() where ItemNo = @ItemID
GO