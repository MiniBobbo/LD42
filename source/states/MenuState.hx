package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class MenuState extends FlxState 
{

	var title:FlxText;
	var button:FlxButtonPlus;
	
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.visible = true;
		title = new FlxText(0, 0, FlxG.width, 'TITLE GOES HERE!', 46);
		title.setFormat(null, 46, FlxColor.WHITE, FlxTextAlign.CENTER);
		
		add(title);
		
		button = new FlxButtonPlus(0, 0, play, 'Start');
		button.screenCenter();
		add(button);
	}
	
	function play() {
		FlxG.switchState(new GameState() );
	}
	
}