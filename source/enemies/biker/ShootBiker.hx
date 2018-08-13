package enemies.biker;

import attacks.UnivAttack;
import attacks.UnivAttack.AttackTypes;
import enemies.Enemy;
import factories.AttackFactory;
import factories.EffectFactory;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Dave
 */
class ShootBiker extends Enemy 
{

	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('ride', 'shootbiker_ride_0', 12);
		animation.play('ride');
		setSize(70, 35);
		centerOffsets();
		centerOrigin();
		hp = 6;
		
		fsm.addtoMap('move', new BikerShootFSM(this));
		fsm.changeState('move');
		
	}

	public function shootShip() {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var p = FlxPoint.get();
		getMidpoint(p);
		p.x -= 15;
		p.y -= 6;
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getPlayerMidpoint()));
		p.put();
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	public function fireAtPlayer() {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var p = FlxPoint.get();
		getMidpoint(p);
		p.x -= 15;
		p.y -= 6;
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getPlayerMidpoint()));
		p.put();
	}
	
	override public function getSignal(signal:String, ?data:Dynamic):Void 
	{
		super.getSignal(signal, data);
		switch (signal) 
		{
			case 'hit':
				var a:UnivAttack = cast data;
				takeDamage(a.damage);
				FlxSpriteUtil.flicker(this, .2);
				if (hp <= 0)
					EffectFactory.fgeffect(FlxPoint.weak(x+ width/2, y + width/2), EffectType.EXPLODE);
				
			default:
				
		}
	}	
}