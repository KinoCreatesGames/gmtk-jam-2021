package game.states;

class LevelFiveState extends PlayState {
	override public function create() {
		super.create();
		createLevel(project.all_levels.Level_4);
	}

	override public function nextLevel() {
		return new LevelSixState();
	}
}