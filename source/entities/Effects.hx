package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Effects extends FlxSprite 
{
	var lifespanTimer:FlxTimer;
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('thrust', 'icons_thrust_', 12, false);
		animation.play('thrust');
		kill();
		lifespanTimer = new FlxTimer();
	}
	
	/**
	 * Kills this effect after a given time.
	 * @param	lifetime
	 */
	public function startTimer(lifetime:Float) {
		lifespanTimer.start(lifetime, function(_) {kill(); } );
	}
	
}