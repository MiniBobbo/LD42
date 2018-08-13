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
		var incoming:Bool = false;
		for (w in waves) {
			if (w.timeToSpawn == newTime) {
				incoming = true;
				w.spawnWave();
			}
		}
		
		if (incoming)
		SM.play(SM.SoundTypes.NEW_WAVE);
	}
}