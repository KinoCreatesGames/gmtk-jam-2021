package game.states;

import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelFourState extends PlayState {
	override public function create() {
		super.create();
		createLevel('00004_Level_3');
	}

	override public function addWords() {
		var walk = new Walk(30, 30);
		var fast = new Fast(30, 60);
		var fastTwo = new Fast(60, 60);
		var jump = new Jump(30, 90);
		wordGrp.add(walk);
		wordGrp.add(fast);
		wordGrp.add(fastTwo);
		wordGrp.add(jump);
	}
}