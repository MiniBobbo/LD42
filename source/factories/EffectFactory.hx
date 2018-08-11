package factories;
import entities.Effects;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

enum EffectType {
	THRUST;
}

class EffectFactory 
{
	private static var effects:FlxTypedGroup<Effects>;
	
	public static function registerEffects(e:FlxTypedGroup<Effects>) {
		effects = e;
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
		
		switch (type) 
		{
			case EffectType.THRUST:
				e.animation.play('thrust');
				e.setSize(32, 32);
				e.centerOffsets();
				e.reset(position.x - e.width / 2, position.y - e.height / 2);
				e.velocity.x = -100;
				
			default:
				
		}
	}
	
	
}