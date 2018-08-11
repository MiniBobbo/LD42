package factories;
import enemies.Enemy;
import enemies.Enemy.EnemyTypes;
import enemies.biker.Biker;

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
			default:
				
		}
		
		return e;
	}
	
}