SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[ItemMainView]
WITH SCHEMABINDING 
AS
SELECT        TOP (100) PERCENT ItemID, Name, Description, ModalNumber, Quantization, Unit, ParentID, MatrixTableNo, LinkNo, Matrix1, Matrix2, Matrix3, Matrix4, Matrix5, Matrix6, BarcodeNumber, CaseBarcodeNumber, 
                         --CASE WHEN ISNULL(CaseQty, 0) > 0 THEN CASEQTY ELSE 1 END AS 
						 CaseQty, CaseDescription, BarcodeType, ItemType, ItemPicture, PicturePath, ItemPicture2, PicturePath2, ItemPicture3, PicturePath3, 
                         IsTemplate, IsSerial, ManufacturerID, ManufacturerPartNo, PriceByCase, CostByCase, Size, Status, DateCreated, UserCreated, DateModified, UserModified, ExtraInfo, ExtraInfo2, Units, Meaasure, CaseBarCode, 
                         CustomerCode, NoScanMsg, StyleNo, CustomInteger1, SeasonID,extname ,PkgCode,
						CustomField1,CustomField2,CustomField3,CustomField4,CustomField5,CustomField6,CustomField7,CustomField8,CustomField9,CustomField10

FROM            dbo.ItemMain
GO