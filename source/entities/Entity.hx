package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import fsm.FSM;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class Entity extends FlxSprite implements IFSM
{

	var fsm:FSM;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		fsm = new FSM(this);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		super.update(elapsed);
		
	}
	
	public function changeFSM(name:String):Void {
		fsm.changeState(name);
	}
}