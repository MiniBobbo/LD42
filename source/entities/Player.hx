package entities;

import attacks.UnivAttack.AttackTypes;
import factories.AttackFactory;
import factories.EffectFactory;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
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
	var THRUST_TIME:Float = .1;
	var attackDelay:Float;
	
	var attack:AttackTypes;
	
	public var arm:FlxSprite;
	private var attackOffset:FlxPoint;
	
	public function new() 
	{
		super();
		attack = AttackTypes.SHOT;
		attackOffset = new FlxPoint(0, -20);
		
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
		toggleThrust();
	}
	
	public function registerArm(arm:FlxSprite) {
		this.arm = arm;
	}
	
	public function toggleThrust(on:Bool = true) {
		thrustTimer.start(THRUST_TIME, function(_) {EffectFactory.effect(getMidpoint(), EffectType.THRUST); },0 );
	}
	
	override public function update(elapsed:Float):Void 
	{
		attackDelay -= elapsed;
		super.update(elapsed);
		H.keepInBounds(this);
		arm.setPosition(x, y);
	}
	
	public function shoot() {
		if (attackDelay > 0)
		return;
		var a = H.getPlayerAttack();
		AttackFactory.configAttack(a, attack);
		
		//Find the location we should spawn the shot.
		var p = FlxPoint.get().copyFrom(attackOffset);
		p.rotate(FlxPoint.weak(), arm.angle);
		var mp = getMidpoint();
		p.x += mp.x;
		p.y += mp.y;
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), arm.angle + FlxG.random.float(-a.inaccuracy, a.inaccuracy) );
		
		attackDelay = a.attackDelay;
	}
	
}