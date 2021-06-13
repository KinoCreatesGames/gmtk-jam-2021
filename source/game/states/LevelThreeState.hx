package game.states;

import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelThreeState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0003_Level_2');
	}

	override public function addWords() {
		var walk = new Walk(30, 30);
		var fast = new Fast(60, 60);
		var jump = new Jump(90, 90);
		wordGrp.add(walk);
		wordGrp.add(fast);
		wordGrp.add(jump);
	}
}