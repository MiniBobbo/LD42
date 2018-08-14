package enemies.gunship;

import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import fsm.FSMModule;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class GunshipMoveFSM extends FSMModule 
{

	var g:Gunship;
	var timer1:FlxTimer;
	var timer2:FlxTimer;
	var MAX_SPEED:Float = 35;
	
	var T1_STEP:Float = 4;
	var T2_STEP:Float = 1.5;
	
	var STOP_DIST:Float = 300;
	public function new(parent:IFSM) 
	{
		super(parent);
		g = cast parent;
		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
		timer1.cancel();
		timer2.cancel();
	}
	
	override public function changeTo() 
	{
		super.changeTo();
		timer1.start(T1_STEP, t1, 0);
		timer2.start(T2_STEP, t2, 0);
	}
	
	override public function update(dt:Float) 
	{
		if (g.getMidpoint().distanceTo(H.getShipMidpoint()) > STOP_DIST) {
			//trace('moving towards ship');
			var p = FlxPoint.get(0, -MAX_SPEED);
			p.rotate(FlxPoint.weak(), g.getMidpoint().angleBetween(H.getShip().getMidpoint()));
			g.velocity.copyFrom(p);
			p.put();
		} else {
			//trace('done moving towards ship.  Distance ' + g.getMidpoint().distanceTo(H.getShipMidpoint()));
			g.velocity.set();
		}
	}
	
	function t1(_) {
		g.shootShip();
	}
	
	function t2(_) {
		g.fireAtPlayer();
	}
}