package entities;

import attacks.UnivAttack;
import factories.EffectFactory;
import factories.EffectFactory.EffectType;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Ship extends Entity 
{

	var thrustTimer:FlxTimer;
	var THRUST_TIME:Float = .1;

	var SHIP_HP:Float = 100;
	var colorTween:FlxTween;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		frames = H.getFrames();
		animation.addByPrefix('ship', 'ship');
		animation.play('ship');
		setSize(100, 80);
		centerOffsets();
		centerOrigin();
		hp = SHIP_HP;
		
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
	
	override public function getSignal(signal:String, ?data:Dynamic):Void 
	{
		switch (signal) 
		{
			case 'hit':
				var a:UnivAttack = cast data;
				FlxSpriteUtil.flicker(this, .2);

				takeDamage(a.damage);
			default:
				
		}
	}
}