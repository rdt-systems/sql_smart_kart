SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GridFieldView]
as
Select distinct ViewDescription from GridFieldsOptions
GO