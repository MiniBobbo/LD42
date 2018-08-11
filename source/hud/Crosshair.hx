package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Crosshair extends FlxSprite 
{

	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('flash', 'crosshair_flash_', 12);
		animation.play('flash');
		setSize(32, 32);
		offset.set(16,16);
	}
	
	override public function update(elapsed:Float):Void 
	{
		var p = FlxPoint.get();
		FlxG.mouse.getPosition(p);
		x = p.x;
		setPosition(p.x, p.y);
		super.update(elapsed);
	}
	
}