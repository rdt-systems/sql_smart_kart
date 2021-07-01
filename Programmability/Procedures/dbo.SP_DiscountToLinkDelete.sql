SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- Create date: <3/12/2012>
-- Description:	Update >
-- =============================================
CREATE PROCEDURE [dbo].[SP_DiscountToLinkDelete]
	(@ID uniqueidentifier)
AS
BEGIN
 DELETE FROM DiscountToLink WHERE ID =@ID 
END
GO