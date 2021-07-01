SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_DBUpdatesInsert]
(@Version float,
@UpdateText ntext,
@Sort smallint,
@Comment nvarchar(100),
@Status smallint,
@DateCreated datetime,
@UserCreated nvarchar(30))
as 
insert into dbo.DBUpdates([Version],[UpdateText],[Sort],[Comment],[Status],[DateCreated],[UserCreated])
values (@Version,@UpdateText,@Sort,@Comment,@Status,@DateCreated,@UserCreated)
GO