SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ZipCodesInsert]
(@ZipCode varchar(8000),
@City nvarchar(4000),
@StateID nvarchar(50)
)
AS 
INSERT INTO dbo.ZipCodes
           (ZipCode,City,StateID)
     VALUES (@ZipCode,@City,@StateID)
GO