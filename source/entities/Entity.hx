package entities;

import enemies.Enemy.EnemyTypes;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import fsm.DeadFSM;
import fsm.FSM;
import fsm.IFSM;
import fsm.StopFSM;
import signal.ISignal;

/**
 * ...
 * @author Dave
 */
class Entity extends FlxSprite implements IFSM implements ISignal
{

	var hp:Float = -1;
	
	var fsm:FSM;
	public var type:EnemyTypes;
	
	public var minimapColor:FlxColor;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		fsm = new FSM(this);
		fsm.addtoMap('dead', new DeadFSM(this) );
		fsm.addtoMap('stop', new StopFSM(this) );
		minimapColor = FlxColor.WHITE;
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
			fsm.changeState('dead');
		}
	}
	
	public function getSignal(signal:String, ?data:Dynamic):Void {
		switch (signal) 
		{
			case 'stop':
				fsm.hold();
			default:
				
		}
	}
	
	public function setHP(hp:Float) {
		this.hp = hp;
	}

}