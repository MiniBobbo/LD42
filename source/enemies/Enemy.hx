package enemies;

import entities.Entity;
import flixel.system.FlxAssets.FlxGraphicAsset;

enum EnemyTypes {
	BIKER;
}

class Enemy extends Entity 
{

	public var spawnExactly:Bool = false;
	
	
	public function new() 
	{
		super();
		
	}
	
}