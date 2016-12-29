/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.controls.TextCallout;
	
	/**
	 * A TextToaster is a toaster add in <code>Toaster</code> control.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.Toaster
	 */
	public class TextToaster extends TextCallout
	{
		public function TextToaster()
        {
			super();
        }
		
		private var _labelOffsetX:Number = 8;
		/**
		 * The minimum space, in pixels, between the toaster's left and right edge and the toaster's content.
		 *
		 * @default 8
		 */
		public function get labelOffsetX():Number
		{
			return this._labelOffsetX;
		}
		public function set labelOffsetX(value:Number):void
		{
			this._labelOffsetX = value;
			this.paddingLeft = this.paddingRight = labelOffsetX;
		}
		
		private var _labelOffsetY:Number = 8;
		/**
		 * The minimum space, in pixels, between the toaster's top and bottom edge and the toaster's content.
		 *
		 * @default 8
		 */
		public function get labelOffsetY():Number
		{
			return this._labelOffsetY;
		}
		public function set labelOffsetY(value:Number):void
		{
			this._labelOffsetY = value;
			this.paddingTop = this.paddingBottom = labelOffsetY;
		}
	}
}