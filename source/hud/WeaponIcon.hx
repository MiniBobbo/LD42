package hud;

import attacks.UnivAttack.AttackTypes;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class WeaponIcon extends FlxText 
{
	public var type:AttackTypes;
	public function new(type:AttackTypes) 
	{
		super(0, 0, 50, type + '', 12);
		setFormat(null, 12, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		this.type = type;
		scrollFactor.set();
	}
	
}