package game.states;

import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelThreeState extends PlayState {
	override public function create() {
		super.create();
		createLevel(project.all_levels.Level_2);
	}

	override public function nextLevel() {
		return new LevelFourState();
	}
}