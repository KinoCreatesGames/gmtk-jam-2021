package game.states;

import game.objects.Reverse;
import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelFourState extends PlayState {
	override public function create() {
		super.create();
		createLevel(project.all_levels.Level_3);
	}

	override public function nextLevel() {
		return new LevelFiveState();
	}
}