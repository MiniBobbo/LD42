package levels;
import enemies.Enemy;
import enemies.Enemy.EnemyTypes;
import factories.EnemyFactory;
import flixel.FlxG;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Dave
 */
class Wave 
{

	public var spawned:Bool = false;
	public var enemyCount:Int;
	public var enemyType:EnemyTypes;
	public var spawnPosition:FlxPoint;
	public var timeToSpawn:Float;
	
	public var enemies:Array<Enemy>;
	
	public function new() 
	{
		enemies = [];
		spawnPosition = new FlxPoint();
	}
	
	public function spawnWave():Array<Enemy> {

		
		spawned = true;
		for (i in 0...enemyCount) {
			var e = EnemyFactory.createEnemy(enemyType);
			placeEnemy(e);
			enemies.push(e);
		}
		return enemies;
	}
	
	public function pickRandomLocation(allAround:Bool = false) {
		if (!allAround) {
			spawnPosition.x = -50;
			spawnPosition.y = FlxG.random.float(-100, H.LEVEL_SIZE + 100);
		} else {
			throw 'Not implemented yet stupid.';
		}
		trace('random posistion ' + spawnPosition.toString());
	}
	
	private function placeEnemy(e:Enemy) {
		var p = new FlxPoint(0, -100);
		p.y *= FlxG.random.float(0, 1);
		p.rotate(FlxPoint.weak(), FlxG.random.float( -180, 179));
		p.x += spawnPosition.x;
		p.y += spawnPosition.y;
		e.reset(p.x, p.y);
	}
	
}