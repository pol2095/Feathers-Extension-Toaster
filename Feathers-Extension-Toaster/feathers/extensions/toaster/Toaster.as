/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.core.PopUpManager;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.LayoutGroup;
		
	/**
	 * A toaster provides simple feedback about an operation in a small popup.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.TextToaster
	 */
	public class Toaster extends LayoutGroup
	{
		/**
		 * Determines if the toaster is centered.
		 *
		 * @default false
		 */
		public var isCentered:Boolean;
		
		private var _delay:Number = 1.0;
		/**
		 * The duration to display the toaster message in seconds.
		 *
		 * @default 1.0
		 */
		public function get delay():Number
		{
			return this._delay;
		}
		public function set delay(value:Number):void
		{
			this._delay = value;
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
		}
		
		/**
		 * The toasters added on the stage.
		 */
		public var toasters:Vector.<TextToaster>;
		
		private var _this:Object;
		
		public function Toaster(_this:Object)
        {
			//this.includeInLayout = false;
			this._this = _this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_this.stage.addEventListener(Event.RESIZE, onResize);
        }
		
		public function onResize(event:Event = null):void
        {
			for each(var textToaster:TextToaster in toasters)
			{
				if(textToaster.isCentered)
				{
					var _x:Number = (_this.stage.stageWidth - textToaster.width) / 2;
					//var _y:Number = (_this.stage.stageHeight - textToaster.height) / 2;
					textToaster.move (_x, textToaster.y);
				}
			}
		}
		
		private function createCallout( text:String ):TextToaster
		{
			var textToaster:TextToaster = new TextToaster();
			if(!toasters) toasters = new <TextToaster>[];
			toasters.push( textToaster );
			textToaster.text = text;
			textToaster.alpha = 0.0;
			textToaster.labelOffsetX = labelOffsetX;
			textToaster.labelOffsetY = labelOffsetY;
			//textToaster.includeInLayout = false;
			textToaster.topArrowSkin = textToaster.rightArrowSkin = textToaster.bottomArrowSkin = textToaster.leftArrowSkin = null;
			 
			if(isCentered) textToaster.validate();
			//_this.stage.addChild(textToaster);
			PopUpManager.addPopUp( textToaster, false, false );
			textToaster.validate();
			
			return textToaster;
		}
		
		private function callout_show(textToaster:TextToaster, delay:Number, start : Number = 0.0, finish : Number = 1.0, transitions : String = Transitions.EASE_OUT) : void
		{
			Starling.juggler.tween (textToaster, delay,
			{
				alpha : finish,
				transition : transitions,
				onStart : function () : void
				{			 
					textToaster.alpha = start;
				},
				onComplete : function () : void
				{			 
					if(finish == 1.0) setTimeout(callout_timeout, 1000, textToaster, delay);
					if(finish == 0.0) callout_close( textToaster );
				}
			});
		}
		
		/**
		 * Move the toaster to the specified position.
		 *
		 * @param textToaster A TextToaster control
		 *
		 * @param x The horizontal coordinate
		 *
		 * @param y The vertical coordinate
		 */
		public function moveTo( textToaster:TextToaster, x:Number, y:Number ):void
		{
			var _x:Number = ! textToaster.isCentered ? x : textToaster.x;
			textToaster.move(_x, y);
		}
		
		/**
		 * Add a toaster to the stage.
		 *
		 * @param text Text of the toaster
		 */
		public function open( text:String ):TextToaster
		{
			if( ! _this.stage.hasEventListener(Event.RESIZE, onResize) ) _this.stage.addEventListener(Event.RESIZE, onResize);
			var textToaster:TextToaster = createCallout(text);
			callout_show(textToaster, delay, 0.0, 1.0, Transitions.EASE_OUT);
			textToaster._this = this;
			textToaster.isCentered = isCentered;
			return textToaster;
		}
		
		private function callout_timeout():void
		{
			callout_show(arguments[0], arguments[1], 1.0, 0.0, Transitions.EASE_IN);
		}
		
		private function callout_close( textToaster:TextToaster ):void
		{
			toasters.splice( toasters.indexOf( textToaster ), 1 );
			//_this.stage.removeChild(textToaster);
			PopUpManager.removePopUp( textToaster );
		}
		
		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(_this.stage)
			{
				_this.stage.removeEventListener(Event.RESIZE, onResize);
				for each(var textToaster:TextToaster in toasters) _this.stage.removeChild(textToaster);
			}
			toasters = null;
			
			super.dispose();
		}
	}
}