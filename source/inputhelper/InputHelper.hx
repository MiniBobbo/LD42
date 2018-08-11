package inputhelper;
import flixel.FlxG;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * ...
 * @author Dave
 */
class InputHelper
{
	//Maps that hold the key values
	
	//Maps each key to a button.
	public static var keyMappedToButton:StringMap<Int>;
	//Maps each button to a label.
	public static var buttonMappedToName:IntMap<String>;
	//How long has the button been pressed?
	public static var buttonPressedLengthArray:Array<Float>;
	//Is the key pressed this update?
	public static var buttonPressedArray:Array<Bool>;
	
	
	
	/**
	 * Initializes all the variables we need for the input helper to run.  
	 * @param	numOfButtons Number of buttons we should create, in addition to the up, down, left, and right automatically made.
	 */
	public static function init() {
		//Create the Maps that hold the key values.
		keyMappedToButton = new StringMap<Int>();
		buttonMappedToName = new IntMap<String>();
		buttonPressedLengthArray = new Array<Float>();
		buttonPressedArray = new Array<Bool>();

		addButton("UP");
		addButton("DOWN");
		addButton("LEFT");
		addButton("RIGHT");

		/*
		//Craete the keys we need.  Automatically creates 4 (up, down, left and right).  Then creates additional buttons.
		for (i in 0...4) {
			buttonPressedLengthArray.push(0);
			buttonPressedArray.push(false);
		}
		
		
		/*
		//Creates the labels for the keys.  
		buttonMappedToName.set(0, "UP");
		buttonMappedToName.set(1, "DOWN");
		buttonMappedToName.set(2, "LEFT");
		buttonMappedToName.set(3, "RIGHT");
		*/
	}
	
	/**
	 * Adds a button to the InputHelper.
	 * @param	buttonName Name of the button to add.
	 */
	public static function addButton(buttonName:String) {
		var alreadyThere:Bool = false;
		
		for (value in buttonMappedToName) {
			if (value == buttonName.toUpperCase())
			alreadyThere = true;
		}
		
		if(!alreadyThere) {
		buttonMappedToName.set(getNumberOfButtons(), buttonName.toUpperCase());
		buttonPressedArray.push(false);
		buttonPressedLengthArray.push(0);
		}
	}

	
	/**
	 * Gets the ID of a button from the name
	 * @param	button The button we need to get.
	 * @return The ID of the button.
	 */
	private static function getButtonID(button:String):Int {
		for (key in buttonMappedToName.keys()) {
			if (button == buttonMappedToName.get(key))
			return key;
		}
		
		return -1;
	}
	
	/**
	 * Helper function that sets the InputHelper to listen for arrow keys.  Arrow key presses will now register when calling the justPressed or isPressed functions.
	 */
	public static function allowArrowKeys() {
		keyMappedToButton.set("UP", 0);
		keyMappedToButton.set("DOWN", 1);
		keyMappedToButton.set("LEFT", 2);
		keyMappedToButton.set("RIGHT", 3);
	}

	/**
	 * Helper function that sets WASD to keys 0,1,2,3 for QWERTY keyboard leyout users.
	 */
	public static function allowWASD() {
		keyMappedToButton.set("W", 0);
		keyMappedToButton.set("S", 1);
		keyMappedToButton.set("A", 2);
		keyMappedToButton.set("D", 3);
		
	}

	/**
	 * Helper function that sets ZQSD to keys 0,1,2,3 for AZERTY keyboard layout users.
	 */
		public static function allowZQSD() {
		keyMappedToButton.set("Z", 0);
		keyMappedToButton.set("S", 1);
		keyMappedToButton.set("Q", 2);
		keyMappedToButton.set("D", 3);
		
	}

