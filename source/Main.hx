package;

import flixel.FlxGame;
import inputhelper.InputHelper;
import openfl.display.Sprite;
import states.GameState;
import states.MenuState;

class Main extends Sprite
{
	public function new()
	{
		InputHelper.init();
		InputHelper.allowWASD();
		super();
		addChild(new FlxGame(400, 400, MenuState));
	}
}
