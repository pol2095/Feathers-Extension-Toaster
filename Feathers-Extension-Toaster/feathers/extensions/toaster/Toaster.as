/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import feathers.core.PopUpManager;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
		
	/**
	 * A toaster provides simple feedback about an operation in a small popup.
	 *
	 * @see http://pol2095.free.fr/Starling-Feathers-Extensions/
	 * @see feathers.extensions.toaster.ToasterRenderer
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
		}
		
		/**
		 * The toasters added on the stage.
		 */
		protected var toasters:Vector.<Object>;
		
		private var root:Object;
				
		private function get stage():Stage
		{
			return root.stage;
		}
		
		private var _starling:Starling;
		private function get starling():Starling
		{
			if( ! _starling ) _starling = stage.starling;
			return _starling;
		}
		
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
		
		private var ToasterRenderer:Class;
		/**
		 * The class used to instantiate toaster renderer.
		 */
		public function set toasterRenderer(value:Object):void
		{
			if( ! (value is Class) ) value = getDefinitionByName(value as String);
			if( ToasterRenderer == value ) return;
			ToasterRenderer = value as Class;
		}
		
		/**
		 * The default background to display behind all content. The background
		 * skin is resized to fill the full width and height of the layout
		 * group.
		 *
		 * <p>In the following example, the group is given a background skin:</p>
		 *
		 * <listing version="3.0">
		 * group.backgroundSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #style:backgroundDisabledSkin
		 */
		public var backgroundSkin:Image;
		
		public function Toaster(root:Object)
        {
			//this.includeInLayout = false;
			this.root = root;
			//this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		
		/*private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			root.stage.addEventListener(Event.RESIZE, onResize);
        }*/
		
		private function onResize(event:Event):void
        {
			if( ! stage ) return;
			for each(var toasterRenderer:Object in toasters)
			{
				if( ! toasterRenderer.isCreated ) return;
				var _y:Number;
				if(toasterRenderer.isCentered)
				{
					var _x:Number = (stage.stageWidth - toasterRenderer.width) / 2;
					if( ! isNaN( toasterRenderer.anchorBottom ) )
					{
						_y = stage.stageHeight - toasterRenderer.anchorBottom - toasterRenderer.height;
					}
					else
					{
						_y = toasterRenderer.y
					}
					toasterRenderer.move(_x, _y);
				}
				else if( ! isNaN( toasterRenderer.anchorBottom ) )
				{
					_y = stage.stageHeight - toasterRenderer.anchorBottom - toasterRenderer.height;
					toasterRenderer.move(toasterRenderer.x, _y);
				}
			}
		}
		
		private function createCallout():Object
		{
			var toasterRenderer:Object = new ToasterRenderer();
			toasterRenderer.addEventListener(Event.RESIZE, onResize);
			if(!toasters) toasters = new <Object>[];
			toasters.push( toasterRenderer );
			toasterRenderer.alpha = 0.0;
			if( backgroundSkin ) toasterRenderer.backgroundSkin = backgroundSkin;
			toasterRenderer.offsetX = offsetX;
			toasterRenderer.offsetY = offsetY;
			//toasterRenderer.includeInLayout = false;
			toasterRenderer.delayToDisplay = delayToDisplay;
			toasterRenderer.delay = delay;
			toasterRenderer.isCentered = isCentered;
			toasterRenderer.anchorBottom = anchorBottom;
			 
			//stage.addChild(toasterRenderer);
			//toasterRenderer.validate();
			starling.makeCurrent();
			PopUpManager.addPopUp( toasterRenderer as DisplayObject, false, false );
			return toasterRenderer;
		}
		
		private function callout_show(toasterRenderer:Object, delayToDisplay:Number, delay:Number, start : Number = 0.0, finish : Number = 1.0, transitions : String = Transitions.EASE_OUT) : void
		{
			Starling.juggler.tween (toasterRenderer, delayToDisplay,
			{
				alpha : finish,
				transition : transitions,
				onStart : function () : void
				{			 
					toasterRenderer.alpha = start;
				},
				onComplete : function () : void
				{			 
					if(finish == 1.0) setTimeout(callout_timeout, delay * 1000, toasterRenderer, delayToDisplay, delay);
					if(finish == 0.0) callout_close( toasterRenderer );
				}
			});
		}
		
		/**
		 * Move the toaster to the specified position.
		 *
		 * @param toasterRenderer A ToasterRenderer control
		 *
		 * @param x The horizontal coordinate
		 *
		 * @param y The vertical coordinate
		 */
		public function moveTo( toasterRenderer:Object, x:Number, y:Number ):void
		{
			var _x:Number = ! toasterRenderer.isCentered ? x : toasterRenderer.x;
			var _y:Number = ! isNaN( anchorBottom ) ? y : toasterRenderer.y;
			toasterRenderer.move(_x, _y);
		}
		
		/**
		 * Add a toaster to the stage.
		 *
		 * @param text Text of the toaster
		 */
		public function open():Object
		{
			if( ! stage.hasEventListener(Event.RESIZE, onResize) ) stage.addEventListener(Event.RESIZE, onResize);
			var toasterRenderer:Object = createCallout();
			//callout_show(toasterRenderer, delay, 0.0, 1.0, Transitions.EASE_OUT);
			if( ! taskManager )
			{
				launch( toasterRenderer, delayToDisplay, delay );
			}
			else if( toasters.length == 1 )
			{
				launch( toasterRenderer, delayToDisplay, delay );
			}
			return toasterRenderer;
		}
		
		private function launch( toasterRenderer:Object, delayToDisplay:Number, delay:Number ):void
		{
			callout_show(toasterRenderer, delayToDisplay, delay, 0.0, 1.0, Transitions.EASE_OUT);
		}
		
		private function callout_timeout():void
		{
			callout_show(arguments[0], arguments[1], arguments[2], 1.0, 0.0, Transitions.EASE_IN);
		}
		
		private function callout_close( toasterRenderer:Object ):void
		{
			toasters.splice( toasters.indexOf( toasterRenderer ), 1 );
			//stage.removeChild(toasterRenderer);
			toasterRenderer.removeEventListener(Event.RESIZE, onResize);
			starling.makeCurrent();
			PopUpManager.removePopUp( toasterRenderer as DisplayObject, true );
			toasterRenderer.dispatchEvent( new Event ( Event.COMPLETE ) );
			if( taskManager && toasters.length != 0 )
			{
				var toasterRenderer:Object = toasters[0];
				launch( toasterRenderer, toasterRenderer.delayToDisplay, toasterRenderer.delay );
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
			if(stage)
			{
				stage.removeEventListener(Event.RESIZE, onResize);
				//for each(var toasterRenderer:Object in toasters) stage.removeChild(toasterRenderer);
			}
			//toasters = null;
		}
	}
}