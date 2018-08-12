package fsm;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class ShipDeadFSM extends FSMModule 
{

	public function new(parent:IFSM) 
	{
		super(parent);
	}
	
	override public function changeTo() 
	{
		H.signalAll('defeat');
		FlxG.camera.flash(FlxColor.RED, .4);
	}
	
}