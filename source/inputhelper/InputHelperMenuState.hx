package inputhelper ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyList;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class InputHelperMenuState extends FlxSubState
{

	//Size variables
	public var BUTTON_TOP = 80;
	public var BUTTON_LEFT = Std.int(FlxG.width / 10);
	
	public var BUTTON_WIDTH:Int = Std.int(FlxG.width / 10 * 8);
	public var BUTTON_HEIGHT = 20;
	public var BUTTON_FONT_SIZE = 10;

	//Background window settings
	public var WINDOW_TOP = 40;
	public var WINDOW_LEFT = Std.int(FlxG.width / 20);
	public var WINDOW_WIDTH = Std.int(FlxG.width - (FlxG.width / 20) * 2);	
	public var WINDOW_HEIGHT = Std.int(FlxG.height - 60);	
	public var WINDOW_COLOR = FlxColor.BLUE;
	
	//Other variables
	public var text:FlxText;
	public var btnKeyAssign:Array<FlxButton>;
	public var btnMessage:FlxButton;
	public var btnBack:FlxButton;
	public var bg:FlxSprite;

	//Have we selected anything?
	public var chosen = -1;
	
	//Chosen variables.
	public var dimScreen:FlxSprite;
	public var pressKey:FlxText;
	
	
	override public function destroy():Void 
	{
		super.destroy();
		dimScreen = null;
		pressKey = null;
		text = null;
		btnBack = null;
		btnKeyAssign = null;
		btnMessage = null;
	}
	
	override public function create():Void 
	{
		super.create();

		//Create the background window.
		bg = new FlxSprite(WINDOW_LEFT, WINDOW_TOP);
		bg.makeGraphic(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_COLOR);
		add(bg);

		var bgText = new FlxText();
		bgText.setFormat(null, 14, FlxColor.WHITE, FlxTextAlign.CENTER);
		bgText.setSize(WINDOW_WIDTH, 16);
		bgText.setPosition(WINDOW_LEFT, WINDOW_TOP);
		bgText.text = "Remap keys";
		add(bgText);
		
		
		text = new FlxText();
		btnKeyAssign = new Array<FlxButton>();
		btnMessage = new FlxButton((FlxG.width / 2) - (BUTTON_WIDTH / 2), FlxG.height / 2, "");
		btnBack = new FlxButton(0, 0, "Finished", back);
		btnBack.screenCenter();
		btnBack.y = WINDOW_HEIGHT;
		//Create all the buttons we need for assignment.
		for (i in 0...InputHelper.getNumberOfButtons()) {
			//Sets a bunch of button size junk based off the variables supplied.
			var btnTemp = new FlxButton(BUTTON_LEFT, BUTTON_TOP + (BUTTON_HEIGHT * i), InputHelper.getButtonLabel(i), btnClicked);
			btnTemp.setGraphicSize(BUTTON_WIDTH, BUTTON_HEIGHT);
			btnTemp.updateHitbox();
			btnTemp.label = new FlxText(0, 0, btnTemp.width, "");
			btnTemp.label.setFormat(null, BUTTON_FONT_SIZE, 0x333333, "center");
			btnTemp.labelOffsets[FlxButton.NORMAL].y = (BUTTON_HEIGHT/ 2) - (BUTTON_FONT_SIZE);
			btnTemp.labelOffsets[FlxButton.PRESSED].y = (BUTTON_HEIGHT/ 2) - (BUTTON_FONT_SIZE)+2;
			btnTemp.labelOffsets[FlxButton.HIGHLIGHT].y = (BUTTON_HEIGHT / 2) - (BUTTON_FONT_SIZE);
			//btnTemp.resetSize();
			btnKeyAssign.push(btnTemp);
			add(btnTemp);
		}
		updateButtonText();
		text.text;
		add(text);
		add(btnBack);
		
		dimScreen = new FlxSprite(0, 0);
		dimScreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		dimScreen.alpha = .5;
		dimScreen.set_visible(false);
		add(dimScreen);
		pressKey = new FlxText(0, 100, FlxG.width, "Press the key to assign:", 40);
		pressKey.setFormat(null, 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		pressKey.visible = false;
		add(pressKey);
	}
	
	override public function update(dt:Float):Void 
	{
		super.update(dt);
		InputHelper.updateKeys(FlxG.elapsed);
		text.text = "";
		if (chosen != -1 && FlxG.keys.getIsDown().length > 0) {
			assign();
		}
		
	}
	
	private function btnClicked() {
		var clicked:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		for (i in 0...btnKeyAssign.length) {
			if (btnKeyAssign[i].overlapsPoint(clicked))
				assignKey(i);
		}
		
	}
	
	private function assignKey(b:Int) {
		dimScreen.visible = true;
		pressKey.text = "Press key for " + InputHelper.getButtonLabel(b);
		pressKey.visible = true;
		chosen = b;
	}
	
	private function clearAssignKey() {
		dimScreen.visible = false;
		pressKey.visible = false;
		chosen = -1;
	}
	
	private function assign() {
		InputHelper.keyMappedToButton.set(FlxKey.toStringMap.get(FlxG.keys.firstJustPressed()), chosen);
		clearAssignKey();
		updateButtonText();
	}
	
	/**
	 * Updates the text of the buttons.
	 */
	public function updateButtonText() {
		for (i in 0...btnKeyAssign.length)
			btnKeyAssign[i].text = InputHelper.getButtonLabel(i) + ":    " +  InputHelper.getKeysAssignedToButton(InputHelper.getButtonLabel(i));
	}
	
	/**
	 * This causes the substate to close itself.
	 */
	public function back() {
		this._parentState.closeSubState();
	}
	

}	
