SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountDepartmentInsert]
(           @DiscountDepartmentID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@DepartmentID uniqueidentifier
           ,@Status smallint,
		    @ModifierID uniqueidentifier
)
AS
INSERT INTO [dbo].[DiscountDepartment]
           ([DiscountDepartmentID]
           ,[DiscountID]
           ,[DepartmentID]
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           )
     VALUES
           (@DiscountDepartmentID
           ,@DiscountID
           ,@DepartmentID
           ,@Status
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           )
GO