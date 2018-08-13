package enemies.drone;

import attacks.UnivAttack;
import enemies.Enemy;
import factories.AttackFactory;
import factories.EffectFactory;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Drone extends Enemy 
{

	var timer:FlxTimer;
	var ACCEL:Float = 600;
	var MAX_SPEED:Float = 100;
	
	var FIRE_DISTANCE:Float = 700;
	var STOP_DISTANCE:Float = 400;
	
	var SHOT_SPEED:Float = 200;
	
	
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.frameName = 'shooter_main_0';
		setSize(50, 30);
		maxVelocity.set(MAX_SPEED, MAX_SPEED);
		centerOffsets();
		centerOrigin();
		hp = 10;
	
		drag.set(1000,1000);
		timer = new FlxTimer();
		timer.start(1.5, logic, 0);
	}

	function logic(_) {
		var pmid = H.getPlayerMidpoint();
		var dist = getMidpoint().distanceTo(pmid);
		var anglebetween = getMidpoint().angleBetween(pmid);

		if (dist < FIRE_DISTANCE) {
			fire(anglebetween);
		}
		
		if (dist > STOP_DISTANCE) {
			acceleration.set(0, - ACCEL);
			acceleration.rotate(FlxPoint.weak(), anglebetween);
		} else {
			var mult = 1;
			if (FlxG.random.bool())
				mult = -1;
			acceleration.set(0, - ACCEL);
			acceleration.rotate(FlxPoint.weak(), anglebetween + (90*mult));
			
			
		}
		
	}
	
	
	function fire(ang:Float) {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var shotvel = FlxPoint.weak(0, -SHOT_SPEED);
		shotvel.rotate(FlxPoint.weak(), ang);
		a.velocity.copyFrom(shotvel);
		a.initAttack(getMidpoint(), 8);
	}
	
	
	override public function getSignal(signal:String, ?data:Dynamic):Void 
	{
		super.getSignal(signal, data);
		switch (signal) 
		{
			case 'hit':
				var a:UnivAttack = cast data;
				takeDamage(a.damage);
				FlxSpriteUtil.flicker(this, .2);
				if (hp <= 0) {
					timer.cancel();
					EffectFactory.fgeffect(FlxPoint.weak(x+ width/2, y + width/2), EffectType.EXPLODE);
				}
				
			default:
				
		}
	}
	
}