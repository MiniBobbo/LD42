package enemies.biker;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import fsm.FSMModule;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class BikerMoveFSM extends FSMModule 
{

	var MAX_SPEED:Float = 75;
	var DISTANCE_TO_SHOOT:Float = 400;
	var timer:FlxTimer;
	
	var b:Biker;
	public function new(parent:IFSM) 
	{
		super(parent);
		b = cast parent;
		timer = new FlxTimer();
	}
	
	override public function changeTo() 
	{
		super.changeTo();
		timer.start(1, checkDistance, 0);
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
		timer.cancel();
	}
	
	private function checkDistance(_) {
		trace('checking distance');
		if (b.getMidpoint().distanceTo(H.getShip().getMidpoint() ) < DISTANCE_TO_SHOOT)
			parent.changeFSM('attack');
	}
	
	override public function update(dt:Float) 
	{
		var p = FlxPoint.get(0, -MAX_SPEED);
		p.rotate(FlxPoint.weak(), b.getMidpoint().angleBetween(H.getShip().getMidpoint()));
		b.velocity.copyFrom(p);
		p.put();
		
		

	}
	
	
	
	
}