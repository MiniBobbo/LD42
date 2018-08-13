package factories;
import entities.Effects;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

enum EffectType {
	THRUST;
	LARGE_THRUST;
	EXPLODE;
}

class EffectFactory 
{
	private static var effects:FlxTypedGroup<Effects>;
	private static var fgeffects:FlxTypedGroup<Effects>;
	
	public static function registerEffects(e:FlxTypedGroup<Effects>) {
		effects = e;
	}
	public static function registerFgEffects(e:FlxTypedGroup<Effects>) {
		fgeffects = e;
	}
	
	
	
	
	/**
	 * Creates an effect 
	 * @param	position	The position the effect should be created at.
	 * @param	type		The type of effect
	 * @param	data		Optional data.  
	 */
	public static function effect(position:FlxPoint, type:EffectType, ?data:Dynamic) {
		var e = effects.getFirstAvailable();
		//Lazy load the effect
		if (e == null) {
			e = new Effects();
			effects.add(e);
		}
		
		createEffect(e, position, type, data);
	}

	public static function fgeffect(position:FlxPoint, type:EffectType, ?data:Dynamic) {
		var e = fgeffects.getFirstAvailable();
		//Lazy load the effect
		if (e == null) {
			e = new Effects();
			fgeffects.add(e);
		}
		
		createEffect(e, position, type, data);
	}

	
	private static function createEffect(e:Effects, position:FlxPoint, type:EffectType, ?data:Dynamic) {
				
		switch (type) 
		{
			case EffectType.THRUST:
				e.animation.play('thrust');
				e.setSize(32, 32);
				e.centerOffsets();
				e.scale.set(1, 1);
				e.reset(position.x - e.width / 2, position.y - e.height / 2);
				e.velocity.x = -300;
				e.velocity.y = FlxG.random.float(-30,30);
				e.startTimer(.5);
			case EffectType.EXPLODE:
				SM.play(SM.SoundTypes.EXPLODE);
				e.animation.play('explode');
				e.setSize(32, 32);
				e.centerOffsets();
				e.scale.set(1, 1);
				e.centerOrigin();
				e.reset(position.x - e.width / 2, position.y - e.height / 2);
				e.acceleration.set();
				e.velocity.set();
				e.startTimer(.5);
			case EffectType.LARGE_THRUST:
				e.animation.play('thrust');
				e.setSize(32, 32);
				e.centerOffsets();
				e.centerOrigin();
				e.scale.set(2, 2);
				e.reset(position.x - e.width / 2, position.y - e.height / 2);
				e.velocity.x = -600;
				e.velocity.y = FlxG.random.float(-30,30);
				e.startTimer(.5);
				
			default:
				
		}

		
	}
	
}