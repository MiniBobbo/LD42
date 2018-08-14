package factories;
import enemies.Enemy;
import enemies.Enemy.EnemyTypes;
import enemies.biker.Biker;
import enemies.biker.ShootBiker;
import enemies.drone.Drone;
import enemies.gunship.Gunship;
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
			case EnemyTypes.GUNSHIP:
				if (MM.currentMusic != MM.MusicTypes.PURSUER)
				MM.play(MM.MusicTypes.PURSUER);
				e = new Gunship();
			default:
				
		}
		
		e.type = type;
		H.gs.signalable.push(e);
		H.gs.hud.registerOntoMinimap(e);
		return e;
	}
	
}