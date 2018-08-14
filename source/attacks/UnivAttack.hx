package attacks;

import entities.Entity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import format.swf.data.consts.SoundType;

enum AttackTypes {
	SHOT;
	SHOTGUN;
	ENEMYSHOT1;
	STUN_SHOT;
}

/**
 * ...
 * @author Dave
 */
class UnivAttack extends FlxSprite 
{
	public var onUpdate:UnivAttack->Float->Void;
	public var onInit:UnivAttack->Void;
	public var onComplete:UnivAttack->Void;
	public var onHit:UnivAttack->Void;
	
	public var fireAnim:String;
	public var endAnim:String;
	
	public var hitShip:Bool = false;
	public var hitPlayer:Bool = false;
	
	public var soundFX:SM.SoundTypes;
	public var endFX:SM.SoundTypes;
	
	//How long between attacks?
	public var attackDelay:Float = 1;
	public var type:AttackTypes;
	
	public var damage:Float = 1;
	
	//The inaccuracy is how many degrees + or - the shot can be off.
	public var inaccuracy:Float = 0;
	
	public var lifespan:Float;
	public function new(lifespan:Float=3) 
	{
		super();
		this.lifespan = lifespan;
		
		setupAnimations();
		
		onHit = defaultOnHit;
		
		soundFX = SM.SoundTypes.NONE;
		endFX = SM.SoundTypes.NONE;
	}
	
	private function setupAnimations() {
		frames = H.getFrames();
		animation.addByPrefix('shot', 'attacks_shot_start_', 12, false);
		animation.addByPrefix('shotend', 'attacks_shot_end_', 12, false);
		animation.addByPrefix('enemyshot1', 'attacks_enemyshot1_start_', 12, false);
		animation.addByPrefix('enemyshot1end', 'attacks_enemyshot1_end_', 12, false);
		animation.addByPrefix('stunshot1', 'attacks_enemystunshot_start', 12, false);
		animation.addByPrefix('stunshot1end', 'attacks_enemystunshot_end_', 12, false);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (onUpdate != null) {
			onUpdate(this, elapsed);
		}
		 
	}
	
	public function setHitboxSize(type:AttackTypes) {
		switch (type) 
		{
			case AttackTypes.SHOT:
				setSize(10,10);
				
			default:
				setSize(10, 10);
		}
	}
	/**
	 * Resets an attacks parameters.  This should be called every time the attack is used
	 * @param	p the point this attack should appear.
	 * @param	v Velocity that this attack should travel.
	 * @param	lifespan Lifespan of the attack.
	 * @param 	The type of attack
	 */
	public function initAttack(p:FlxPoint, lifespan:Float) {
		SM.play(soundFX);
		ID = FlxG.random.int();
		visible = true;
		//Grab a temp copy of velocity.  It was set in the Factory but will be wiped out by the reset call and we need to put it back.
		var tempVel:FlxPoint = FlxPoint.get().copyFrom(velocity);
		reset(p.x - width / 2, p.y - height / 2);
		velocity.copyFrom(tempVel);
		tempVel.put();
		maxVelocity.set(1000, 1000);
		this.lifespan = lifespan;
		if(onInit != null)
			onInit(this);
		else {
			animation.play(fireAnim);
			centerOffsets();
		}

	}
	
	
	public function setUpdateFunction(f:UnivAttack->Float->Void) {
		onUpdate = f;
		
	}
	public function setInitFunction(f:UnivAttack->Void) {
		onInit = f;
	}
	public function setHitFunction(f:UnivAttack->Void) {
		onHit = f;
	}

	public function setCompleteFunction(f:UnivAttack->Void) {
		onComplete = f;
	}
	public function hitEntity(e:Entity) 
	{
		onHit(this);
	}
	 
	public function defaultOnHit(a:UnivAttack) {
		if (!alive)
			return;
		alive = false;
		if (onComplete == null) {
			SM.play(SM.SoundTypes.LASERHIT);
			animation.play(endAnim);
			new FlxTimer().start(1, function(_) {exists = false; });

		} else {
			onComplete(this);
		}
	}
	
	
}