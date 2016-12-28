/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.toaster
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.animation.Transitions;
	
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
		
		/**
		 * The toasters added on the stage.
		 */
		public var toasters:Vector.<TextToaster>;
		
		public function Toaster()
        {
			this.includeInLayout = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize);
        }
		
		private function onResize(event:Event = null):void
        {
			if(isCentered)
			{
				for each(var textToaster:TextToaster in toasters)
				{
					var _x:Number = (stage.stageWidth - textToaster.width) / 2;
					var _y:Number = (stage.stageHeight - textToaster.height) / 2;
					textToaster.move (_x, _y);
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
			textToaster.includeInLayout = false;
			textToaster.topArrowSkin = textToaster.rightArrowSkin = textToaster.bottomArrowSkin = textToaster.leftArrowSkin = null;
			 
			if(isCentered) textToaster.validate();
			stage.addChild(textToaster);
			
			return textToaster;
		}
		
		private function callout_show(textToaster:TextToaster, start : Number = 0.0, finish : Number = 1.0, transitions : String = Transitions.EASE_OUT) : void
		{
			Starling.juggler.tween (textToaster, 1.0,
			{
				alpha : finish,
				transition : Transitions.EASE_OUT,
				onStart : function () : void
				{			 
					textToaster.alpha = start;
				},
				onComplete : function () : void
				{			 
					if(finish == 1.0) setTimeout(callout_timeout, 1000, textToaster);
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
			textToaster.move(x, y);
		}
		
		/**
		 * Add a toaster to the stage.
		 *
		 * @param text Text of the toaster
		 */
		public function open( text:String ):void
		{
			var textToaster:TextToaster = createCallout(text);
			callout_show(textToaster, 0.0, 1.0, Transitions.EASE_OUT);
			if(isCentered)
			{
				var _x:Number = (stage.stageWidth - textToaster.width) / 2;
				var _y:Number = (stage.stageHeight - textToaster.height) / 2;
				textToaster.move (_x, _y);
			}
		}
		
		private function callout_timeout():void
		{
			callout_show(arguments[0], 1.0, 0.0, Transitions.EASE_IN);
		}
		
		private function callout_close( textToaster:TextToaster ):void
		{
			toasters.splice( toasters.indexOf( textToaster ), 1 );
			stage.removeChild(textToaster);
		}
		
		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(stage)
			{
				stage.removeEventListener(Event.RESIZE, onResize);
				for each(var textToaster:TextToaster in toasters) stage.removeChild(textToaster);
			}
			toasters = null;
			
			super.dispose();
		}
	}
}