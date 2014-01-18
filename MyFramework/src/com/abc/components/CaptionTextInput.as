package com.abc.components
{
	import flash.events.FocusEvent;
	import spark.components.TextInput;

	public class CaptionTextInput extends TextInput
	{
		private var _showsCaption:Boolean;
		private var _caption:String;

		public function CaptionTextInput()
		{
			super();
			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		[Bindable]
		[Bindable("change")]
		
		[Bindable]
		[Bindable("textChanged")]
		override public function set text(value:String):void {
			this._showsCaption = false;
			super.text = value;
		}

		override public function get text():String {
			if (this._showsCaption) {
				return "";
			}
			else return super.text;
		}

		/**
		 * The value to be shown if the textfield has no text (this.text == '')
		 */
		public function set caption(value:String):void {
			if (super.text == "") {
				super.text = value;
				this._caption = value;
				this._showsCaption = true;
			}
		}

		private function onFocusIn(ev:FocusEvent):void {
			if (this._showsCaption) {
				this._showsCaption = false;
				super.text = "";
			}
		}

		private function onFocusOut(ev:FocusEvent):void {
			if (this.text == "") {
				this._showsCaption = true;
				super.text = _caption;
			}
		}
	}
}

