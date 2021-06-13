package game.states;

import game.objects.Walk;
import game.objects.Fast;

class LevelTwoState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0002_Level_1');
	}

	override public function addWords() {
		var walk = new Walk(30, 30);
		wordGrp.add(walk);
	}

	override public function nextLevel() {
		return new LevelThreeState();
	}
}