package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import signal.ISignal;

/**
 * ...
 * @author Dave
 */
class CamTarget extends FlxSprite implements ISignal
{

	
	public var followPlayer:Bool = false;
	public function new() 
	{
		super();
		makeGraphic(1, 1, FlxColor.TRANSPARENT);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (followPlayer) {
			var p = H.getPlayer().getMidpoint();
			setPosition(p.x, p.y);
		}
		super.update(elapsed);
	}
	
	public function getSignal(signal:String, ?data:Dynamic):Void {
		
	}

}