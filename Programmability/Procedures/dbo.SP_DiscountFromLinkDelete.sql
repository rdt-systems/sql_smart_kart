SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- Create date: <3/12/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountFromLinkDelete]
	(@ID uniqueidentifier,
	@ModifierID uniqueidentifier= null)
AS
BEGIN
 DELETE FROM DiscountFromLink WHERE ID =@ID 
END
GO