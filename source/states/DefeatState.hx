package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class DefeatState extends FlxState 
{

	var victory:FlxText;
	var p:FlxSprite;
	public function new() 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();
		var bg3 = new FlxBackdrop('assets/images/stars_0.png');
		bg3.y = 30;
		//bg3.scale.set(.5, .5);
		bg3.velocity.x = -540;
		add(bg3);

		p = new FlxSprite();
		p.frames = H.getFrames();
		p.animation.frameName = 'player_dead_0';
		p.screenCenter();
		p.centerOffsets();
		p.centerOrigin();
		p.y -= 150;
		add(p);
		
		
		FlxG.mouse.visible = true;
		victory = new FlxText(0, 100, FlxG.width, '\nDEFEAT' , 30);
		victory.setFormat(null, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(victory);
		MM.play(MM.MusicTypes.DEFEAT);
		
		var back = new FlxButtonPlus(0, 0, backToMenu, 'Back to menu');
		back.screenCenter();
		
		add(back);

		
		
		
		var tip = new FlxText(50, 260, 300, getTip(), 12);
		add(tip);
		
	}
	
	function showVictory(_) {
		
	}
	
	function getTip():String {
		var tips:Array<String> = [
		'Tip:  Remember you can stop the red shots from hitting your ship by standing in front of them.  Your shield will protect you from harm.',
		'Tip:  If you are having trouble, try watching the minimap and moving towards enemies as soon as they appear.  Don\'t wait until your ship is surrounded!',
		'Tip:  Don\'t stare directly into the sun.  This tip is not for this game, but just in general.',
		'Tip:  Space piracy can be hazardous to your health.',
		'Tip:  Blue bullets will stun you, but complete pass through your ship.',
		'Tip:  The more time you spend stunned, the longer your ship is unprotected.  Avoid the blue shots.',
		'Tip:  Drones are fast and annoying but unable to hit your ship.  You can always hit the threats to your ship and then let time run out to complete a level.'
		];
		
		return tips[FlxG.random.int(0, tips.length-1)];
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		p.angle += 5;
	}
	
	function backToMenu() {
		FlxG.switchState(new MenuState());
	}
	
}