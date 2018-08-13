package enemies.biker;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import fsm.FSMModule;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class BikerShootFSM extends FSMModule 
{
	var MAX_SPEED:Float = 75;
	var DISTANCE_TO_SHOOT:Float = 400;
	var timer:FlxTimer;
	
	var b:ShootBiker;
	public function new(parent:IFSM) 
	{
		super(parent);
		b = cast parent;
		timer = new FlxTimer();
	}
	
	override public function changeTo() 
	{
		super.changeTo();
		timer.start(3, checkDistance, 0);
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
		timer.cancel();
	}
	
	private function checkDistance(_) {
		if (b.getMidpoint().distanceTo(H.getPlayerMidpoint() ) < DISTANCE_TO_SHOOT)
		b.fireAtPlayer();
	}
	
	override public function update(dt:Float) 
	{
		var p = FlxPoint.get(0, -MAX_SPEED);
		p.rotate(FlxPoint.weak(), b.getMidpoint().angleBetween(H.getPlayerMidpoint()));
		b.velocity.copyFrom(p);
		p.put();
		
		

	}
	
}