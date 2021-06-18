package game.states;

class LevelTwoState extends PlayState {
	override public function create() {
		super.create();
		createLevel(project.all_levels.Level_1);
	}

	override public function nextLevel() {
		return new LevelThreeState();
	}
}