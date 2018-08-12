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
			case 'test':
				level = new Level(45);
				level.name = key;
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(3, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				level.addWave(new Wave(10, 3, EnemyTypes.BIKER));
				//level.addWave(new Wave(15, 3, EnemyTypes.BIKER));
				//level.addWave(new Wave(15, 2, EnemyTypes.BIKER));
				level.addWave(new Wave(15, 2, EnemyTypes.BIKER));

			default:
				level = new Level(5);
				
		}
		
		return level;
	}
	
}