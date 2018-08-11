package hud;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class HUD extends FlxSpriteGroup 
{

	var shipSticker:FlxSprite;
	
	var START_POS:Float = -10;
	var LENGTH:Float = 400;
	
	var MAP_LOC_X:Float = 310;
	var MAP_LOC_Y:Float = 310;
	var MAP_SIZE:Int = 70;
	
	var mapStamp:FlxSprite;
	var map:FlxSprite;
	var playerMarker:FlxSprite;
	
	var shipPointer:FlxSprite;
	
	public function new() 
	{
		super();
		mapStamp = new FlxSprite();
		mapStamp.makeGraphic(MAP_SIZE, MAP_SIZE, FlxColor.GRAY);
	
		
		scrollFactor.set();
		var line = new FlxSprite();
		line.frames = H.getFrames();
		line.animation.frameName = 'travelbar';
		line.scrollFactor.set();
		
		shipSticker = new FlxSprite();
		shipSticker.scrollFactor.set();
		shipSticker.frames = H.getFrames();
		shipSticker.animation.frameName = 'icons_hellbaticon_0';
		shipSticker.setSize(32, 32);
		centerOffsets();
		shipSticker.y -= 12;
		FlxTween.tween(shipSticker, {y:0}, 3, {ease:FlxEase.quadInOut, type:FlxTween.PINGPONG});
		
		playerMarker = new FlxSprite();
		playerMarker.makeGraphic(3,3,FlxColor.RED);
		
		shipPointer = new FlxSprite();
		shipPointer.frames = H.getFrames();
		shipPointer.animation.frameName = 'icons_pointer_0';
		shipPointer.setSize(64, 64);
		shipPointer.centerOrigin();
		shipPointer.scrollFactor.set();
		
		
		//map = new FlxSprite(MAP_LOC_X, MAP_LOC_Y);
		//map.makeGraphic(MAP_SIZE, MAP_SIZE, FlxColor.GRAY);
		//map.scrollFactor.set();
		//map.stamp(mapStamp);
		add(shipPointer);
		add(line);
		add(shipSticker);
		//add(map);
		add(playerMarker);
	}
	
	public function setShipStickerPosition(ratio:Float) {
		shipSticker.x = LENGTH * ratio + START_POS;
		
	}
	
	public function updateShipPointer() {
		shipPointer.angle = H.getPlayer().getMidpoint().angleBetween(H.getShip().getMidpoint());
		var player = H.getPlayer();
		var p = player.getScreenPosition();
		shipPointer.setPosition(p.x, p.y);
	}
	
	override public function update(dt:Float) {
		super.update(dt);
		var p = H.getPlayer().getMidpoint();
		
		updatePlayerMarker(p.x-16,p.y - 16);
		updateShipPointer();
		p.put();
	}
	
	public function updatePlayerMarker(x:Float, y:Float) {
		var xx = x / H.LEVEL_SIZE;
		var yy = y / H.LEVEL_SIZE;
		
		playerMarker.setPosition(MAP_LOC_X + MAP_SIZE * xx - 1, MAP_LOC_Y + MAP_SIZE * yy - 1);
	}
	
	
	
}