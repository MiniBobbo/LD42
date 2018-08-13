package enemies;

import entities.Entity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

enum EnemyTypes {
	BIKER;
	DRONE;
	PYRAMID;
	SHOOT_BIKER;
}

class Enemy extends Entity 
{

	public var spawnExactly:Bool = false;
	
	
	public function new() 
	{
		super();
		minimapColor = FlxColor.BLUE;
	}
	
}