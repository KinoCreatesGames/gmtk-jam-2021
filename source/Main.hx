package;

import game.states.LevelSevenState;
import game.states.LevelSixState;
import game.states.LevelFiveState;
import game.states.LevelFourState;
import game.states.LevelThreeState;
import game.states.LevelTwoState;
import game.states.LevelOneState;
import game.states.TitleState;
import flixel.FlxGame;
import openfl.display.Sprite;
import game.states.PlayState;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, LevelSevenState));
	}
}