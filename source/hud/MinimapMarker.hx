package hud;

import enemies.Enemy.EnemyTypes;
import entities.Entity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class MinimapMarker extends FlxSprite 
{

	var parent:Entity;
	public function new() 
	{
		super();
		makeGraphic(3, 3, FlxColor.WHITE);
		scrollFactor.set();
		//FlxG.watch.add(this, 'x');
		//FlxG.watch.add(this, 'y');
	}
	
	public function registerEntity(e:Entity) {
		parent = e;
		color = e.minimapColor;
		setPosition(-100,-100);
		revive();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (parent == null || !parent.alive && parent.type != EnemyTypes.GUNSHIP) {
			kill();
			return;
		}
		
		var xx = parent.x / H.LEVEL_SIZE;
		var yy = parent.y / H.LEVEL_SIZE;

		setPosition(H.MAP_LOC_X + H.MAP_SIZE * xx - 1, H.MAP_LOC_Y + H.MAP_SIZE * yy - 1);
		
		super.update(elapsed);
	}
	
}