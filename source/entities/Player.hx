package entities;

import factories.EffectFactory;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
import fsm.PlayerMoveFSM;

/**
 * ...
 * @author Dave
 */
class Player extends Entity 
{

	var thrustTimer:FlxTimer;
	var THRUST_TIME:Float = .7;
	
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('forward', 'player_forward_', 1, false);
		animation.addByPrefix('idle', 'player_idle_', 1, false);
		animation.addByPrefix('down', 'player_down_', 1, false);
		animation.addByPrefix('up', 'player_up_', 1, false);
		animation.play('forward');
		setSize(30, 30);
		centerOffsets();
		
		fsm.addtoMap('main', new PlayerMoveFSM(this));
		fsm.changeState('main');
		thrustTimer = new FlxTimer();
	}
	
	public function toggleThrust(on:Bool = true) {
		thrustTimer.start(THRUST_TIME, function(_) {EffectFactory.effect(getMidpoint(), EffectType.THRUST); },0 );
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		H.keepInBounds(this);
	}
	
}