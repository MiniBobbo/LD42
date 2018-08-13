package factories;
import enemies.Enemy;
import enemies.Enemy.EnemyTypes;
import enemies.biker.Biker;
import enemies.biker.ShootBiker;
import enemies.drone.Drone;
import enemies.pyramid.Pyramid;

/**
 * ...
 * @author Dave
 */
class EnemyFactory 
{

	public static function createEnemy(type:EnemyTypes):Enemy {
		var e:Enemy;
		switch (type) 
		{
			case EnemyTypes.BIKER:
				e = new Biker();
			case EnemyTypes.DRONE:
				e = new Drone();
			case EnemyTypes.PYRAMID:
				e = new Pyramid();
			case EnemyTypes.SHOOT_BIKER:
				e = new ShootBiker();
			default:
				
		}
		
		H.gs.signalable.push(e);
		H.gs.hud.registerOntoMinimap(e);
		return e;
	}
	
}