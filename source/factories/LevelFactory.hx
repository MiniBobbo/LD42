package factories;
import enemies.Enemy.EnemyTypes;
import levels.Level;
import levels.Wave;

/**
 * ...
 * @author Dave
 */
class LevelFactory 
{
	public static function createLevel(key:String):Level{
		var level:Level;
		switch (key) 
		{
		case 'lose' :
				level = new Level(30);
				level.name = key;
				level.addWave(new Wave(3, 30, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 30, EnemyTypes.BIKER));
			
		case 'Getting Started':
				level = new Level(30);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				//level.addWave(new Wave(15, 3, EnemyTypes.BIKER));
				//level.addWave(new Wave(15, 2, EnemyTypes.BIKER));
				level.addWave(new Wave(15, 2, EnemyTypes.BIKER));
		case 'Bikers Attack':
				level = new Level(40);
				level.name = key;
				level.addWave(new Wave(1, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(20, 5, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(20, 5, EnemyTypes.BIKER));
		case 'Onslaught':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(1, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(20, 5, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(20, 15, EnemyTypes.BIKER));
		case 'Drones':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.DRONE));
				level.addWave(new Wave(15, 3, EnemyTypes.DRONE));
				level.addWave(new Wave(30, 3, EnemyTypes.DRONE));
				level.addWave(new Wave(30, 4, EnemyTypes.BIKER));
		case 'Mixed Force':
				level = new Level(35);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.DRONE));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(15, 3, EnemyTypes.DRONE));
				level.addWave(new Wave(20, 3, EnemyTypes.BIKER));
				
		case 'Pyramids':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.PYRAMID));
				level.addWave(new Wave(20, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(25, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(25, 1, EnemyTypes.PYRAMID));
		case 'Incoming':
				level = new Level(50);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.PYRAMID));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(15, 4, EnemyTypes.BIKER));
				level.addWave(new Wave(35, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(35, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(35, 4, EnemyTypes.BIKER));

			
		case 'Gunship':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(3, 1, EnemyTypes.GUNSHIP));
				level.addWave(new Wave(20, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(30, 3, EnemyTypes.BIKER));
		case 'Crazy':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(3, 1, EnemyTypes.GUNSHIP));
				level.addWave(new Wave(3, 1, EnemyTypes.GUNSHIP));
				level.addWave(new Wave(20, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(30, 3, EnemyTypes.BIKER));
				
		case 'Insane':
				level = new Level(70);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.PYRAMID));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(15, 1, EnemyTypes.GUNSHIP));
				level.addWave(new Wave(15, 4, EnemyTypes.BIKER));
				level.addWave(new Wave(35, 3, EnemyTypes.SHOOT_BIKER));
				level.addWave(new Wave(35, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(35, 4, EnemyTypes.BIKER));
			
				
				
		
			default:
				level = new Level(1);
				level.name = key;
				
		}
		
		return level;
	}
	
}