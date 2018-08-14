package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import signal.ISignal;

/**
 * ...
 * @author Dave
 */
class Bar extends FlxSpriteGroup implements ISignal
{
	var maxValue:Float;
	var currentValue:Float;
	//The width of the bar in pixels
	public var barWidth(default, null) :Int = 300;
	var bar:FlxBar;
	
	/**
	 * Creates a new bar that tracks a specific value.
	 * @param	object		The object to track.
	 * @param	field		The field in the object.  
	 */
	public function new(parentRef:Dynamic, variable:String, maxValue:Float) 
	{
		super();
		var b1 = new FlxSprite();
		b1.frames = H.getFrames();
		b1.animation.frameName = 'ShipHealthBar_0';
		b1.setSize(100, 20);
		b1.centerOffsets();
		b1.scrollFactor.set();
		
		bar  = new FlxBar(1, 1, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(b1.width-2), 18, parentRef, variable, 0, maxValue, true);
		bar.createColoredEmptyBar(FlxColor.TRANSPARENT);
		bar.createColoredFilledBar(FlxColor.GREEN);
		bar.scrollFactor.set();
		add(bar);
		
		add(b1);
	}
	
	public function setBarColor(color:FlxColor) {
		bar.createColoredFilledBar(color);
	}
	
	public function getSignal(signal:String, ?data:Dynamic):Void {
		//if (signal != 'shipdamaged')
		//return;
		//
		//var damage:Float = cast data;
		
		
	}

}