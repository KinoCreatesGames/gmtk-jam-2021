package game.states;

import game.objects.Walk;
import game.objects.Fast;

class LevelOneState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0001_Level_0');
	}

	override function addWords() {
		var word = new Walk(30, 30);
		wordGrp.add(word);
	}

	override function nextLevel():FlxState {
		return new LevelTwoState();
	}
}