package entities;

import attacks.UnivAttack;
import attacks.UnivAttack.AttackTypes;
import factories.AttackFactory;
import factories.EffectFactory;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import fsm.PlayerMoveFSM;
import fsm.PlayerStunFSM;
import fsm.PlayerWinFSM;

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
	
	public var stunTime:Float;
	
	public var stunned:Bool = false;
	
	public var arm:FlxSprite;
	public var shield:FlxSprite;
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
		animation.addByPrefix('transform', 'player_transform_', 12, false);
		animation.addByPrefix('travel', 'player_travel_', 30);
		animation.addByPrefix('dead', 'player_dead_', 30, false);
		animation.addByPrefix('disappear', 'player_disappear_', 20, false);
		
		animation.play('forward');
		setSize(30, 30);
		centerOffsets();
		
		fsm.addtoMap('main', new PlayerMoveFSM(this));
		fsm.addtoMap('stun', new PlayerStunFSM(this));
		fsm.addtoMap('win', new PlayerWinFSM(this));
		fsm.changeState('main');
		thrustTimer = new FlxTimer();
		toggleThrust();
	}
	
	public function registerArm(arm:FlxSprite) {
		this.arm = arm;
	}
	
	public function registeShield(shield:FlxSprite) {
		this.shield = shield;
	}
	
	public function makeInvincible(time:Float = 1) {
		FlxSpriteUtil.flicker(this, time);
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
		shield.setPosition(x-16, y-16);
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
	
	override public function getSignal(signal:String, ?data:Dynamic):Void 
	{
		switch (signal) 
		{
			case 'victory':
				fsm.changeState('win');
				thrustTimer.cancel();
			case 'stop':
				fsm.hold();
			case 'shield':
				shield.animation.play('shield');
				SM.play(SM.SoundTypes.SHIELD_BLOCK);
			case 'stun':
				var a:UnivAttack = cast data;
				FlxSpriteUtil.flicker(this, a.damage );
				SM.play(SM.SoundTypes.PLAYER_HIT);
				stunTime = a.damage;
				fsm.changeState('stun');
			
			default:
				
		}
	}
	
}