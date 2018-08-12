package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class WinState extends FlxState 
{

	var victory:FlxText;
	public function new() 
	{
		super();
		FlxG.mouse.visible = true;
		victory = new FlxText(0, 100, FlxG.width, H.currentLevel.name + '\nVICTORY' , 30);
		victory.setFormat(null, 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(victory);
		MM.play(MM.MusicTypes.VICTORY);
		
		var back = new FlxButtonPlus(0, 0, backToMenu, 'Back to menu');
		back.screenCenter();
		
		add(back);
		
	}
	
	function showVictory(_) {
		
	}
	
	function backToMenu() {
		FlxG.switchState(new MenuState());
	}
	
	
}