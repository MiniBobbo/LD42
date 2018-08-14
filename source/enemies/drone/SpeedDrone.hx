package enemies.drone;
import attacks.UnivAttack.AttackTypes;
import factories.AttackFactory;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Dave
 */
class SpeedDrone extends Drone 
{

	//How many times should this ship fire in a row
	var FIRE_COUNT:Int = 4;
	
	//Time between the attacks.
	var FIRE_DELAY_BETWEEN:Float = .3;
	public function new() 
	{
		super();
		MAX_SPEED = 300;
	}
	
	override function fire(ang:Float) 
	{
		modFire(ang, 0);
	}
	
	function modFire(ang:Float, count:Int) {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var shotvel = FlxPoint.weak(0, -SHOT_SPEED);
		shotvel.rotate(FlxPoint.weak(), ang);
		a.velocity.copyFrom(shotvel);
		a.initAttack(getMidpoint(), 8);
		count++;
		if (count <= FIRE_COUNT)
			modFire(ang, count);
	}
	
	
}