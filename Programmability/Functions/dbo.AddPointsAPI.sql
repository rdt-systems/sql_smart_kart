SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[AddPointsAPI](@UserName [nvarchar](50), @Password [nvarchar](50), @CardNumber [nvarchar](50), @Amount [nvarchar](50), @ReceiptDate [nvarchar](50), @ReceiptNo [nvarchar](20))
RETURNS decimal(18,4)
AS
BEgin

return 1/0
end
GO