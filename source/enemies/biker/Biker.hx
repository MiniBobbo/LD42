package enemies.biker;

import attacks.UnivAttack.AttackTypes;
import factories.AttackFactory;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class Biker extends Enemy 
{

	
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('ride', 'biker_ride_', 12);
		animation.play('ride');
		setSize(70, 35);
		centerOffsets();
		centerOrigin();
		hp = 6;
		
		fsm.addtoMap('move', new BikerMoveFSM(this));
		fsm.addtoMap('attack', new BikerAttackFSM(this));
		fsm.changeState('move');
		
	}

	public function shootShip() {
		var a = H.getEnemyAttack();
		AttackFactory.configAttack(a, AttackTypes.ENEMYSHOT1);
		var p = FlxPoint.get();
		getMidpoint(p);
		p.x -= 15;
		p.y -= 6;
		
		a.initAttack(p, 3);
		a.velocity.rotate(FlxPoint.weak(), p.angleBetween(H.getShip().getMidpoint()));
		p.put();
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	public function fireAtPlayer() {
		var a = H.getEnemyAttack();
		
	}
}