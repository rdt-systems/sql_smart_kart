SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CountryInsert]
(@ContryName nvarchar(50),
@SortOrder int
)
AS 
INSERT INTO dbo.Country
           (ContryName ,SortOrder)
     VALUES (@ContryName,@SortOrder)
GO