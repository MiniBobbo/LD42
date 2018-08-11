package;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

/**
 * ...
 * @author Dave
 */
class H 
{

	public static var allowInput:Bool = true;
	
	public static var LEVEL_SIZE:Float = 800;
	
	public static function getFrames():FlxAtlasFrames {
		return FlxAtlasFrames.fromTexturePackerJson('assets/images/SpaceRun.png', 'assets/images/SpaceRun.json'); 
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
	
}