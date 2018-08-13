package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class HelpSubState extends FlxSubState 
{

	var images:Array<String>;
	var directions:FlxSprite;
	var nextBtn:FlxButton;
	public function new() 
	{
		super(FlxColor.BLACK);
		images = [
		'assets/images/p1.png',
		'assets/images/p2.png',
		'assets/images/p3.png'
		];
		
		var t = new FlxText(0, 10, FlxG.width, 'Instructions', 26 );
		t.setFormat(null, 26, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(t);
		directions = new FlxSprite();
		add(directions);
		next();
		nextBtn = new FlxButton(300,370, 'Next', next);
		add(nextBtn);
	}
	
	function next() {
		if (images.length == 0) {
			_parentState.closeSubState();
			return;
		}
			
		
		var i = images.shift();
		directions.destroy();
		directions = new FlxSprite(0,0,i);
		//directions.loadGraphic(i, false);
		directions.centerOffsets();
		directions.centerOrigin();
		directions.screenCenter();
		add(directions);
		
		if (nextBtn != null) {
			nextBtn.destroy();
			nextBtn = new FlxButton(300, 370, 'Next', next);
			add(nextBtn);
			
		}
		
		
		if (images.length == 0)
		nextBtn.text = 'Menu';
			
		
	}
	
}