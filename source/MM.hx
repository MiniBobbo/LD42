package;
import flixel.FlxG;
import flixel.tweens.FlxTween;

enum MusicTypes {
	BATTLE;
	VICTORY;
	DEFEAT;
	MENU;
	PURSUER;
}

/**
 * ...
 * @author Dave
 */
class MM 
{

	public static var currentMusic:MusicTypes;
	
	public static function play(type:MusicTypes) {
		currentMusic  = type;
		switch (type) 
		{
			case MusicTypes.BATTLE:
				FlxG.sound.playMusic('assets/music/Space1.mp3');
			case MusicTypes.VICTORY:
				FlxG.sound.playMusic('assets/music/space_victory.mp3', 1, false);
			case MusicTypes.DEFEAT:
				FlxG.sound.playMusic('assets/music/you_lose.mp3', 1, false);
			case MusicTypes.MENU:
				FlxG.sound.playMusic('assets/music/space_menu.mp3', 1);
			case MusicTypes.PURSUER:
				FlxG.sound.playMusic('assets/music/pursuer.mp3', 1);
				
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