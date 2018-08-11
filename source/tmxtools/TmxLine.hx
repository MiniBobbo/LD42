package tmxtools;
import flixel.math.FlxPoint;
import haxe.ds.StringMap;

/**
 * @author 
 */
typedef TmxLine =
{
	name:String,
	points:Array<FlxPoint>,
	properties:StringMap<String>	
}