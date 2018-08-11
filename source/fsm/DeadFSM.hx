package fsm;
import entities.Entity;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class DeadFSM extends FSMModule 
{
	
	var e:Entity;
	var timer:FlxTimer;
	
	var FORWARD_BOOST:Float = 300;
	var BACKWARDS_ACCEL:Float = 1000;
	
	var ANGLE_STEP:Float = 15;
	
	public function new(parent:IFSM) 
	{
		super(parent);
		e = cast parent;
		timer = new FlxTimer();
	}
	
	override public function changeTo() 
	{
		e.velocity.x = FORWARD_BOOST;
		e.acceleration.set( -BACKWARDS_ACCEL, 0);
		timer.start(3, finish);
		e.maxVelocity.set(1000, 1000);
	}
	
	override public function update(dt:Float) 
	{
		e.angle += ANGLE_STEP;
		
	}

	private function finish(_) {
		e.exists = false;
	}
	
	
	
	
}