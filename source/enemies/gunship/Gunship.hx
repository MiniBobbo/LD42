package enemies.gunship;
import attacks.UnivAttack;
import attacks.UnivAttack.AttackTypes;
import factories.AttackFactory;
import factories.EffectFactory;
import factories.EffectFactory.EffectType;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class Gunship extends Enemy 
{

	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('gunship', 'gunship', 1, false);
		animation.play('gunship');
		setSize(173, 60);
		centerOffsets();
		centerOrigin();
		hp = 80;
		
		minimapColor = FlxColor.YELLOW;
		
		fsm.addtoMap('move', new GunshipMoveFSM(this));
		fsm.addtoMap('dead', new GunshipDeadFSM(this));
		fsm.changeState('move');
		
	}
	
		public function shootShip(repeat:Bool = true) {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.ENEMYSHOT1);
		var p = FlxPoint.get();
		getMidpoint(p);
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getShipMidpoint()));
		p.put();
		if (repeat)
			new FlxTimer().start(.3, shootAgain);
	}
	
	function shootAgain(_) {
		shootShip(false);
	}
	
	
	
	public function fireAtPlayer() {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		var p = FlxPoint.get();
		getMidpoint(p);
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getPlayerMidpoint()));
		p.put();
	
		a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		p = FlxPoint.get();
		getMidpoint(p);
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getPlayerMidpoint()) + 30);
		p.put();

		a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.STUN_SHOT);
		p = FlxPoint.get();
		getMidpoint(p);
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getPlayerMidpoint()) - 30);
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
				//FlxSpriteUtil.flicker(this, .2);
				if (hp <= 0)
					EffectFactory.fgeffect(FlxPoint.weak(x+ width/2, y + width/2), EffectType.EXPLODE);
				
			default:
				
		}
	}
}