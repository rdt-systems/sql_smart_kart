SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SaleAssociateInsert]
(@TransactionID uniqueidentifier,
 @SaleAssociateID uniqueidentifier
 )
AS
declare @ID int
SET @ID = (SELECT ISNULL(MAX(SaleAssociateID),0) FROM SaleAssociate)+1
INSERT INTO SaleAssociate
                         (SaleAssociateID, UserID, TransactionID)
VALUES        (@ID,@SaleAssociateID,@TransactionID)
GO