package states;

import entities.Effects;
import entities.Player;
import entities.Ship;
import factories.EffectFactory;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint.FlxCallbackPoint;
import flixel.util.FlxColor;
import inputhelper.InputHelper;

/**
 * ...
 * @author Dave
 */
class GameState extends FlxState 
{

	var bg1:FlxBackdrop;
	var bg2:FlxBackdrop;
	var bg3:FlxBackdrop;
	
	var camTarget:FlxSprite;
	
	var p:Player;
	
	var effects:FlxTypedGroup<Effects>;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		FlxG.worldBounds.set(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		createBG();
		effects = new FlxTypedGroup<Effects>();
		EffectFactory.registerEffects(effects);
		add(effects);
		
		test();
		createPlayer();
		
		camTarget = new FlxSprite(0, 0);
		camTarget.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		FlxG.camera.follow(p, FlxCameraFollowStyle.LOCKON );
		FlxG.camera.setScrollBoundsRect(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		FlxG.watch.add(p, 'acceleration');
	}
	
	
	private function test() {
		var s = new Ship(375, 375);
		//s.makeGraphic(50, 50, FlxColor.BLUE);
		add(s);
		FlxG.camera.bgColor = FlxColor.fromRGBFloat(.2,.2,.2);
	}
	
	private function createPlayer(){
		p = new Player();
		p.setPosition(200, 200);
		add(p);
		
	}
	private function createBG() {
		//var bg1 = new FlxBackdrop('assets/images/stars_0.png');
		//bg1.velocity.x = -80;
		//add(bg1);
		//var bg2 = new FlxBackdrop('assets/images/stars_1.png');
		//bg2.velocity.x = -100;
		//add(bg2);
		var bg3 = new FlxBackdrop('assets/images/stars_0.png');
		bg3.y = 30;
		//bg3.scale.set(.5, .5);
		bg3.velocity.x = -540;
		add(bg3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		InputHelper.updateKeys();
		
		
		super.update(elapsed);
		var pos = FlxG.mouse.getPosition();
		camTarget.x = pos.x;
		camTarget.y = pos.y;
		
		
		
		
	}
}