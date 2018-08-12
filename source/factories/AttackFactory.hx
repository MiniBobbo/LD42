package factories;
import attacks.UnivAttack;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import haxe.Constraints.Function;

/**
 * ...
 * @author Dave
 */
class AttackFactory 
{
	static var FIRE_UPWARDS_VELOCITY:Float = 150;
	static var ELECTRIC_SPREAD:Float = 40;
	
	
	public static function configAttack(a:UnivAttack, type:AttackTypes) {
		a.setUpdateFunction(null);
		a.setInitFunction(null);
		a.flipX = false;
		a.flipY = false;
		a.type = type;
		switch (type) 
		{
			case AttackTypes.SHOT:
				a.acceleration.set();
				a.setSize(10, 10);
				a.attackDelay = .1;
				a.damage = 1;
				a.inaccuracy = 5;
				a.velocity.set(0, -700);
				a.centerOffsets();
				a.fireAnim = 'shot';
				a.endAnim = 'shotend';
				a.setUpdateFunction(AngleTowardsVelocity);
				a.setCompleteFunction(stopMoving);
				a.setHitFunction(defaultHit);
			case AttackTypes.ENEMYSHOT1:
				a.acceleration.set();
				a.setSize(10, 10);
				a.attackDelay = .1;
				a.damage = 5;
				a.inaccuracy = 30;
				a.velocity.set(0, -200);
				a.centerOffsets();
				a.fireAnim = 'enemyshot1';
				a.endAnim = 'enemyshot1end';
				a.setUpdateFunction(AngleTowardsVelocity);
				a.setCompleteFunction(stopMoving);
				a.setHitFunction(defaultHit);
			default:
		a.inaccuracy = 0;
		a.attackDelay = 1;
				
		}
	}
	
	public static function AngleTowardsVelocity(a:UnivAttack, elapsed:Float):Void {
		a.angle = FlxPoint.weak().angleBetween(a.velocity);
	}


	
	
	public static function stopMoving(a:UnivAttack):Void {
		a.animation.play(a.endAnim);
		a.velocity.set();
		a.acceleration.set();
		a.animation.play(a.endAnim);
		new FlxTimer().start(1, function(_) {a.exists = false; });
		
	}
	
	public static function defaultHit(a:UnivAttack) {
			if (!a.alive)
				return;
			a.alive = false;
			if (a.onComplete == null) {
				a.animation.play(a.endAnim);
				new FlxTimer().start(1, function(_) {a.exists = false; });

			} else {
				a.onComplete(a);
			}
	}
	
	
	public static function printTest(a:UnivAttack):Void {
		trace('Called from a universal attack init');
	}
	
}