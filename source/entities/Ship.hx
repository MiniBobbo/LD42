package entities;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Ship extends Entity 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		frames = H.getFrames();
		animation.addByPrefix('ship', 'ship');
		animation.play('ship');
		setSize(100, 80);
		centerOffsets();
	}
	
}