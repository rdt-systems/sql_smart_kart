SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountDepartmentUpdate]
(           @DiscountDepartmentID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@DepartmentID uniqueidentifier
           ,@Status smallint,
		    @DateModified datetime,
		    @ModifierID uniqueidentifier
)
AS
UPDATE [dbo].[DiscountDepartment]
    SET[DiscountID] = @DiscountID
      ,[DepartmentID] = @DepartmentID  
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE [DiscountDepartmentID] = @DiscountDepartmentID
GO