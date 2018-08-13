package;
import entities.Ship;
import factories.EffectFactory;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import signal.ISignal;
import states.DefeatState;
import states.GameState;

/**
 * ...
 * @author Dave
 */
class CutsceneManager implements ISignal
{
	var timer:FlxTimer;
	var timer2:FlxTimer;
	var gs:GameState;
	public function new() 
	{
		timer = new FlxTimer();
		timer2 = new FlxTimer();
	}

	
	public function getSignal(signal:String, ?data:Dynamic):Void {
		switch (signal) 
		{
			case 'defeat':
				gs = H.gs;
				gs.state = LevelState.LOSS;
				H.signalAll('stop');
				timer.start(3,focusOnShip);
				
				
			default:
				
		}
	}

	function focusOnShip(_) {
		var p = H.getShipMidpoint();
		
		FlxTween.tween(gs.camTarget, {x:p.x, y:p.y}, 1);
		timer.start(2, explodeShip);
	}
	
	
	function explodeShip(_) {
		var s:Ship = gs.ship;
		timer.start(4, flashScreen);
		timer2.start(.2, function(_) {
			trace('Should be exploding');
			var p = FlxPoint.get(s.x, s.y);
			p.x += FlxG.random.float(0, s.width);
			p.y += FlxG.random.float(0, s.height);
			EffectFactory.fgeffect(p, EffectType.EXPLODE);
		}, 0);
		MM.fadeMusic();
	}
	
	function flashScreen(_) {
		timer2.cancel();
		FlxG.camera.flash(FlxColor.WHITE, 100);
		//var cover = new FlxSprite(0, 0);
		//cover.makeGraphic(FlxColor.WHITE, FlxG.width, FlxG.height);
		//cover.scrollFactor.set();
		//gs.add(cover);
		timer.start(1, fade);
	}
	
	function fade(_) {
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
			FlxG.switchState(new DefeatState());
			
		});
	}
}