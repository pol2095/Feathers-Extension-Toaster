/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.extensions.borderContainer.BorderContainer;
	import feathers.layout.VerticalLayout;
	import starling.events.Event;
	
	/**
	 * A TextToaster is a toaster add in <code>Toaster</code> control.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.Toaster
	 */
	public class DefaultToaster extends BorderContainer
	{
		public function DefaultToaster()
        {
			super();
			this.layout = new VerticalLayout();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
		
		/**
		 * @private
		 */
		public function init(_this:Toaster):void
        {
			this._this = _this;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
		
		private function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_this.addedToStageHandler( stage );
		}
		
		private function onEnterFrame(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.validate();
			_this.onResize();
        }
		
		private var _offsetX:Number = 8;
		/**
		 * The minimum space, in pixels, between the toaster's left and right edge and the toaster's content.
		 *
		 * @default 8
		 */
		public function get offsetX():Number
		{
			return this._offsetX;
		}
		public function set offsetX(value:Number):void
		{
			this._offsetX = value;
			(this.layout as VerticalLayout).paddingLeft = (this.layout as VerticalLayout).paddingRight = offsetX;
		}
		
		private var _offsetY:Number = 8;
		/**
		 * The minimum space, in pixels, between the toaster's top and bottom edge and the toaster's content.
		 *
		 * @default 8
		 */
		public function get offsetY():Number
		{
			return this._offsetY;
		}
		public function set offsetY(value:Number):void
		{
			this._offsetY = value;
			(this.layout as VerticalLayout).paddingTop = (this.layout as VerticalLayout).paddingBottom = offsetY;
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
		public var delayToDisplay:Number;
		
		/**
		 * @private
		 */
		public var delay:Number;
	}
}