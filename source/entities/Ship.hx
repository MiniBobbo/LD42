package entities;

import factories.EffectFactory;
import factories.EffectFactory.EffectType;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Ship extends Entity 
{

	var thrustTimer:FlxTimer;
	var THRUST_TIME:Float = .1;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		frames = H.getFrames();
		animation.addByPrefix('ship', 'ship');
		animation.play('ship');
		setSize(100, 80);
		centerOffsets();
		
		thrustTimer = new FlxTimer();
		//toggleThrust();
	}
	
	
	public function toggleThrust(on:Bool = true) {
		thrustTimer.start(THRUST_TIME, function(_) {
			var p = FlxPoint.get();
			getMidpoint(p);
			p.x -= 20;
			p.y -= 10;
			EffectFactory.effect(getMidpoint(), EffectType.LARGE_THRUST); 
			p.put();
		}, 0 );
	}
	
}