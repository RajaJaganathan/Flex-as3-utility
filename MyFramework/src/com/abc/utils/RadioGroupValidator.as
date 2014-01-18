package com.abc.utils
{	
	import mx.validators.Validator;
	
	public class RadioGroupValidator extends Validator
	{
		public function RadioGroupValidator()
		{
			super();
			requiredFieldError = "Please choose an option from the list."
		}
		
		override public function validate(value:Object = null, suppressEvents:Boolean = false):ValidationResultEvent
		{
			var result:ValidationResultEvent = super.validate(value, suppressEvents);
			
			for (var i:uint = 0; i < this.source.numRadioButtons; i++)
			{
				if (result.type == ValidationResultEvent.INVALID)
				{
					this.source.getRadioButtonAt(i).errorString = result.message;
				}
				else
				{
					this.source.getRadioButtonAt(i).errorString = null;
				}
			}
			
			return result;
		}
	}
}

