package logs;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class Logger 
{
	static var _loggingLevel:Int = 3;
	
	/**
	 * Displays a message to the console if it is below the logging level.
	 * @param	tag		Tag of this message
	 * @param	message	Message	
	 * @param	level	Message level.  3 - info, 2 - warning, 1 - error
	 */
	public static function addLog(tag:String, message:String, level:Int = 3) {
		var prefix = 'Msg';
		if (level == 1)
			prefix = '***ERROR***';
		if (level == 2)
			prefix = 'WARNING';
		
		if (level <= _loggingLevel) {
			FlxG.log.add(prefix + ': ' +  tag + ': ' + message);
		}
	}
	
	/**
	 * Sets the logging display level.  Only messages equal to or below this level should be displayed.
	 * Generally 1 = error, 2 = warning, 3 = info.
	 * @param	level	New level.
	 */
	public static function setLogDisplayLevel(level:Int) {
		_loggingLevel = level;
	}
}