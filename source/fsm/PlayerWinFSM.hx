package fsm;
import entities.Player;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import states.WinState;

/**
 * ...
 * @author Dave
 */
class PlayerWinFSM extends FSMModule 
{
	var p:Player;
	var timer:FlxTimer;
	public function new(parent:IFSM) 
	{
		super(parent);
		p = cast parent;
		timer = new FlxTimer();
	}
	
	
	override public function changeTo() 
	{
		timer.start(2, transform);
		p.velocity.set();
		p.acceleration.set();
	}
	
	private function transform(_) {
		p.arm.visible = false;
		p.animation.play('transform');
		timer.start(.5, travel);
		
	}
	
	function travel(_) {
		var shipMid = H.getShip().getMidpoint();
		p.angle = H.getPlayer().getMidpoint().angleBetween(shipMid);
		p.animation.play('travel');
		FlxTween.tween(p, {x:shipMid.x, y:shipMid.y}, .5, {onComplete:disappear});
	}
	
	function disappear(_) {
		p.animation.play('disappear');
		MM.fadeMusic(3);
		H.signalAll('lightspeed');
		timer.start(3, winState);
	}
	
	function winState(_) {
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {FlxG.switchState(new WinState()); });
	}
	
}