package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxButtonPlus;
import flixel.input.FlxAccelerometer;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import inputhelper.InputHelperMenuState;
import menustuff.LevelGroup;

/**
 * ...
 * @author Dave
 */
class MenuState extends FlxState 
{

	var title:FlxText;
	var button:FlxButtonPlus;
	
	var levelCount:Int = 0;
	var LEVEL_X:Float = 30;
	var LEVEL_Y:Float = 200;
	var LEVEL_SPACE:Float = 25;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		H.loadGame();
		
		trace(H.gameDef);
		
		var bg3 = new FlxBackdrop('assets/images/stars_0.png');
		bg3.y = 30;
		bg3.velocity.x = -540;
		add(bg3);

		
		MM.play(MM.MusicTypes.MENU);
		FlxG.mouse.visible = true;
		title = new FlxText(0, 30, FlxG.width, 'WINGMAN', 46);
		title.setFormat(null, 46, FlxColor.WHITE, FlxTextAlign.CENTER);
		
		add(title);
		
		addLevel('Getting Started');
		addLevel('Bikers Attack');
		addLevel('Onslaught');
		addLevel('Drones');
		addLevel('Mixed Force');
		addLevel('Pyramids');
		addLevel('Incoming');
		addLevel('Gunship');
		addLevel('Crazy');
		addLevel('Insane');
		
		
		
		var clear = new FlxButton(0, 380, 'Clear Data', clearSave);
		add(clear);
		var remap = new FlxButton(150, 380, 'Remap Keys', remapKeys);
		add(remap);
		var help = new FlxButton(300, 380, 'Instructions', help);
		add(help);
		
		
	}
	
	private function addLevel(name:String ) {
		var lg = new LevelGroup(name);
		lg.x = LEVEL_X;
		lg.y = LEVEL_Y + LEVEL_SPACE * levelCount;
		levelCount++;
		if (levelCount > 5) {
			LEVEL_X = 230;
			levelCount = 0;
		}
			
		
		add(lg);
	}
	
	function play() {
		FlxG.switchState(new GameState() );
	}
	
	function clearSave() {
		H.clearSave();
		FlxG.switchState(new MenuState());
	}
	function remapKeys() {
		openSubState(new InputHelperMenuState());
	}
	function help() {
		openSubState(new HelpSubState());
	}
	
	
	
}