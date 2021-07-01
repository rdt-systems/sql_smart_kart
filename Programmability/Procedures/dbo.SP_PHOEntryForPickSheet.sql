SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_PHOEntryForPickSheet]

@PHOID nvarchar (4000)

as

declare @MySelect nvarchar(4000)
declare @Order nvarchar (50)

	set @MySelect= 'Select * from PhoneOrderEntryPickSheet'
	set @PHOID = @PHoid + ' And Status > -1'  
	set @Order =  ' Order by SortOrder' 
	    
	Execute (@MySelect + @PHOID + @Order)
GO