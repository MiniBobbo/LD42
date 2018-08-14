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
		InputHelper.addButton('weaponup');
		InputHelper.addButton('weapondown');
		InputHelper.assignKeyToButton('Q', 'weapondown');
		InputHelper.assignKeyToButton('E', 'weaponup');
		
		super();
		
		H.defaultGameDef = {
			rankings: [],
			starsSpent:0,
			weaponsPurchased:[]
		};
		
		addChild(new FlxGame(400, 400, MenuState));
	}
	
	
}
