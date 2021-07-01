SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_StateInsert]
(@StateCode nvarchar(50),
@StateName nvarchar(50),
@StateSort int
)
AS 
INSERT INTO dbo.State
           (StateCode
           ,StateName
           ,StateSort)
     VALUES (@StateCode,@StateName ,@StateSort)
GO