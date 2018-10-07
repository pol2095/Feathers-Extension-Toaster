/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.controls.TextCallout;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * A TextToaster is a toaster add in <code>Toaster</code> control.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.Toaster
	 */
	public class TextToaster extends TextCallout
	{
		public function TextToaster(_this:Toaster)
        {
			super();
			this._this = _this;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
		
		private function onEnterFrame(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.validate();
			_this.onResize();
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
		
		private var _isCentered:Boolean;
		/**
		 * Determines if the toaster is centered.
		 *
		 * @default false
		 */
		public function get isCentered():Boolean
		{
			return this._isCentered;
		}
		public function set isCentered(value:Boolean):void
		{
			if( this._isCentered == value ) return;
			this._isCentered = value;
			_this.onResize();
		}
		
		/**
		 * @private
		 */
		public var _this:Toaster;
		
		private var _anchorBottom:Number = NaN;
		/**
		 * The distance between the toaster an the bottom of the stage.
		 *
		 * @default NaN
		 */
		public function get anchorBottom():Number
		{
			return this._anchorBottom;
		}
		public function set anchorBottom(value:Number):void
		{
			this._anchorBottom = value;
			_this.onResize();
		}
		
		/**
		 * @private
		 */
		public var delay:Number;
	}
}