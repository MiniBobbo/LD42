package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxSpriteUtil;
import fsm.FSM;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class Entity extends FlxSprite implements IFSM
{

	var hp:Float = -1;
	
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
	
	public function takeDamage(damage:Float) {
		if (hp == -1)
			return;
			
		hp -= damage;
		if (hp <= 0) {
			this.alive = false;
			FlxSpriteUtil.fadeOut(this, 1, function(_) { this.exists = false; });
		}
	}
}