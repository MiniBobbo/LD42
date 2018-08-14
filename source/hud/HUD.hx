package hud;

import entities.Entity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxAccelerometer;
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

	var WEAPON_ICON_X:Float = 120;
	var WEAPON_ICON_Y:Float = 360;
	var WEAPON_ICON_SPACE:Float = 60;
	
	var shipSticker:FlxSprite;

	var START_POS:Float = 0;
	var LENGTH:Float = 400;

	//var MAP_LOC_X:Float = 310;
	//var MAP_LOC_Y:Float = 310;
	//var MAP_SIZE:Int = 70;

	var mapStamp:FlxSprite;
	var map:FlxSprite;
	var playerMarker:FlxSprite;
	var shipMarker:FlxSprite;
	var line:FlxSprite;
	var shipPointer:FlxSprite;
	
	var weaponIcons:Array<WeaponIcon>;
	//This is the index of the weapon icon that is selected to make moving it around easier.
	var weaponSelected:Int = 0;
	
	public var minimapMarkers:FlxTypedSpriteGroup<MinimapMarker>;
	
	var shipHealth:Bar;
	
	var shipText:FlxText;

	var mapIcons:FlxSpriteGroup;

	public function new()
	{
		super();
		mapStamp = new FlxSprite();
		mapStamp.makeGraphic(H.MAP_SIZE, H.MAP_SIZE, FlxColor.GRAY);

		minimapMarkers = new FlxTypedSpriteGroup<MinimapMarker>();
		
		weaponIcons = createWeaponIcons();
		trace('Player has weapons: ' + weaponIcons);
		
		scrollFactor.set();
		line = new FlxSprite();
		line.frames = H.getFrames();
		line.animation.frameName = 'travelbar_1';
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
		shipMarker = new FlxSprite();
		shipMarker.makeGraphic(5,5,FlxColor.GREEN);

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
		shipHealth.setPosition(0, FlxG.height - 20);
		
		shipText = new FlxText(shipHealth.x, shipHealth.y-5, 0, 'Ship Health');
		shipText.setFormat(null, 10, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		shipText.scrollFactor.set();
	   add(shipPointer);
		add(line);
		add(shipSticker);
		//add(map);
		add(minimapMarkers);
		add(shipMarker);
		add(playerMarker);
		add(shipHealth);
		for (i in weaponIcons)
			add(i);
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
		var s = H.getShipMidpoint();
		
		updatePlayerMarker(p.x - 16, p.y - 16);
		updateShipMarker(s.x - 16, s.y - 16);
		
		updateShipPointer();
		p.put();
	}

	public function updatePlayerMarker(x:Float, y:Float)
	{
		var xx = x / H.LEVEL_SIZE;
		var yy = y / H.LEVEL_SIZE;

		playerMarker.setPosition(H.MAP_LOC_X + H.MAP_SIZE * xx - 1, H.MAP_LOC_Y + H.MAP_SIZE * yy - 1);
	}
	public function updateShipMarker(x:Float, y:Float)
	{
		var xx = x / H.LEVEL_SIZE;
		var yy = y / H.LEVEL_SIZE;

		shipMarker.setPosition(H.MAP_LOC_X + H.MAP_SIZE * xx - 1, H.MAP_LOC_Y + H.MAP_SIZE * yy - 1);
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
			FlxSpriteUtil.fadeOut(H.gs.crosshair);
		}
	}

	public function registerOntoMinimap(e:Entity) {
		var mm = getMinimapMarker();
		mm.registerEntity(e);
		FlxG.log.add('Registered entity to minimap:' + e);
	}
	
	private function getMinimapMarker():MinimapMarker {
		var m = minimapMarkers.getFirstAvailable();
		if (m == null){
			m = new MinimapMarker();
			minimapMarkers.add(m);
		}
		
		return m;
		
	}
	
	private function createWeaponIcons():Array<WeaponIcon> {
		var w:Array<WeaponIcon> = [];
		var def = H.getPlayerDef();
		var count = 0;
		for (a in def.attackOptions) {
			var icon = new WeaponIcon(a);
			w.push(icon);
			icon.setPosition(WEAPON_ICON_X + WEAPON_ICON_SPACE * count, WEAPON_ICON_Y);
			count++;
		}
		
		return w;
	}
	
	public function weaponUp() {
		weaponSelected++;
		if (weaponSelected >= weaponIcons.length) {
			weaponSelected = 0;
		}
		chooseWeapon(weaponSelected);
	}
	public function weaponDown() {
		weaponSelected--;
		if (weaponSelected < 0) 
			weaponSelected = weaponIcons.length - 1;
		chooseWeapon(weaponSelected);
	}
	
	private function chooseWeapon(newWeaponIndex:Int) {
		for (i in weaponIcons)
			i.color = FlxColor.WHITE;
		weaponIcons[newWeaponIndex].color = FlxColor.YELLOW;
		H.getPlayer().getSignal('changeweapon', weaponIcons[newWeaponIndex].type);
	}
	
	
}