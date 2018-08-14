package enemies.gunship;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import fsm.FSMModule;
import fsm.IFSM;

class GunshipDeadFSM extends FSMModule 
{
	var g:Gunship;
	var DEAD_TIME:Float = 5;
	var ALIVE_HP:Float = 30;
	var timer:FlxTimer;
	var BACK_VEL:Float = 35;
	
	public function new(parent:IFSM) 
	{
		super(parent);
		g = cast parent;
		timer = new FlxTimer();
	}
	
	override public function changeTo() 
	{
		trace('GunshipDeadState');
		super.changeTo();
		g.setHP(-1);
		FlxSpriteUtil.flicker(g, DEAD_TIME);
		timer.start(DEAD_TIME, backAlive);
		g.velocity.set( -BACK_VEL, 0);
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
		timer.cancel();
	}
	
	function backAlive(_) {
		g.setHP(ALIVE_HP);
		g.alive = true;
		parent.changeFSM('move');
	}
}