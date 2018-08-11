package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import tmxtools.TmxTools;

class PlayState extends FlxState
{
	var w1:FlxSprite;
	var w2:FlxSprite;
	var p:FlxSprite;
	
	var walls:FlxSpriteGroup;
	var thismap:FlxTilemap;
	override public function create():Void
	{
		super.create();
		
		var map = new TmxTools('assets/data/test.tmx', 'assets/data/');
		thismap = map.getMap('main');
		add(thismap);
		
		var s = thismap.tileToSprite(0, 0, 0);
		add(s);
		FlxTween.tween(s, {x:100, y:100}, 1, {ease:FlxEase.quadInOut,type:FlxTween.PINGPONG});
		//walls = new FlxSpriteGroup();
		//
		w1 = new FlxSprite(0,FlxG.height);
		w1.makeGraphic(10, FlxG.height, FlxColor.RED);
		w1.velocity.y = -20;
		
		add(w1);
		
		//w2 = new FlxSprite(FlxG.width, 0);
		//w2.makeGraphic(10, FlxG.height, FlxColor.RED);
		//w2.velocity.x = -20;
		//
		//walls.add(w1);
		//walls.add(w2);
		//
		//
		//p = new FlxSprite();
		//p.makeGraphic(32,32,FlxColor.BLUE);
		//p.screenCenter();
		//
		//add(walls);
		//add(p);
	}

	override public function update(elapsed:Float):Void
	{
		
	}
	
	
}
