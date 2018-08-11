package fsm;
import entities.Player;
import flixel.FlxG;
import inputhelper.InputHelper;

/**
 * ...
 * @author Dave
 */
class PlayerMoveFSM extends FSMModule 
{
	var p:Player;
	var DRAG:Float = 300;
	var MAX_SPEED:Float = 200;
	var ACCEL:Float = 300;
	var ACCEL_MULT:Float = 3;
	
	
	public function new(parent:IFSM) 
	{
		super(parent);
		p = cast parent;
	}
	
	override public function changeTo() 
	{
		p.drag.set(DRAG, DRAG);
		p.maxVelocity.set(MAX_SPEED, MAX_SPEED);
	}
	
	override public function update(dt:Float) 
	{
		p.acceleration.set();
		var i = InputHelper;
		if (i.isButtonPressed('up')){
			p.acceleration.y -= ACCEL;
			if (p.velocity.y > 0)
			p.acceleration.y *= ACCEL_MULT;
		}
		if (i.isButtonPressed('down')) {
			p.acceleration.y += ACCEL;
			if (p.velocity.y < 0)
				p.acceleration.y *= ACCEL_MULT;

		}
		if (i.isButtonPressed('left')) {
			p.acceleration.x -= ACCEL;
			if (p.velocity.x > 0)
			p.acceleration.x *= ACCEL_MULT;
		}
		if (i.isButtonPressed('right')) {
			p.acceleration.x += ACCEL;
			if (p.velocity.x < 0)
			p.acceleration.x *= ACCEL_MULT;
			
		}
	
		if (FlxG.mouse.pressed) {
			p.shoot();
		}
		
		updateAnimation();
	}
	
	private function updateAnimation() {
		var tempAngle = p.getMidpoint().angleBetween(FlxG.mouse.getWorldPosition());
		if (tempAngle < 0)
			p.flipX = false;
		else
			p.flipX = true;
		
		p.arm.angle = tempAngle;	
		if (Math.abs(tempAngle) < 45)
			p.animation.play('up');
		else if (Math.abs(tempAngle) < 135)
			p.animation.play('forward');
		else
			p.animation.play('down');
		
	}
	
	
}