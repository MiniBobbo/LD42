package entities;

import attacks.UnivAttack;
import factories.EffectFactory;
import factories.EffectFactory.EffectType;
import flixel.FlxG;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import fsm.ShipDeadFSM;

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
		
		fsm.addtoMap('dead', new ShipDeadFSM(this));
		//toggleThrust();
	}
	
	
	public function toggleThrust(on:Bool = true) {
		if (on) {
		thrustTimer.start(THRUST_TIME, function(_) {
			var p = FlxPoint.get();
			getMidpoint(p);
			p.x -= 20;
			p.y -= 10;
			EffectFactory.effect(getMidpoint(), EffectType.LARGE_THRUST); 
			p.put();
		}, 0 );
			
		} else {
			thrustTimer.cancel();
		}
	}
	
	override public function getSignal(signal:String, ?data:Dynamic):Void 
	{
		switch (signal) 
		{
			case 'lightspeed':
				toggleThrust(false);
				H.levelScore = this.hp;
				trace('Level Score is now ' +H.levelScore);
				thrustTimer.start(1.5, function(_) {
					FlxTween.tween(this, {x:3000}, 1, {ease:FlxEase.elasticInOut});
					FlxG.camera.flash(FlxColor.WHITE, .1);
					SM.play(SM.SoundTypes.SHIPWARP);
				});
			
			case 'hit':
				var a:UnivAttack = cast data;
				FlxSpriteUtil.flicker(this, .2);

				takeDamage(a.damage);
			default:
				
		}
	}
}