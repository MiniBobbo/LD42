package;
import flixel.FlxG;

enum SoundTypes
{
	LASER;
	NONE;
	LASERHIT;
	DING;
	EXPLODE;
	SHIELD_BLOCK;
	PLAYER_HIT;
	NEW_WAVE;
}

class SM
{

	public static function play(type:SoundTypes)
	{
		switch (type)
		{
			case SoundTypes.LASER:
				var r = FlxG.random.int(1, 4);
				FlxG.sound.play('assets/sounds/laser' + r + '.wav');
				
			case SoundTypes.LASERHIT:
				FlxG.sound.play('assets/sounds/impact_3.wav');
			case SoundTypes.DING:
				FlxG.sound.play('assets/sounds/ding.wav');
			case SoundTypes.EXPLODE:
				FlxG.sound.play('assets/sounds/boom3_3.wav');
			case SoundTypes.PLAYER_HIT:
				FlxG.sound.play('assets/sounds/shield_impact.wav');
			case SoundTypes.SHIELD_BLOCK:
				FlxG.sound.play('assets/sounds/shield.wav');
			case SoundTypes.NEW_WAVE:
				FlxG.sound.play('assets/sounds/enemy_wave.wav');
				
				
				

			default:
		}
	}

}