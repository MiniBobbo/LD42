package;
import attacks.UnivAttack;
import enemies.Enemy;
import entities.Player;
import entities.Ship;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import levels.Level;
import states.GameState;

/**
 * ...
 * @author Dave
 */
class H 
{

	public static var currentLevel:Level;
	
	public static var gs(default, null):GameState;
	
	public static var allowInput:Bool = true;
	
	public static var LEVEL_SIZE:Float = 2000;
	
	public static function getFrames():FlxAtlasFrames {
		return FlxAtlasFrames.fromTexturePackerJson('assets/images/SpaceRun.png', 'assets/images/SpaceRun.json'); 
	}
	
	public static function setLevel(l:Level) {
		currentLevel = l;
	}
	
	public static function registerGameState(gameState:GameState) {
		gs = gameState;
	}
	
	public static function keepInBounds(s:FlxSprite){
		if (s.x < 0){
			s.x = 0;
			s.velocity.x = 0;
		}
		if (s.x + s.width > LEVEL_SIZE) {
			s.velocity.x = 0;
			s.x = LEVEL_SIZE - s.width;
		}
		if (s.y < 0) {
			s.y = 0;
			s.velocity.y = 0;
		}
		if (s.y + s.height > LEVEL_SIZE) {
			s.velocity.y = 0;
			s.y = LEVEL_SIZE - s.height;
		}
	}
	
	public static function getPlayerAttack():UnivAttack {
		return gs.getPlayerAttack();
	}
	public static function getEnemyAttack():UnivAttack {
		return gs.getEnemyAttack();
	}
	
	public static function getShip():Ship {
		return gs.ship;
	}
	public static function getPlayer():Player {
		return gs.p;
	}
	
	public static function addEnemy(e:Enemy) {
		trace('Trying to add an enemy to the game state');
		gs.enemies.add(e);
	}
	
	/**
	 * Signals every signalable entity in the game
	 * @param	signal		The signal to send
	 * @param	data		The data that should be sent along.
	 */
	public static function signalAll(signal:String, ?data:Dynamic) {
		for (s in H.gs.signalable)
			s.getSignal(signal, data);
	}
}