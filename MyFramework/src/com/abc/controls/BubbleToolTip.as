/**
 * BubbleToolTip is a simple all-inclusive textual component that, when visible, will
 * display a "thought bubble" tool-tip container wherever the tag is placed within a layout
 * container (VBox, HBox, FormItem, etc).
 *
 * This extends mx.controls.Text so all properties and methods available via Text.as are
 * available here.
 *
 * Sample Usage:
 *
 * <mx:FormItem id="emailForm"
 *		<mx:TextInput id="inpEmailAddress"
 * 		focusOut="bubbleToolTip.visible = false"
 * 		focusIn="bubbleToolTip.visible = true"/>
 *
 * 		<components:BubbleToolTip id="bubbleToolTip"
 * 		x="{inpEmailAddress.x + inpEmailAddress.width}"
 * 		y="{inpEmailAddress.y}"
 * 		width="250" direction="up"/>
 * </mx:FormItem>
 *
 *
 * Sample Style:
 *
 * BubbleToolTip
 * {
 *		background-alpha		: 0.85;
 *		background-color		: #FFF79F;
 *		border-color			: #666666;
 *		color				: #000000;
 *		font-family			: Arial;
 *		font-size			: 12px;
 * }
 *
 *
 * @author Erich Cervantez
 * @date 01/13/2009
 */

package com.abc.controls
{
	import mx.controls.Text;

	public class BubbleToolTip extends Text
	{
		/**
		 * Specifies the padding between text and bubble border
		 */
		private const PADDING : Number = 8;

		/**
		 * @private
		 */
		private var m_direction : String;

		/**
		 * Specifies the direction (up,down) of the bubble
		 */
		[Inspectable(category="General", enumeration="up,down", defaultValue="down")]
		public function get direction() : String
		{
			return m_direction;
		}
		public function set direction( value : String ) : void
		{
			m_direction = value;
		}

		/**
		 * Constructor
		 */
		public function BubbleToolTip()
		{
			super();

			visible = false;
			includeInLayout = false;
		}

		/**
		 * Draw the customized text container whenever updateDisplayList is triggered
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{   			
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			textField.x = textField.x + ( m_direction == "down" ) ? 32 : 35;
			textField.y = textField.y + ( m_direction == "down" ) ? 28 : -( textField.height + PADDING/2 );

			var calHeight : Number = textField.height + PADDING;
			var calWidth : Number = textField.width + PADDING;

			x = x + 5;

			this.graphics.clear();

			this.graphics.beginFill( getStyle('backgroundColor'), 1 );
			this.graphics.lineStyle(2, getStyle('borderColor'), 1);
			this.graphics.drawRoundRect(0, 0, 6, 6, 24, 24);
			this.graphics.endFill();

			this.graphics.beginFill( getStyle('backgroundColor'), 1 );
			this.graphics.lineStyle(2, getStyle('borderColor'), 1);
			this.graphics.drawRoundRect(10, m_direction == "down" ? 10:-10, 15, 15, 24, 24);
			this.graphics.endFill();

			this.graphics.beginFill( getStyle('backgroundColor'), 1 );
			this.graphics.lineStyle(2, getStyle('borderColor'), 1);
			this.graphics.drawRoundRect(m_direction == "down" ? 25:30, m_direction == "down" ? 25:-calHeight, 
				calWidth, calHeight, 24, 24);
			this.graphics.endFill();
		} 
	}
}

