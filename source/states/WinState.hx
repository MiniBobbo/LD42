package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class WinState extends FlxState 
{

	var victory:FlxText;
	var bg:FlxBackdrop;
	
	var s1:FlxSprite;
	var s2:FlxSprite;
	var s3:FlxSprite;
	
	var levelRank:Int = 0;
	
	public function new() 
	{
		super();
		
		
	}
	
	override public function create():Void 
	{
		super.create();
		bg = new FlxBackdrop('assets/images/lightspeed.png');
		bg.velocity.x = -800;
		
		FlxG.mouse.visible = true;
		victory = new FlxText(0, 130, FlxG.width, '\nVICTORY' , 30);
		victory.setFormat(null, 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		MM.play(MM.MusicTypes.VICTORY);
		
		var ship = new FlxSprite();
		ship.frames = H.getFrames();
		ship.animation.frameName = 'ship';
		var shipy:Float = 44;
		ship.reset(200, shipy);
		FlxTween.tween(ship, {y:shipy + 10}, 1, {ease:FlxEase.quadInOut, type:FlxTween.PINGPONG});
		
		levelRank = calculateLevelRank();
		
		var back = new FlxButtonPlus(0, 0, backToMenu, 'Back to menu');
		back.screenCenter();
		back.y += 100;
		
		add(bg);
		add(back);
		add(victory);
		add(ship);
		
		
		
		showStars();
		
		H.updateLevelRanking(H.currentLevel.name, levelRank);
		
	}
	
	function showStars()  {
		s1 = starSprite();
		s2 = starSprite();
		s3 = starSprite();
		add(s1);
		add(s2);
		add(s3);
		
		new FlxTimer().start(1, playStar1);
		new FlxTimer().start(2, playStar2);
		new FlxTimer().start(3, playStar3);
		
		
	}

	function playStar1(_) {
		s1.setPosition(125, 237);
		s1.animation.play('yes');
		FlxTween.tween(s1.scale, {x:3, y:3}, 1, {ease:FlxEase.quadInOut, onComplete:function(_) {SM.play(SM.SoundTypes.DING); }});
		
	}
	
	function playStar2(_) {
		s2.setPosition(200, 237);
		if(levelRank >=2)
		s2.animation.play('yes');
		FlxTween.tween(s2.scale, {x:3, y:3}, 1, {ease:FlxEase.quadInOut, onComplete:function(_) {
			if(levelRank >=2)
			SM.play(SM.SoundTypes.DING); 
			
		}});
		
	}
	function playStar3(_) {
		s3.setPosition(275, 237);
			if(levelRank >=3)
		s3.animation.play('yes');
		FlxTween.tween(s3.scale, {x:3, y:3}, 1, {ease:FlxEase.quadInOut, onComplete:function(_) {
			if(levelRank >=3)
			SM.play(SM.SoundTypes.DING); 
			
		}});
		
	}
	
	function starSprite():FlxSprite {
		var s = new FlxSprite();
		s.loadGraphic('assets/images/stars.png', true);
		s.animation.add('no', [2], 1, false);
		s.animation.add('yes', [3], 1, false);
		s.animation.play('no');
		s.setSize(1,1);
		s.centerOffsets();
		s.centerOrigin();
		s.scale.set(.001, .001);
		return s;
	}
	
	function showVictory(_) {
		
	}
	
	function calculateLevelRank():Int {
		if (H.levelScore >= 85 )
			return 3;
		else if (H.levelScore > 45)
			return 2;
		else
			return 1;
	}
	
	function backToMenu() {
		FlxG.switchState(new MenuState());
	}
	
	
}