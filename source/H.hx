package;
import attacks.UnivAttack;
import defs.GameDef;
import defs.PlayerDef;
import defs.RankDef;
import enemies.Enemy;
import entities.Player;
import entities.Ship;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import haxe.Json;
import levels.Level;
import states.GameState;

/**
 * ...
 * @author Dave
 */
class H 
{

	public static var currentLevel:Level;
	public static var levelScore:Float;
	
	public static var gameDef:GameDef;
	public static var playerDef:PlayerDef;
	public static var defaultGameDef:GameDef;

	
	public static var gs(default, null):GameState;
	
	public static var allowInput:Bool = true;
	
	public static var LEVEL_SIZE:Float = 2000;
	public static var MAP_LOC_X:Float = 310;
	public static var MAP_LOC_Y:Float = 310;
	public static var MAP_SIZE:Int = 70;

	/**
	 * Gets the level ranking of the level.  
	 * @param	name
	 * @return 	The rank.  -1 if the level doesn't exist
	 */
	public static function getLevelRank(name:String):Int {
		for (r in gameDef.rankings) {
			if (r.name == name) {
				return r.rank;
			}
		}
		
		return -1;
	}
	
	public static function updateLevelRanking(name:String, rank:Int) {
		var found:RankDef = null;
		trace('Searching for ' + name);
		for (r in gameDef.rankings) {
			if (r.name == name) {
				found = r;
				trace('Found ' + r);
			}
		}
		
		if (found == null) {
			trace('Did not find.  Creating ' + name);
			found = {
				name:name,
				rank:0
			};
			gameDef.rankings.push(found);
			trace('New GameDef ' + gameDef);
		}
		
		if (found.rank < rank)
			found.rank = rank;
			
		H.saveGame();
		
	}
	
	public static function getFrames():FlxAtlasFrames {
		return FlxAtlasFrames.fromTexturePackerJson('assets/images/SpaceRun.png', 'assets/images/SpaceRun.json'); 
	}
	
	/**
	 * If there isn't a player def, load a default one.
	 * @return		Default playerDef
	 */
	private static function getDefaultPlayerDef():PlayerDef {
		return {
			attackOptions: [AttackTypes.SHOT, AttackTypes.SHOTGUN]
		};
	}

	public static function getPlayerDef():PlayerDef {
		if (playerDef == null) 
			return getDefaultPlayerDef();
		return playerDef;
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
	public static function getPlayerMidpoint():FlxPoint {
		return gs.p.getMidpoint();
	}
	
	public static function addEnemy(e:Enemy) {
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
	
	public static function getShipMidpoint():FlxPoint {
		return H.gs.ship.getMidpoint();
	}
	
		public static function saveGame() {
		var save = initSave();	
		
		
		save.data.d = Json.stringify(H.gameDef);
		save.close();
	}
	
	public static function loadGame():Bool {
		var save = initSave();
		if (save.data.d == null) {
			clearSave();
			return false;
		}
		H.gameDef = Json.parse(save.data.d);
		
		upgradeGameData(H.gameDef);
		
		save.close();
		
		if (gameDef == null)
		return false;
		return true;
	}
	
	/**
	 * This adds any missing fields to the gamedef so players don't have to reset.
	 * @param	data
	 */
	private static function upgradeGameData(data:GameDef) {
		trace('Pre upgrade: ' + data);
		if (data.starsSpent == null)
			data.starsSpent = 0;
		if (data.weaponsPurchased == null)
			data.weaponsPurchased = [];
			
		trace('Post upgrade: ' + data);
			
		
	}
	
	public static function clearSave() {
		var save = initSave();
		try{
		save.data.d = Json.stringify(H.defaultGameDef);
		save.close();
		loadGame();
		} catch (err:Dynamic)
		{
			trace(err);
		}
	}
	
	static private function initSave():FlxSave 
	{
		var save = new FlxSave();
		save.bind('wingman');
		return save;
	}
	
}