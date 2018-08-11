package enemies.biker;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class Biker extends Enemy 
{

	var moveSpeed:Float = 60;
	
	public function new() 
	{
		super();
		frames = H.getFrames();
		animation.addByPrefix('ride', 'biker_ride_', 12);
		animation.play('ride');
		setSize(70, 35);
		centerOffsets();
		hp = 10;
		
	}

	
	override public function update(elapsed:Float):Void 
	{
		var p = FlxPoint.get(0, -moveSpeed);
		p.rotate(FlxPoint.weak(), getMidpoint().angleBetween(H.getShip().getMidpoint()));
		velocity.copyFrom(p);
		p.put();
		super.update(elapsed);
	}
}