	/**
	 * Maps a key to a button.  
	 * @param	key The key to map (as supplied by FlxG.keys as a string.  eg. "U","I", "CONTROL"...)  NOTE: THIS MUST MATCH THE STRING VALUES USED BY FlxG.keys EXACTLY OR THEY WILL NOT WORK.
	 * @param	button The button to assign this key to.
	 */
	public static function assignKeyToButton(key:String, button:String) {
		keyMappedToButton.set(key.toUpperCase(), getButtonID(button.toUpperCase()));
	}
	
	
	/**
	 * Updates the key values.  This should be called in the State's update mathod after the super.update() call but before the key queries.  
	 * @param	elapsedTime How much time has elapsed since the last call.  Defaults to 1 which counts how many update loops the key has been pressed for, but if you pass it FlxG.elapsed it will keep track of the time in seconds.
	 */
	public static function updateKeys(elapsedTime:Float = 1) {
		var currentlyDown = FlxG.keys.getIsDown();
		
		//Set everything to false.
		for (k in 0...buttonPressedArray.length)
		buttonPressedArray[k] = false;
		
		for (d in currentlyDown) {
			//Gets the button number for each of the keys currently being pressed on the keyboard.
			var temp = keyMappedToButton.get(d.ID.toString().toUpperCase());
			
			//trace("Key down " + temp);
			
			if (temp >= 0 && temp < buttonPressedArray.length) {
				buttonPressedArray[temp] = true;
			} 
			
		}
		
		//Go through and find all the keys that are down.  If they are down, increment the time they have been pressed.  If they are up, set the time pressed to 0.
		for (i in 0...buttonPressedArray.length) {
			if (buttonPressedArray[i]) {
				if (buttonPressedLengthArray[i] == 0)
				buttonPressedLengthArray[i] = 1;
				else
				buttonPressedLengthArray[i] += elapsedTime;
			} else
			buttonPressedLengthArray[i] = 0;
		}
	}
	
	public static function isButtonJustPressed(button:String):Bool {
		var t:Float = -1;
		t = isButtonPressedTime(button);
		
		if (t == 0 )
		return true;
		return false;
	}
	
	/**
	 * Is this button pressed?
	 * @param	buttonLabel The label of the button to check.  This is case insensitive.
	 * @return	True if the button is pressed.  Otherwise false.
	 */
	public static function isButtonPressed(button:String):Bool {
		var t:Float = -1;
		t = isButtonPressedTime(button);
		
		if (t != -1)
		return true;
		return false;
	}
	
	/**
	 * Gets the length of time the button has been pressed.  
	 * @param	The button to check.  This is case insensitive.
	 * @return	The length of time the key has been pressed.  Returns -1 if the key is not pressed currently.  Note that a 0 means that the key was pressed this update.
	 */
	public static function isButtonPressedTime(button:String):Float {
			var t = getButtonID(button.toUpperCase());
			if (buttonPressedLengthArray[t] > 0)
			return buttonPressedLengthArray[t] - 1;
			//else
			return -1;
	}
		
	
	/**
	 * Gets the total number of buttons including the default 4.
	 * @return
	 */
	public static function getNumberOfButtons():Int {
		return buttonPressedArray.length;
	}
	
	/**
	 * Gets the label for a button.
	 * @param	button The buttonID of the button we are retrieving the label for.
	 * @return The label for the button.
	 */
	public static function getButtonLabel(buttonID:Int):String {
		return buttonMappedToName.get(buttonID);
	}
	
	/**
	 * Gets all the keys assigned to the supplied button.
	 * @param	buttonLabel The label of the button to check.
	 * @return An array with all the keys assigned to that button.
	 */
	public static function getKeysAssignedToButton(button:String) : Array<String> {
		var output:Array<String> = [];
		
		//Get the button ID assigne to this label.
		var buttonID:Int = -1;
		//Get the buttonID of the button we supplied.
		for (key in buttonMappedToName.keys()) {
			if (buttonMappedToName.get(key) == button.toUpperCase())
			buttonID = key;
		}
		//Now find all the keys that are mapped to this buttonID
		for (key in keyMappedToButton.keys()) {
			if (keyMappedToButton.get(key) == buttonID) {
				output.push(key);
			}
		}
		
		
		return output;
	}
	
	/**
	 * Gets a list of all the buttons, if they are pressed, and how long they have been pressed for.
	 * @return A string with all the data.
	 */
	public static function debug():String {
		var s:String = "";

		for (key in InputHelper.buttonMappedToName.keys()) {
		s += "Button ID " + key + " is " + InputHelper.buttonMappedToName.get(key)+ "\n";
		s += InputHelper.buttonMappedToName.get(key) + " pressed for " + (buttonPressedLengthArray[key] -1 )+ " seconds.\n";
		}
		
		for (key in InputHelper.keyMappedToButton.keys())
		s += "Key " + key + " is assigned to Button ID " + InputHelper.keyMappedToButton.get(key) + "\n";
		//s += "There are a total of " + InputHelper.buttonPressedLengthArray.length + " entries in the key length array.\n";
		//s += "There are a total of " + InputHelper.buttonPressedArray.length + " entries in the key pressed array.\n";
		
		s += buttonPressedArray.toString() + "\n";
		s += buttonPressedLengthArray.toString() + "\n";
		
		
		return s;
	}
}

