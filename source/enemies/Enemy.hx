package enemies;

import entities.Entity;
import flixel.system.FlxAssets.FlxGraphicAsset;

enum EnemyTypes {
	BIKER;
}

class Enemy extends Entity 
{

	public var spawnExactly:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
}