package game.states;

import game.objects.Large;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends BaseGameState {
	override public function create() {
		super.create();
		add(new FlxText("Hello World", 32).screenCenter());
		add(new Large(30, 30));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processStateTransition(elapsed);
	}

	function processStateTransition(elapsed:Float) {
		var pause = FlxG.keys.anyJustPressed([ESCAPE]);
		if (pause) {
			if (!pauseSound.playing) {
				// Automatically pauses the game using the function openPauseState
				pauseSound.play();
				openPauseState();
			}
		}
	}
}