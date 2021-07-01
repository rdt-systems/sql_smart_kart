SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToTenderInsert]

(
@SaleToTenderID	uniqueidentifier,
@SaleID	uniqueidentifier,	
@TenderID	int,	
@Status	smallint,	
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.SaleToTender
       (
SaleToTenderID,SaleID	,TenderID	,	
Status,DateCreated,UserCreated,DateModified,UserModified		
		)

VALUES  (
	     @SaleToTenderID,@SaleID,@TenderID,
		1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID
		)
GO