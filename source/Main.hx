package;

import flixel.FlxGame;
import inputhelper.InputHelper;
import openfl.display.Sprite;
import states.DefeatState;
import states.GameState;
import states.MenuState;
import states.WinState;

class Main extends Sprite
{
	public function new()
	{
		InputHelper.init();
		InputHelper.allowWASD();
		InputHelper.allowArrowKeys();
		super();
		
		H.defaultGameDef = {
			rankings: [
			{name:'test', rank:0},
			{name:'level', rank:0}
			
			
			]
			
		};
		
		addChild(new FlxGame(400, 400, MenuState));
	}
	
	
}
