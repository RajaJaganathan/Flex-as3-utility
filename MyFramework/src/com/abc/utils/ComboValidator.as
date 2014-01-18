/**
* Validates anything against anything, really.
* Please maintain @author tag.
* @author Roger Braunstein | Your Majesty Co | 2007
*/
package com.abc.utils
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class ComboValidator extends Validator
	{
		//You may either accept certain values and reject all others,
		//or reject certain values and accept all others.
		//We're too lazy to make sure you don't specify both, but don't.

		[Inspectable]
		public var acceptedValues:Array = null;

		[Inspectable]
		public var rejectedValues:Array = null;

		[Inspectable]
		public var errorMessage:String = "Invalid option selected";

		public function ComboValidator()
		{
			super();
		}

		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);

			var invalid:Boolean = false;
			if (acceptedValues)
			{
				if (acceptedValues.indexOf(value) == -1) invalid = true;
			} else if (rejectedValues) {
				if (rejectedValues.indexOf(value) != -1) invalid = true;
			}

			if (invalid)
			{
				results.push(new ValidationResult(true, "", "", errorMessage));
			}

			return results;
		}
	}
}


/*

<validators:ComboValidator rejectedValues="{[0]}" source="{someComboInput}" property="selectedIndex" errorMessage="Select one." />
<validators:ComboValidator acceptedValues="{[true]}" source="{someCheckBox}" property="selected" errorMessage="It must be checked."
*/

