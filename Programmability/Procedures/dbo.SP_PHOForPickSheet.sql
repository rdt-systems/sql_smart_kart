SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_PHOForPickSheet]

@PHOID varchar(4000)

as

declare @MySelect nvarchar(4000)
Set @MySelect= 'Select * from PhoneOrderPickSheet'

Execute (@MySelect + @PHOID )

-- Update stauts

Set @MySelect= 'Update PhoneOrder Set PhoneOrderStatus = 2, DateModified = dbo.GetLocalDATE()' 
Execute (@MySelect + @PHOID +' AND (PhoneOrderStatus = 0 OR PhoneOrderStatus = 3)')
GO