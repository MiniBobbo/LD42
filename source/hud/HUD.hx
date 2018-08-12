package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import signal.ISignal;

/**
 * ...
 * @author Dave
 */
class HUD extends FlxSpriteGroup implements ISignal
{

	var shipSticker:FlxSprite;

	var START_POS:Float = -30;
	var LENGTH:Float = 400;

	var MAP_LOC_X:Float = 310;
	var MAP_LOC_Y:Float = 310;
	var MAP_SIZE:Int = 70;

	var mapStamp:FlxSprite;
	var map:FlxSprite;
	var playerMarker:FlxSprite;
	var line:FlxSprite;
	var shipPointer:FlxSprite;

	var shipHealth:Bar;
	
	var shipText:FlxText;

	var mapIcons:FlxSpriteGroup;

	public function new()
	{
		super();
		mapStamp = new FlxSprite();
		mapStamp.makeGraphic(MAP_SIZE, MAP_SIZE, FlxColor.GRAY);

		scrollFactor.set();
		line = new FlxSprite();
		line.frames = H.getFrames();
		line.animation.frameName = 'travelbar';
		line.scrollFactor.set();

		shipSticker = new FlxSprite();
		shipSticker.scrollFactor.set();
		shipSticker.frames = H.getFrames();
		shipSticker.animation.frameName = 'icons_hellbaticon_0';
		shipSticker.setSize(32, 32);
		shipSticker.centerOffsets();
		shipSticker.y = 5;
		FlxTween.tween(shipSticker, {y:10}, 1, {ease:FlxEase.quadInOut, type:FlxTween.PINGPONG});

		playerMarker = new FlxSprite();
		playerMarker.makeGraphic(3,3,FlxColor.RED);

		shipPointer = new FlxSprite();
		shipPointer.frames = H.getFrames();
		shipPointer.animation.frameName = 'icons_pointer_0';
		shipPointer.setSize(32, 32);
		shipPointer.centerOffsets();

		shipPointer.centerOrigin();
		shipPointer.scrollFactor.set();

		mapIcons = new FlxSpriteGroup();

		shipHealth = new Bar(H.getShip(), 'hp', 100);
		shipHealth.scrollFactor.set();
		shipHealth.y = FlxG.height - 20;
		
		shipText = new FlxText(shipHealth.x, shipHealth.y, 0, 'Ship Health');
		shipText.scrollFactor.set();
	   add(shipPointer);
		add(line);
		add(shipSticker);
		//add(map);
		add(playerMarker);
		add(shipHealth);
		add(shipText);
		
	}

	public function setShipStickerPosition(ratio:Float)
	{
		shipSticker.x = LENGTH * ratio + START_POS;

	}

	public function updateShipPointer()
	{
		shipPointer.angle = H.getPlayer().getMidpoint().angleBetween(H.getShip().getMidpoint());
		var player = H.getPlayer();
		var p = player.getScreenPosition();
		shipPointer.setPosition(p.x, p.y);
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		var p = H.getPlayer().getMidpoint();

		updatePlayerMarker(p.x-16,p.y - 16);
		updateShipPointer();
		p.put();
	}

	public function updatePlayerMarker(x:Float, y:Float)
	{
		var xx = x / H.LEVEL_SIZE;
		var yy = y / H.LEVEL_SIZE;

		playerMarker.setPosition(MAP_LOC_X + MAP_SIZE * xx - 1, MAP_LOC_Y + MAP_SIZE * yy - 1);
	}

	public function getIcon():FlxSprite
	{
		var i = mapIcons.getFirstAvailable();
		if (i == null)
		{
			i = new FlxSprite();
			i.makeGraphic(1, 1, FlxColor.WHITE);
			mapIcons.add(i);
		}
		return i;
	}

	public function updateShipSticker(currentTime:Float, maxTime:Float)
	{
		shipSticker.x = (currentTime / maxTime) * LENGTH + START_POS;
	}

	public function getSignal(signal:String, ?data:Dynamic):Void {
		if (signal == 'victory' || signal == 'defeat') {
			FlxSpriteUtil.fadeOut(shipSticker);
			FlxSpriteUtil.fadeOut(shipHealth);
			FlxSpriteUtil.fadeOut(shipText);
			FlxSpriteUtil.fadeOut(shipPointer);
			FlxSpriteUtil.fadeOut(line);
			
		}
	}

}