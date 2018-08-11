package enemies.biker;

import flixel.FlxG;
import flixel.util.FlxTimer;
import fsm.FSMModule;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class BikerAttackFSM extends FSMModule 
{
	var b:Biker;
	
	var shotDelay:Float = 0;
	
	var SHOT_DELAY_MIN:Float = 1.3;
	var SHOT_DELAY_MAX:Float = 1.3;
	
	public function new(parent:IFSM) 
	{
		super(parent);
		b = cast parent;
	}
	
	override public function changeTo() 
	{
		b.velocity.set();
		shotDelay = FlxG.random.float(SHOT_DELAY_MIN, SHOT_DELAY_MAX);
		super.changeTo();
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
	}
	
	override public function update(dt:Float) 
	{
		shotDelay -= dt;
		if (shotDelay < 0)
			shoot();
		super.update(dt);
	}
	
	private function shoot() {
		shotDelay = FlxG.random.float(SHOT_DELAY_MIN, SHOT_DELAY_MAX);
		b.shootShip();
		
	}
	
}