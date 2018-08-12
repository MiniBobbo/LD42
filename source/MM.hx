package;
import flixel.FlxG;
import flixel.tweens.FlxTween;

enum MusicTypes {
	BATTLE;
	VICTORY;
	DEFEAT;
}

/**
 * ...
 * @author Dave
 */
class MM 
{

	public static function play(type:MusicTypes) {
		switch (type) 
		{
			case MusicTypes.BATTLE:
				FlxG.sound.playMusic('assets/music/Space1.mp3');
			case MusicTypes.VICTORY:
				FlxG.sound.playMusic('assets/music/space_victory.mp3', 1, false);
				
			default:
				fadeMusic();
		}
	}
	
	public static function fadeMusic(time:Float = 1) {
		FlxTween.tween(FlxG.sound.music, {volume:0}, time);
	}
	public static function fadeInMusic(time:Float = 1) {
		FlxTween.tween(FlxG.sound.music, {volume:1}, time);
	}
	
	
	
}