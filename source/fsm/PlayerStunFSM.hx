package fsm;
import entities.Player;

/**
 * ...
 * @author Dave
 */
class PlayerStunFSM extends FSMModule 
{

	var p:Player;
	public function new(parent:IFSM) 
	{
		super(parent);
		p = cast parent;
	}
	
	override public function changeFrom() 
	{
		super.changeFrom();
		p.arm.visible = true;
		p.stunned = false;
		p.makeInvincible();
	}
	
	override public function changeTo() 
	{
		super.changeTo();
		p.arm.visible = false;
		p.animation.play('dead');
		p.stunned = true;
	}
	
	override public function update(dt:Float) 
	{
		p.stunTime -= dt;
		if (p.stunTime <= 0) {
			parent.changeFSM('main');
		}
			
	}
	
}