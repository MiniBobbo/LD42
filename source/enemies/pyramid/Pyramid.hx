package enemies.pyramid;

import attacks.UnivAttack;
import attacks.UnivAttack.AttackTypes;
import enemies.Enemy;
import factories.AttackFactory;
import factories.EffectFactory;
import flixel.FlxG;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Pyramid extends Enemy 
{
	var timer:FlxTimer;
	var ACCEL:Float = 600;
	var MAX_SPEED:Float = 30;
	
	var TELEPORT_DISTANCE:Float = 200;
	
	var FIRE_DISTANCE:Float = 700;
	var STOP_DISTANCE:Float = 700;
	
	var SHOT_SPEED:Float = 150;
	
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('normal', 'pyramid_normal_', 12, true);
		animation.addByPrefix('fire', 'pyramid_normal_', 30, true);
		animation.play('normal');
		
		setSize(40, 40);
		maxVelocity.set(MAX_SPEED, MAX_SPEED);
		centerOffsets();
		centerOrigin();
		hp = 30;
	
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
			teleport();
		} else {
			var mult = 1;
			if (FlxG.random.bool())
				mult = -1;
			acceleration.set(0, - ACCEL);
			acceleration.rotate(FlxPoint.weak(), anglebetween + (90*mult));
			
			
		}
		
	}
	
	function teleport() {
		FlxG.camera.flash(FlxColor.WHITE, .1);
		var p = FlxPoint.get(0, -TELEPORT_DISTANCE);
		var pmid = H.getPlayerMidpoint();
		p.rotate(FlxPoint.weak(), FlxG.random.float(-180,180));
		setPosition(pmid.x + p.x, pmid.y + p.y);
		
		p.put();
	}
	
	function fire(ang:Float) {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var shotvel = FlxPoint.weak(0, -SHOT_SPEED);
		shotvel.rotate(FlxPoint.weak(), ang);
		a.velocity.copyFrom(shotvel);
		a.initAttack(getMidpoint(), 8);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		if (alive) {
			if (velocity.x < 0) 
				angle -= 4;
			if (velocity.x > 0)
				angle += 4;
				
			if (angle < -45 )
			angle = -45;
			if (angle > 45)
			angle = 45;
			
		}
		super.update(elapsed);
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