SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE Procedure [dbo].[SP_GridFieldsOptionsUpdate](@ID int, @ShowField int, @FieldDescription nvarchar(50))
as
Update GridFieldsOptions set ShowField = @ShowField, FieldDescription = @FieldDescription where ID = @ID
GO