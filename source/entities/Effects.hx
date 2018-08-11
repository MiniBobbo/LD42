package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Effects extends FlxSprite 
{

	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('thrust', 'icons_thrust_', 12, false);
		animation.play('thrust');
		kill();
		
	}
	
}