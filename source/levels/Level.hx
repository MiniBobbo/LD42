package levels;

/**
 * ...
 * @author Dave
 */
class Level 
{

	public var waves:Array<Wave>;
	public var totalTime:Float;
	public var name:String;
	
	public function new(totalTime:Float) 
	{
		this.totalTime = totalTime;
		waves = [];
	}
	
	public function addWave(w:Wave) {
		waves.push(w);
	}
	
	public function advanceTime(newTime:Int) {
		for (w in waves) {
			if (w.timeToSpawn == newTime) {
				w.spawnWave();
			}
		}
	}
}