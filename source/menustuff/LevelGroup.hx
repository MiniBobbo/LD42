package menustuff;

import factories.LevelFactory;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import states.GameState;

/**
 * ...
 * @author Dave
 */
class LevelGroup extends FlxSpriteGroup 
{

	var btn:FlxButton;
	var name:String;
	
	var STAR_X:Float = 100;
	var STAR_Y:Float = 0;
	var STAR_WIDTH:Float = 17;
	var STAR_SPACE:Float = 21;
	
	
	public function new(name:String) 
	{
		super();
		this.name = name;
		btn = new FlxButton(0, 0, name, clicked);
		add(btn);
		var stars:Array<Bool> = [];
		for (i in 0...3){
			stars.push(false);
		}
		loadStarsFromSave(stars);
		
		var s1 = makeStar();
		s1.setPosition(STAR_X, STAR_Y);
		if (stars[0])
			s1.animation.play('yes');
		add(s1);

		var s2 = makeStar();
		s2.setPosition(STAR_X + STAR_SPACE, STAR_Y);
		if (stars[1])
			s2.animation.play('yes');
		add(s2);


		var s3 = makeStar();
		s3.setPosition(STAR_X + STAR_SPACE * 2, STAR_Y);
		if (stars[2])
			s3.animation.play('yes');
		add(s3);
	}
	
	private function makeStar():FlxSprite {
		var s1 = new FlxSprite();
		s1.loadGraphic('assets/images/stars.png', true, 17, 17);
		s1.animation.add('no', [0]);
		s1.animation.add('yes', [1]);
		s1.animation.play('no');
		
		return s1;
		
	}
	
	private function loadStarsFromSave(stars:Array<Bool>) {
		var rank = H.getLevelRank(name);
		if (rank >= 1) {
			stars[0] = true;
		}
		if (rank >= 2) {
			stars[1] = true;
		}
		if (rank >= 3) {
			stars[2] = true;
		}
		
	}
	
	private function clicked() {
		trace('Loading level');
		H.currentLevel = LevelFactory.createLevel(name);
		trace('Created level: ' + H.currentLevel);
		FlxG.switchState(new GameState() );
	}
}