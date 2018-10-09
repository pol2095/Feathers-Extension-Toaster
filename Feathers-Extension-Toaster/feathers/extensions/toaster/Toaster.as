/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.core.PopUpManager;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
		
	/**
	 * A toaster provides simple feedback about an operation in a small popup.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.TextToaster
	 */
	public class Toaster
	{
		/**
		 * Determines if the toaster is centered.
		 *
		 * @default false
		 */
		public var isCentered:Boolean;
		
		
		private var _delayToDisplay:Number = 1.0;
		/**
		 * The delay to display totally the toaster message in seconds (fade effect). It's the same delay to remove the toaster.
		 *
		 * @default 1.0
		 */
		public function get delayToDisplay():Number
		{
			return this._delayToDisplay;
		}
		public function set delayToDisplay(value:Number):void
		{
			this._delayToDisplay = value;
		}
		
		private var _delay:Number = 1.0;
		/**
		 * The duration to display totally the toaster message in seconds (without fade effect).
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
		protected var toasters:Vector.<TextToaster>;
		
		private var _this:Object;
		
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
		}
		
		/**
		 * If taskManager is set to true, every toaster start when the previous toaster is finished.
		  *
		 * @default false
		 */
		public var taskManager:Boolean;
		
		public function Toaster(_this:Object)
        {
			//this.includeInLayout = false;
			this._this = _this;
			//this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		
		/*private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_this.stage.addEventListener(Event.RESIZE, onResize);
        }*/
		
		/**
		 * @private
		 */
		public function onResize(event:Event = null):void
        {
			for each(var textToaster:TextToaster in toasters)
			{
				if( ! textToaster.isCreated ) return;
				var _y:Number;
				if(textToaster.isCentered)
				{
					var _x:Number = (_this.stage.stageWidth - textToaster.width) / 2;
					if( ! isNaN( textToaster.anchorBottom ) )
					{
						_y = _this.stage.stageHeight - textToaster.anchorBottom - textToaster.height;
					}
					else
					{
						_y = textToaster.y
					}
					textToaster.move(_x, _y);
				}
				else if( ! isNaN( textToaster.anchorBottom ) )
				{
					_y = _this.stage.stageHeight - textToaster.anchorBottom - textToaster.height;
					textToaster.move(textToaster.x, _y);
				}
			}
		}
		
		private function createCallout( text:String ):TextToaster
		{
			var textToaster:TextToaster = new TextToaster(this);
			if(!toasters) toasters = new <TextToaster>[];
			toasters.push( textToaster );
			textToaster.text = text;
			textToaster.alpha = 0.0;
			textToaster.labelOffsetX = labelOffsetX;
			textToaster.labelOffsetY = labelOffsetY;
			//textToaster.includeInLayout = false;
			textToaster.delayToDisplay = delayToDisplay;
			textToaster.delay = delay;
			textToaster.isCentered = isCentered;
			textToaster.anchorBottom = anchorBottom;
			textToaster.topArrowSkin = textToaster.rightArrowSkin = textToaster.bottomArrowSkin = textToaster.leftArrowSkin = null;
			 
			//_this.stage.addChild(textToaster);
			//textToaster.validate();
			PopUpManager.addPopUp( textToaster, false, false );
			return textToaster;
		}
		
		private function callout_show(textToaster:TextToaster, delayToDisplay:Number, delay:Number, start : Number = 0.0, finish : Number = 1.0, transitions : String = Transitions.EASE_OUT) : void
		{
			Starling.juggler.tween (textToaster, delayToDisplay,
			{
				alpha : finish,
				transition : transitions,
				onStart : function () : void
				{			 
					textToaster.alpha = start;
				},
				onComplete : function () : void
				{			 
					if(finish == 1.0) setTimeout(callout_timeout, delay * 1000, textToaster, delayToDisplay, delay);
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
			var _y:Number = ! isNaN( anchorBottom ) ? y : textToaster.y;
			textToaster.move(_x, _y);
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
			//callout_show(textToaster, delay, 0.0, 1.0, Transitions.EASE_OUT);
			if( ! taskManager )
			{
				launch( textToaster, delayToDisplay, delay );
			}
			else if( toasters.length == 1 )
			{
				launch( textToaster, delayToDisplay, delay );
			}
			return textToaster;
		}
		
		private function launch( textToaster:TextToaster, delayToDisplay:Number, delay:Number ):void
		{
			callout_show(textToaster, delayToDisplay, delay, 0.0, 1.0, Transitions.EASE_OUT);
		}
		
		private function callout_timeout():void
		{
			callout_show(arguments[0], arguments[1], arguments[2], 1.0, 0.0, Transitions.EASE_IN);
		}
		
		private function callout_close( textToaster:TextToaster ):void
		{
			toasters.splice( toasters.indexOf( textToaster ), 1 );
			//_this.stage.removeChild(textToaster);
			PopUpManager.removePopUp( textToaster, true );
			textToaster.dispatchEvent( new Event ( Event.COMPLETE ) );
			if( taskManager && toasters.length != 0 )
			{
				var textToaster:TextToaster = toasters[0];
				launch( textToaster, textToaster.delayToDisplay, textToaster.delay );
			}
		}
		
		/**
		 * Indicates whether a toaster is currently playing.
		 */
		public function get isPlaying():Boolean
		{
			return toasters.length != 0 ? true : false;
		}
		
		/**
		 * Disposes all resources of the display object. GPU buffers are released, event listeners are removed, filters and masks are disposed.
		 */
		public function dispose():void
		{
			if(_this.stage)
			{
				_this.stage.removeEventListener(Event.RESIZE, onResize);
				//for each(var textToaster:TextToaster in toasters) _this.stage.removeChild(textToaster);
			}
			//toasters = null;
		}
	}
}